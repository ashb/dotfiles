# -*- Mode: zsh; tab-width: 4; indent-tabs-mode: nil; -*-
#
#       Set SSH_AUTH_SOCK if systemd-controlled one found

[[ -z "$SSH_AUTH_SOCK" && -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]] && export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
