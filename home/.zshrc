# ZSH stuff
setopt HIST_IGNORE_SPACE

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=( zsh-syntax-highlighting zsh-autosuggestions git )

source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# PATH and variables
export EDITOR=nvim

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=129"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
PATH="$PATH:$HOME/.local/bin"

# Custom bindkey
bindkey  "^[[1;5H"   beginning-of-line
bindkey  "^[[1;5F"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey "^H" backward-kill-word
bindkey "^[[3;5~" kill-wor

# Aliases
alias vi=nvim
alias neofetch=fastfetch
alias ls=lsd
alias ll="ls -l"
alias yay=paru
