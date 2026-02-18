{pkgs}:
pkgs.writeShellApplication {
  name = "rbw-autofill";
  runtimeInputs = [pkgs.bash pkgs.libsecret pkgs.zenity];

  text = ''
    #!/usr/bin/env bash
    echo "OK"
    while read -r line; do
      if [[ "$line" == "GETPIN" ]]; then
        pass=$(secret-tool lookup application rbw 2>/dev/null)
        if [[ -z "$pass" ]]; then
            pass=$(zenity --password --title="rbw Setup" --text="Enter Bitwarden Master Password to save to Keyring:")
            if [[ -n "$pass" ]]; then
                printf "%s" "$pass" | secret-tool store --label="rbw" application rbw
            else
                echo "ERR 100 Password retrieval cancelled"
                exit 1
            fi
        fi
        printf "D %s\n" "$pass"
        echo "OK"
        exit 0
      fi
      echo "OK"
    done
  '';
}
