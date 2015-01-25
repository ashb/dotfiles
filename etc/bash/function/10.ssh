# -*- Mode: Bash; tab-width: 4; indent-tabs-mode: nil; -*-
#
#       SSH Auth socket/agent forwarding for when resttaching screen/tmux sessions


function link_ssh_authsock {
    local old_umask
    old_umask=$(umask)
    umask 77
    if [ -n "$SSH_AUTH_SOCK" -a ! -L "$SSH_AUTH_SOCK" ]; then
        if mkdir ~/.ssh/auth_sock.lock
        then
          ln -sf $SSH_AUTH_SOCK ~/.ssh/auth_sock
          rmdir ~/.ssh/auth_sock.lock
        fi
        export SSH_AUTH_SOCK_OLD=$SSH_AUTH_SOCK
        export SSH_AUTH_SOCK=$HOME/.ssh/auth_sock
    fi
    umask $old_umask
}

function unlink_ssh_authsock {
    local sock
    for sock in $(find_ssh_auth_socks \
    | eval "xargs stat $(stat_creation_time_and_name_args)" \
    | sort -n \
    | cut -d' ' -f 2)
    do
        # Check if this socket is alive and working
        if ! SSH_AUTH_SOCK=$sock ssh-add -l 2>&1 | grep -q "Could not open"; then
            ln -sf $sock ~/.ssh/auth_sock
            unset SSH_AUTH_SOCK_OLD
            export SSH_AUTH_SOCK=$sock
        fi
    done

    # If $SSH_AUTH_SOCK_OLD is still set, it did not work out. Remove the symlink
    if [ -n "$SSH_AUTH_SOCK_OLD" ]; then
        rm -f ~/.ssh/auth_sock
    fi
}
