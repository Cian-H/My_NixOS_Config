#! /usr/bin/env bash

SCRIPT_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

cd "$SCRIPT_DIR"

go build -o ./cycle_kb_layout ./src/cycle_kb_layout.go
