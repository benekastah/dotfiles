# macOS's /etc/zprofile puts the system's directories ahead of ours in PATH, for login shells
# (every new terminal there); setting it again puts ours first.
[[ $OSTYPE == darwin* ]] && . "$HOME/.zshenv"
