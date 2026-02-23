{pkgs}:
pkgs.writeShellApplication {
  name = "rbw-autofill";
  runtimeInputs = [pkgs.bash pkgs.libsecret pkgs.zenity];
  text = builtins.readFile ./script.sh;
}
