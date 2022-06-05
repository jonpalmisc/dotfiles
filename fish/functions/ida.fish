function ida --description 'Open with IDA Pro'
    set ida_dir  (/bin/ls /Applications/ | grep "IDA" | uniq | sort -r | head -n1)
    set ida (string join / "" Applications $ida_dir ida64.app)

    open -a $ida $argv
end
