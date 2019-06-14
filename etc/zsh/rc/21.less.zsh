# -*- sh -*-

export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking - but dont
export LESS_TERMCAP_md=$'\e[01;33;5;74m'  # begin bold - and yellow
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_so="$(tput smso)"     # begin standout-mode - info box
export LESS_TERMCAP_se="$(tput rmso)"     # end standout-mode
export LESS_TERMCAP_us=$'\e[04;38;5;146m' # begin underline - and make it purlpe
export LESS_TERMCAP_ue=$'\e[0m'           # end underline
