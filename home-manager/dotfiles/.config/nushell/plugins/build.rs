use data_encoding::HEXLOWER;
use flate2::read::GzDecoder;
use git2::Repository;
use reqwest::blocking;
use ring::digest::{Context, Digest, SHA256};
use serde::{Deserialize, Serialize};
use std::env;
use std::fs::File;
use std::path::Path;
use std::process::Command;
use tar::Archive;
use toml::{Table, Value};

static CRATES_API_URL: &str = "https://crates.io/api/v1/crates/";
static CRATE_CACHE_DIR: &str = ".crate_cache";
static NON_PLUGIN_CRATES: [&str; 3] = ["nu-lsp", "nu-plugin", "nu-protocol"];
static APP_USER_AGENT: &str = concat!(
    env!("CARGO_PKG_NAME"),
    "/plugin_fetcher/",
    env!("CARGO_PKG_VERSION")
);

struct AppClient {
    client: Option<blocking::Client>,
}
impl AppClient {
    fn client(&mut self) -> &Option<blocking::Client> {
        if self.client.is_none() {
            let client = blocking::Client::builder()
                .user_agent(APP_USER_AGENT)
                .build()
                .unwrap();
            self.client = Some(client);
        };
        &self.client
    }
}

static mut CLIENT: AppClient = AppClient { client: None };

fn main() -> Result<(), Box<dyn std::error::Error>> {
    fetch_plugin_sources()?;
    compile_plugins()?;
    Ok(())
}

fn compile_plugins() -> Result<(), Box<dyn std::error::Error>> {
    // The downloaded source code for the plugins will be at the `plugins_dir` directory
    let plugin_src_dir = Path::new(&env::var("OUT_DIR")?).join("src");
    // First, we need to list all the plugin folders in `plugins_dir`
    let plugin_dirs = std::fs::read_dir(&plugin_src_dir)?
        .map(|res| res.map(|e| e.path()))
        .collect::<Result<Vec<_>, std::io::Error>>()?;
    // Then, we compile each plugin with cargo and move the resulting binary to the project's root directory
    let root_dir = env::current_dir()?;
    for plugin_dir in plugin_dirs {
        env::set_current_dir(&plugin_dir)?;
        // By convention, the plugin name and version will be the name of the folder, separated by a dash
        // So, by splitting the file name at the dash and taking the first part, we get the plugin name
        let plugin_dirname = plugin_dir
            .file_name()
            .ok_or("Invalid plugin directory")?
            .to_string_lossy();
        let plugin_name = plugin_dirname
            .split('-')
            .next()
            .ok_or("Invalid plugin directory")?;

        println!("Compiling plugin at {:?}", plugin_dir);
        
        Command::new("cargo")
            .args(&["build", "--release"])
            .status()?;

        // In the build dir, the binary will be named the plugin name without any extension
        let plugin_bin = plugin_dir.join("target").join("release").join(plugin_name);
        // Finally, we can move the binary to the root directory
        let plugin_bin_dest = root_dir.join(plugin_name);
        std::fs::copy(&plugin_bin, &plugin_bin_dest)?;
    }
    // After all the plugins are compiled and moved, we return to the root directory
    env::set_current_dir(root_dir)?;

    Ok(())
}

fn fetch_plugin_sources() -> Result<(), Box<dyn std::error::Error>> {
    // Before we fetch the source code for the plugins, we need to make sure the OUT_DIR/src directory exists and is empty
    let out_dir = env::var("OUT_DIR")?;
    let src_dir = Path::new(&out_dir).join("src");
    if src_dir.exists() {
        std::fs::remove_dir_all(&src_dir)?;
    }
    std::fs::create_dir_all(&src_dir)?;
    
    let cargo_toml_path = Path::new(&env::var("CARGO_MANIFEST_DIR")?).join("Cargo.toml");
    let cargo_toml_contents =
        std::fs::read_to_string(cargo_toml_path).expect("Failed to read Cargo.toml");

    let dependencies = get_dependency_names(&cargo_toml_contents)?;
    let plugin_dependencies: Vec<(String, Value)> = dependencies
        .into_iter()
        .filter(|(name, _)| !NON_PLUGIN_CRATES.contains(&name.as_str()))
        .collect();

    for (name, value) in plugin_dependencies {
        fetch_plugin_source_code(&name, &value)?;
    }

    Ok(())
}

fn get_dependency_names(
    cargo_toml_contents: &str,
) -> Result<Vec<(String, Value)>, Box<dyn std::error::Error>> {
    // This function parses the Cargo.toml file and gets the names of all dependencies
    let cargo_table = cargo_toml_contents.parse::<Table>()?;
    let dependency_table: &Value = cargo_table
        .get("target")
        .ok_or("No target section found in Cargo.toml")?
        .get("plugins")
        .ok_or("No plugin target found in Cargo.toml")?
        .get("dependencies")
        .ok_or("No plugin dependencies found in Cargo.toml")?;
    match dependency_table {
        Value::Table(table) => Ok(table.iter().map(|(k, v)| (k.clone(), v.clone())).collect()),
        _ => Err("Invalid dependencies section in Cargo.toml".into()),
    }
}

