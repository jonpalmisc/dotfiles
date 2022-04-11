function fish_title
    set -q argv[1]; or set argv fish
    echo (prompt_pwd): $argv;
end
