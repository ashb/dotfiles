# github:etc/bash/os/Darwin/10.color
# -*- Mode: Bash; tab-width: 4; indent-tabs-mode: nil; -*-
#
#       Setup ls (and other progs?) to use color

# Colors are:
#
# a     black
# b     red
# c     green
# d     brown
# e     blue
# f     magenta
# g     cyan
# h     light grey
# A     bold black, usually shows up as dark grey
# B     bold red
# C     bold green
# D     bold brown, usually shows up as yellow
# E     bold blue
# F     bold magenta
# G     bold cyan
# H     bold light grey; looks like bright white
# x     default foreground or background

# Each pair of characters is color for:
#  1.   directory
#  2.   symbolic link
#  3.   socket
#  4.   pipe
#  5.   executable
#  6.   block special
#  7.   character special
#  8.   executable with setuid bit set
#  9.   executable with setgid bit set
#  10.  directory writable to others, with sticky bit
#  11.  directory writable to others, without sticky bit

export CLICOLOR=1
export LSCOLORS=dxfxcxdxbxegedabagacad
