function quick_python
    echo (string join ';' $argv) | python3 -qi 2>/dev/null
end
