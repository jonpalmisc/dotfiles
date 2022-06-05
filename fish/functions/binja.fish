# Created by and used with permission from @noar(fromspace).
function binja --description 'Open with Binary Ninja'
    argparse 'c/current' -- $argv

    set lastrun (string join / ~ Library "Application Support" "Binary Ninja" lastrun)
    if ! test -e $lastrun
        return
    end

    set binja (string join / (cat $lastrun) binaryninja)
    if ! test -e $binja
        return
    end

    if set -q _flag_current
        if pgrep -q binaryninja
            open -a $binja $argv  # LaunchServices may disagree
            return
        end
    end

    $binja $argv &>/dev/null 2>&1 &
    disown
end
