# -*- zsh -*-

autoload -U promptinit colors
promptinit
prompt pure

#PURE_GIT_UNTRACKED="%F{cyan} ?"
PURE_GIT_DIRTY="%F{130}✗"
PURE_GIT_UP_ARROW="▴"
PURE_GIT_DOWN_ARROW="▾"

#PURE_PROMPT_SYMBOL="❯"


RPROMPT='%F{059]%}[%T] %(?,%F{022}%{%G✓%},%F{130}[$?]) !%!%f'


prompt pure

# Overridew the render_VCS function to customize how I want!

