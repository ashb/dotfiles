# github:etc/bash/os/Linux/10.color
# -*- Mode: Bash; tab-width: 4; indent-tabs-mode: nil; -*-
#
#       Setup ls and other tools to use color

eval $(dircolors)
alias ls='ls --color=auto'
alias grep='grep --color=auto'
export LESS='--RAW-CONTROL-CHARS'
