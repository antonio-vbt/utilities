export CLICOLOR=1

# Enable autocomplete for things like 'git'
autoload -Uz compinit && compinit

# Make the behavior of TAB autocomplete closer to bash
setopt BASH_AUTO_LIST LIST_AMBIGUOUS
unsetopt MENU_COMPLETE AUTO_MENU

# Pretty terminal prompt
export PROMPT="%F{green}%n@%m%f: %~ %F{blue}$%f "
