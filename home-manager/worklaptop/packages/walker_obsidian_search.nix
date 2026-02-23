{pkgs}:
pkgs.writeShellApplication {
  name = "walker-obsidian-search";
  runtimeInputs = [pkgs.babashka pkgs.ripgrep];
  text = builtins.readFile ./walker_obsidian_search.clj;
}
