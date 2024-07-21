# shell environment, including $PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# zsh completions for installed packages
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
