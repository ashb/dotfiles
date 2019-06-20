# zsh.sourceforge.net/Doc/Release/Completion-System.html
zmodload -i zsh/complist

autoload -U compinit compaudit

export ZSH_COMPDUMP="${HOME}/var/zsh-${HOST}-${ZSH_VERSION}"

setopt extendedglob
if [[ $ZSH_DISABLE_COMPFIX != true ]] && ! compaudit &>/dev/null; then
  # If completion insecurities exist, warn the user without enabling completions.
  handle_completion_insecurities
# Else, enable and cache completions to the desired file.
else
  if [[ -n "${ZSH_COMPDUMP}"(#qN.mh+24) ]]; then
    compinit -d "${ZSH_COMPDUMP}"
    compdump
  else
    compinit -C -d "${ZSH_COMPDUMP}"
  fi
fi

unsetopt extendedglob

WORDCHARS=''

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_list         # show completion menu on _FIRST_ tab press
setopt complete_in_word
setopt always_to_end

# case insensitive (all), partial-word and substring completion
# https://github.com/robbyrussell/oh-my-zsh/blob/e8aba1bf5912f89f408eaebd1bc74c25ba32a62c/lib/completion.zsh#L23
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

# Menu selection
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
# Highlight
zstyle ':completion:*' menu select
# Tag name as group name
zstyle ':completion:*' group-name ''
# Format group names
zstyle ':completion:*' format '%B---- %d%b'

# Use Gnu-LS colors for ZSH file completion too
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"


# Delete Git's official completions to allow Zsh's official Git completions to work.
# Git ships with really bad Zsh completions. Zsh provides its own completions
# for Git, and they are much better.
# https://github.com/Homebrew/homebrew-core/issues/33275#issuecomment-432528793
# https://twitter.com/OliverJAsh/status/1068483170578964480
# Unfortunately it's not possible to install Git without completions (since
# https://github.com/Homebrew/homebrew-core/commit/f710a1395f44224e4bcc3518ee9c13a0dc850be1#r30588883),
# so in order to use Zsh's own completions, we must delete Git's completions.
# This is also necessary for hub's Zsh completions to work:
# https://github.com/github/hub/issues/1956.
function () {
  GIT_ZSH_COMPLETIONS_FILE_PATH="$(brew --prefix)/share/zsh/site-functions/_git"
  if [ -f $GIT_ZSH_COMPLETIONS_FILE_PATH ]
  then
    rm $GIT_ZSH_COMPLETIONS_FILE_PATH
  fi
}

#
# zsh-history-substring-search
#

# Load from Brew
# As per `brew info zsh-history-substring-search`
source_if_exists $BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh
# Bind UP and DOWN arrow keys
# Copied from https://github.com/zsh-users/zsh-history-substring-search/tree/47a7d416c652a109f6e8856081abc042b50125f4#usage
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