fn fetch_plugin_source_code(
    name: &String,
    value: &Value,
) -> Result<(), Box<dyn std::error::Error>> {
    match value {
        Value::String(s) => {
            // If the value is a valid url, we assume it's a git repository
            if reqwest::Url::parse(s).is_ok() {
                fetch_source_from_git(name, s)?;
                Ok(())
            } else {
                // Otherwise, its either a version or a path
                if std::fs::metadata(s).is_ok() {
                    // If it's a path, we assume it's a local dependency and i don't plan to
                    // support it unless i find a good use case for it
                    return Err("Local dependencies are not supported".into());
                } else {
                    // If it's a version, we assume it's a dependency from crates.io
                    let version = s.clone();
                    fetch_source_from_cratesio(name, &version)?;
                    Ok(())
                }
            }
        }
        Value::Table(table) => {
            // If the value is a table, it's either pointing to a git repo or a crates.io dependency
            // The easiest way to check is to see if it has a "git" key
            let git_url = get_string_from_table(table, "git");
            match git_url {
                // TODO: This code doesn't handle the case where we have a git url and a version
                Ok(url) => {
                    if reqwest::Url::parse(&url).is_ok() {
                        fetch_source_from_git(name, &url)?;
                        Ok(())
                    } else {
                        Err("Invalid git url".into())
                    }
                }
                Err(_) => {
                    let version = get_version_from_entry(value)?;
                    fetch_source_from_cratesio(name, &version)?;
                    Ok(())
                }
            }
        }
        _ => Err("Invalid dependency".into()),
    }
}

#[derive(Serialize, Deserialize, Debug)]
struct CratesIOResponse {
    version: Option<CratesIOVersion>,
}

#[derive(Serialize, Deserialize, Debug)]
struct CratesIOVersion {
    checksum: Option<String>,
}

fn fetch_source_from_cratesio(
    name: &str,
    version: &str,
) -> Result<String, Box<dyn std::error::Error>> {
    let out_dir = env::var("OUT_DIR")?;
    // first we construct the URL to fetch the source code from
    let url = format!("{}{}/{}", CRATES_API_URL, name, version);
    // Then, we check if the crate is already in the cache
    let cached_crate = Path::new(&out_dir)
        .join(CRATE_CACHE_DIR)
        .join(format!("{}.crate", name));
    std::fs::create_dir_all(cached_crate.parent().unwrap())?;
    let client = unsafe { CLIENT.client() }.as_ref().unwrap();
    if cached_crate.exists() {
        // If it is, we check if the sha256 checksum matches
        let checksum_cratesio = client
            .get(&url)
            .send()?
            .json::<CratesIOResponse>()?
            .version
            .ok_or("No version found in response")?
            .checksum
            .ok_or("No checksum found in response")?;
        let crate_file = File::open(&cached_crate)?;
        let checksum_cache = HEXLOWER.encode(sha256_digest(crate_file)?.as_ref());
        if checksum_cache != checksum_cratesio {
            // If it doesn't, we remove the cached crate
            std::fs::remove_file(&cached_crate)?;
            // And we fetch the crate from crates.io
            std::fs::write(
                &cached_crate,
                client.get(&format!("{}/download", url)).send()?.bytes()?,
            )?;
        }
    } else {
        // If it isn't, we fetch the crate from crates.io
        std::fs::write(
            &cached_crate,
            client.get(&format!("{}/download", url)).send()?.bytes()?,
        )?;
    };

    // Now that we know the crate is in the cache, we unpack it to OUT_DIR/src
    // Note: .crate files are just .tar.gz files with a different extension
    let crate_tar = File::open(&cached_crate)?;
    let mut archive = Archive::new(GzDecoder::new(crate_tar));
    let unpack_dir = Path::new(&out_dir).join("src");
    archive.unpack(&unpack_dir)?;

    // Finally, we return the path to the unpacked crate
    Ok(unpack_dir.to_string_lossy().to_string())
}

#[derive(Debug)]
enum CargoParseError {
    InvalidDependencyTable,
    ValueNotFound,
    InvalidValue,
}

impl std::fmt::Display for CargoParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            CargoParseError::InvalidDependencyTable => write!(f, "Invalid dependency table"),
            CargoParseError::ValueNotFound => write!(f, "Value not found"),
            CargoParseError::InvalidValue => write!(f, "Invalid value"),
        }
    }
}

impl std::error::Error for CargoParseError {}

fn get_version_from_entry(value: &Value) -> Result<String, CargoParseError> {
    match value {
        Value::String(s) => Ok(s.clone()),
        Value::Table(table) => get_string_from_table(table, "version"),
        _ => Err(CargoParseError::InvalidDependencyTable),
    }
}

fn get_string_from_table(table: &Table, key: &str) -> Result<String, CargoParseError> {
    let result = table
        .get(key)
        .ok_or(CargoParseError::ValueNotFound)?
        .clone();
    match result {
        Value::String(s) => Ok(s),
        _ => Err(CargoParseError::InvalidValue),
    }
}

fn sha256_digest<R: std::io::Read>(mut reader: R) -> Result<Digest, Box<dyn std::error::Error>> {
    let mut context = Context::new(&SHA256);
    let mut buffer = [0; 1024];

    loop {
        let count = reader.read(&mut buffer)?;
        if count == 0 {
            break;
        }
        context.update(&buffer[..count]);
    }

    Ok(context.finish())
}

fn fetch_source_from_git(name: &str, url: &str) -> Result<String, Box<dyn std::error::Error>> {
    // This way of getting hte source code is obviously much simpler and more efficient
    let out_dir = env::var("OUT_DIR")?;
    let unpack_dir = Path::new(&out_dir).join("src").join(name);
    if unpack_dir.exists() {
        let repo = Repository::open(&unpack_dir)?;
        let mut remote = repo.find_remote("origin")?;
        remote.fetch(&["master"], None, None)?;
    } else {
        Repository::clone(url, &unpack_dir)?;
    }
    Ok(unpack_dir.to_string_lossy().to_string())
}
