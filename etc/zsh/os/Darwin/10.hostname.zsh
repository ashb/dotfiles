if [[ "${FIX_HOSTNAME_ON_OSX:-yes}" = 'yes' ]]; then
    export   HOST=$( scutil --get LocalHostName | sed -e "s/-.*//" )
    export DOMAIN=$(
        scutil --get LocalHostName | sed -e "s/${HOST}-//" -e 's/-/./'
    )
fi
