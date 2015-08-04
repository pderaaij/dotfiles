# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Shell
if [ -n "$ZSH_VERSION" ]; then
   SHELL_ZSH=true
   SHELL_BASH=false
elif [ -n "$BASH_VERSION" ]; then
   SHELL_BASH=true
   SHELL_ZSH=false
fi

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)
READLINK=$(which greadlink || which readlink)
if $SHELL_BASH; then
    CURRENT_SCRIPT=$BASH_SOURCE
else
    CURRENT_SCRIPT=$0
fi

if [ -d "$HOME/Projects/dotfiles" ]; then
    DOTFILES_DIR="$HOME/Projects/dotfiles"
else
    echo "Unable to find dotfiles, exiting."
    return # `exit 1` would quit the shell itself
fi

# Finally we can source the dotfiles (order matters)
for DOTFILE in "$DOTFILES_DIR"/bash/.{bash*,inputrc}; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# Finally we can source the dotfiles (order matters)
for DOTFILE in "$DOTFILES_DIR"/system/.{function,function*,path,env,alias,completion,grep,prompt,custom}; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# Set LSCOLORS
eval "$(gdircolors "$DOTFILES_DIR"/system/.dir_colors)"

# Clean up
unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE

# Export
export SHELL_BASH SHELL_ZSH OS DOTFILES_DIR EXTRA_DIR
