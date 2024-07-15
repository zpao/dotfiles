# ./bin - pick up current bin if there is one
# ~/z/bin - anything in my home directory and custom built (rare)
# ~/bin - anything in my home directory
# $ZSH/bin - anything in this repo
export PATH="./bin:$HOME/z/bin:$HOME/bin:$ZSH/bin:$PATH"

export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
