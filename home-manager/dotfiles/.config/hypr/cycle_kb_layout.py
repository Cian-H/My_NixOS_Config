#!/usr/bin/env python

# For some reason hyprland doesnt have kb layout toggling and
# uses some weird, custom, cursed, whitespace based JSONC
# variant. This is a simple, clumsy, manual parse and toggle job

from itertools import takewhile
from pathlib import Path

layouts = ["ie", "us"] * 2 # this *2 prevents overflow

hypr_dir = Path(__file__).parent
config_file = hypr_dir / "inputs.conf"
value_to_change = "kb_layout"

def is_target_line(line: str) -> bool:
    return value_to_change in line

def read_current_config() -> list[str]:
    with config_file.open("rt") as f:
        out = list(f.readlines())
    return out

def write_new_config(lines: list[str]) -> None:
    with config_file.open("wt") as f:
        f.write("".join(lines))

def is_whitespace(x: str) -> bool:
    return (x == " ") or (x == "\t")

def toggle_line(line: str) -> str:
    indent = "".join(takewhile(is_whitespace, line))
    code, *comments = line.strip().split("#")
    tokens = code.split(" ")
    current_layout = tokens[-1]
    new_layout = layouts[layouts.index(current_layout) + 1]
    new_tokens = tokens.copy()
    new_tokens[-1] = new_layout
    new_code = " ".join(new_tokens)
    new_line = "#".join([f"{new_code} ",] + comments) if comments else new_code
    return f"{indent}{new_line}\n"

def cycle_kb_layout() -> None:
    current_config = read_current_config()
    new_config = [
        toggle_line(x) if value_to_change in x else x for x in current_config
    ]
    write_new_config(new_config)

def main() -> None:
    cycle_kb_layout()

if __name__ == "__main__":
    main()
