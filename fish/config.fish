#===-- Settings -------------------------------------------------------------===

# Disable path shortening in prompt
set -g fish_prompt_pwd_dir_length 0

# Configure CLI editor
set -gx EDITOR nvim
set -gx VISUAL nvim

#===-- Aliases --------------------------------------------------------------===

# Common command shorthands
alias ls "ls -la --color"

# Aliases for opening graphical and terminal Emacs
alias emacs "/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
alias gmacs "open -a Emacs"

#===-- Path -----------------------------------------------------------------===

# If any of the following paths are missing, `fish_add_path` will ignore it
fish_add_path -ag ~/.cargo/bin
fish_add_path -ag /opt/local/bin

#===-------------------------------------------------------------------------===

if status is-interactive
end
