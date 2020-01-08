# -*- zsh -*-

export VIRTUALENVWRAPPER_PYTHON=${VIRTUALENVWRAPPER_PYTHON:-$(which python3 2>/dev/null || echo "python3")}
[[ -n "$BREW_PREFIX" ]] && source_if_exists "$BREW_PREFIX/bin/virtualenvwrapper.sh"
source_if_exists "$HOME/.local/bin/virtualenvwrapper.sh"
