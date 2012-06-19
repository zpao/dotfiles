alias ls="ls -a"
alias ll="ls -lh"

# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -AF --color"
  alias l="gls -lAh --color"
  alias ll="gls -lAh --color"
  alias la='gls -A --color'
fi

# I'll never remember this in python form, so alias it!
alias ppjson="python -mjson.tool myfile.json"

alias makejsc="make -j8 -s -C"
