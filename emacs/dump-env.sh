#!/usr/bin/env bash

set -e

# Remove old environment file if found
if [ -f "env.el" ]; then
    rm env.el
    echo "Old configuration found and removed"
fi

# Format the current environment variables for usage in Emacs
echo '(' >> env.el
$SHELL -ic /usr/bin/env \
    | grep -v -e "^HOME$" \
        -e "^\\(OLD\\)?PWD" \
        -e "^SHLVL" \
        -e "^PS1" \
        -e "^R?PROMPT" \
        -e "^TERM\\(CAP\\)?" \
        -e "^USER" \
        -e "^DISPLAY" \
        -e "^DBUS_SESSION_BUS_ADDRESS" \
        -e "^XAUTHORITY" \
        -e "^SSH_\\(AUTH_SOCK\\|AGENT_PID\\)" \
        -e "^\\(SSH\\|GPG\\)_TTY" \
        -e "^GPG_AGENT_INFO" \
    | awk -F '=' '{print "  \"" $1 "=" $2 "\""}' >> env.el
echo ')' >> env.el

echo "Environment written to env.el"
