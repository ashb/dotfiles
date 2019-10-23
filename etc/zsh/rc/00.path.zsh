# -*- Mode: Bash; tab-width: 4; indent-tabs-mode: nil; -*-
#       Tweak default paths. 

path_prepend '/usr/sbin'
path_prepend '/usr/bin'
path_prepend '/sbin'
path_prepend '/bin'
path_prepend "${HOME}/bin"
path_prepend "${HOME}/bin/${HOSTOS}"

path_append "/Applications/Docker.app/Contents/Resources/bin/"
path_prepend "${BREW_PREFIX}/opt/gnu-getopt/bin"
path_prepend "${HOME}/.local/bin"
