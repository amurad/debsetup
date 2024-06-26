# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.config/zsh/.zshrc"

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
# End of lines added by compinstall
_comp_options+=(globdots)               # Include hidden files.

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

export VISUAL=micro
export EDITOR=micro

autoload -U colors && colors
[ -f ~/.config/zsh/prompt ] && source ~/.config/zsh/prompt 
[ -f ~/.config/bash/aliases ] && source ~/.config/bash/aliases
[ -f ~/.config/bash/utils_env ] && source ~/.config/bash/utils_env

# stop underlining when typing commands
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

source /usr/share/autojump/autojump.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# must be last line
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# if [[ $- =~ i ]] && [[ -z "$TMUX" ]]; then
#     tmux new -A -s default
# fi