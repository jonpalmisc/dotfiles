#===-- Settings -------------------------------------------------------------===

# Disable path shortening in prompt.
set -g fish_prompt_pwd_dir_length 0

# Configure CLI editor
set -gx EDITOR nvim
set -gx VISUAL nvim

#===-- Aliases --------------------------------------------------------------===

# Common command shorthands
alias ls "ls -lah"

# Aliases for opening graphical and terminal Emacs
alias emacs "/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
alias gmacs "open -a Emacs"

#===-- Path -----------------------------------------------------------------===

set -gx fish_user_paths "/opt/homebrew/bin" $fish_user_paths

#===-------------------------------------------------------------------------===

if status is-interactive
end
