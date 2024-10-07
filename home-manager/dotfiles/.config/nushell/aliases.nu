# aliases for modern unix rebindings
export alias cat = bat
# export alias ls = lsd
export alias du = dust
export alias df = duf
export alias grep = rg
export alias cp = xcp
export alias find = fd
export alias top = btm
export alias htop = btm
export alias burn = rm # sometimes, you ACTUALLY need rm
export alias rm = rip

# Personal convenience aliases
export alias free = free -m
export alias npkg = nano -w PKGBUILD
export alias q = exit
export alias ':q' = exit
export alias c = clear
export alias h = history
export alias lsa = ls -a
export alias lsl = ls -l
export alias lsla = ls -la
export alias .. = cd ..
export alias ... = cd ../..
export alias .... = cd ../../..
export alias ..... = cd ../../../..
# export alias pip = python -m pip
export alias pip-upgrade = python -m pip install --upgrade pip
export alias pypy = pypy3
export alias poem = poetry run python
export alias bashpoem = poetry run bash
export alias nupoem = poetry run nu
export alias jupyterpoem = poetry run jupyter

# Aliases for custom git commands
export alias git-ammend = git commit -a --amend -C HEAD

# Who even uses vim or *especially* vi in this day and age?
export alias vim = nvim
export alias vi = nvim

# NixOS specific aliases
export alias nix-nu = nix-shell --command nu
