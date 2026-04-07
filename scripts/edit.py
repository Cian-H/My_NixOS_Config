#!/usr/bin/env python3
import typer
import subprocess
from pathlib import Path
import mimetypes


def is_text_file(filepath: str):
    mime_type, _ = mimetypes.guess_type(filepath)
    if mime_type:
        return mime_type.startswith("text/")

    try:
        with open(filepath, "rb") as f:
            chunk = f.read(1024)
            if b"\0" in chunk:
                return False  # Null bytes usually mean binary
        return True
    except IsADirectoryError:
        return False


app = typer.Typer()


@app.command()
def edit(target: Path = typer.Argument(..., help="File or directory to edit")):
    if not target.exists():
        subprocess.run(["nvim", str(target)])
        return

    if target.is_dir():
        subprocess.run(["yazi", str(target)])
        return

    if is_text_file(str(target)):
        subprocess.run(["nvim", str(target)])
    else:
        subprocess.run(["heh", str(target)])


if __name__ == "__main__":
    app()
