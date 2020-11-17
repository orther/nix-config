gpg-connect-agent updatestartuptty /bye
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

function iterm2_print_user_vars() {
  ##iterm2_set_user_var kubecontext $(kubectl config current-context 2> /dev/null || echo "None")
  iterm2_set_user_var AWS_PROFILE $(echo $AWS_PROFILE)
  iterm2_set_user_var AWS_CLUSTER_NAME $(echo $AWS_CLUSTER_NAME)
}

. $(brew --prefix asdf)/asdf.sh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
eval "$(direnv hook zsh)"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH

# Emacs custom build w/ feature/native-comp
if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
  export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
  ## alias emacs="$EMACS -nw"
  alias emacs="$EMACS"
fi

if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
  alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
fi
## alias emacs="open /Applications/Emacs.app $1"
## export EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
