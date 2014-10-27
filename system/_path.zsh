# ./bin - pick up current bin if there is one
# ~/z/bin - anything in my home directory and custom built (rare)
# ~/bin - anything in my home directory
# $ZSH/bin - anything in this repo
# /usr/local/bin - homebrew (usually), force it higher than it would otherwise be to override system installs
export PATH="./bin:$HOME/z/bin:$HOME/bin:$ZSH/bin:/usr/local/bin:$PATH"

export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
