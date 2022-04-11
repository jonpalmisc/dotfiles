function fish_prompt
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status

    set -l status_color (set_color $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" \
        "$status_color" "$status_color" $last_pipestatus)

    echo -n -s -e "\n"(prompt_login)' ' \
        (set_color $fish_color_cwd) (prompt_pwd) \
        (set_color normal) (fish_vcs_prompt) \
        (set_color normal) " "$prompt_status "\n" \
        "\$ "
end
