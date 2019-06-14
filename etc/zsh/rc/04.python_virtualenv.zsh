# -*- zsh -*-

export VIRTUALENVWRAPPER_PYTHON=$(which python3 2>/dev/null || echo "python3")
source_if_exists "$(brew --prefix)/bin/virtualenvwrapper.sh"
