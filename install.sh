ln -s .alias ~/.alias
ln -s .functions ~/.functions

ln -s .tmux.conf ~/.tmux.conf
echo 'Warning: Without TPM, the linked tmux configuration will not work!'
echo 'See https://github.com/tmux-plugins/tpm for installation instructions.'

echo '\nDone!'
