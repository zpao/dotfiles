#!/usr/bin/env zsh

### ZSH

export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

setopt nolistbeep
setopt localoptions
setopt localtraps
setopt sharehistory
setopt extendedhistory
setopt promptsubst
setopt completeinword
setopt ignoreeof
setopt completealiases

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^?' backward-delete-char

for keycode in '[' '0'; do
  bindkey "^[${keycode}A" history-substring-search-up
  bindkey "^[${keycode}B" history-substring-search-down
done
unset keycode


### PATH

# ./bin - pick up current bin if there is one
# ~/z/bin - anything in my home directory and custom built (rare)
# ~/bin - anything in my home directory
# $ZSH/bin - anything in this repo
export PATH="./bin:$HOME/z/bin:$HOME/bin:$ZSH/bin:$PATH"


### ALIASES
alias ls="ls -a"
alias ll="ls -lh"


### ENV
export EDITOR=vim
