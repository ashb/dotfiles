export HOSTOS="${(C)OSTYPE/[0-1]*/}"

# The current domain name.
export DOMAIN="$(hostname | sed -e "s/[^.]*\.//")"
