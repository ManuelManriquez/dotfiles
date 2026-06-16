export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="macovsky"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# ssh-agent (keychain)
source ~/.keychain/$(hostname)-sh 2>/dev/null
