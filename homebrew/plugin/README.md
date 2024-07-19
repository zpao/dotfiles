# homebrew

This just sets up the environment for homebrew if installed.

Theoretically this could be done directly in `~/.zshrc` or `~/.zshenv` but opted to do it as a plugin for consistency.

Note: This must be loaded ASAP as other plugins will expect that executables installed via homebew are available in `$PATH`.
