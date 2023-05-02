# Load color formatting support.
autoload colors && colors

# Enable VCS info support, only show branch name.
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'

# Show username and hostname.
CUSTOM_PROMPT+=$'\n'
CUSTOM_PROMPT+="%F{red}"
CUSTOM_PROMPT+='%n@%m'
CUSTOM_PROMPT+="%F{reset}"
CUSTOM_PROMPT+=':'

# Show current directory.
CUSTOM_PROMPT+="%F{yellow}"
CUSTOM_PROMPT+="%~ "
CUSTOM_PROMPT+="%F{reset}"

# Show current Git repo info.
CUSTOM_PROMPT+="%F{green}"
CUSTOM_PROMPT+='${vcs_info_msg_0_}'
CUSTOM_PROMPT+="%F{reset}"

# Use ';' or '#' as the prompt character depending on permissions.
CUSTOM_PROMPT+=$'\n'
CUSTOM_PROMPT+="%(!.#.;) "

# Enable prompt substitution and the custom prompt.
setopt PROMPT_SUBST
PROMPT="$CUSTOM_PROMPT"
