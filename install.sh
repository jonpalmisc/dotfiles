ln -s "$(pwd)/.aliases" $HOME
ln -s "$(pwd)/.functions" $HOME
ln -s "$(pwd)/.tmux.conf" $HOME

echo 'Warning: Without TPM, the linked tmux configuration will not work!'
echo 'See https://github.com/tmux-plugins/tpm for installation instructions.'

echo '\nDone!\n'

echo 'Make sure to add the following to your profile:\n'
echo '  source ~/.aliases'
echo '  source ~/.functions'
