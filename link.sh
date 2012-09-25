#!/bin/zsh

# Dead simple dotfile management
# Author: Philipp Millar <philipp.millar@gmx.de>
#
# TODO: apply machine dependent patches of the form dofile.machine.patch?
# TODO: completely machine dependent files? (dotfile__machine)
#

setopt extendedglob
basename=$(basename $0)
cd ~/.dotfiles

# (#i)   case insensitive
# *      select all files
# ~(...) except these
dotfiles=( (#i)*~(readme|link.sh|config|*.patch) config/* )

usage() {
    print "$basename -- dead simple dotfile management\n"
    print "$basename link   - symlink dotfiles into $HOME"
    print "$basename remove - remove dotfiles from $HOME"
    print "$basename print  - print the affected files"
}

link() {
    for i in $dotfiles; do
        if [[ -e ~/.$i ]]; then
            print "$HOME/.$i exists. I refuse to overwrite it."
        else
            ln -s ~/.dotfiles/$i ~/.$i
        fi
    done
}

remove() {
    for i in $dotfiles; do
        rm -r ~/.$i
    done
}

list() {
    for i in $dotfiles; do
        if [[ -d $i ]]; then; i=$i/; fi
        print "$HOME/.$i -> $HOME/.dotfiles/$i"
    done
}

if   [[ $1 == "l" || $1 == "link"   ]]; then; link
elif [[ $1 == "r" || $1 == "remove" ]]; then; remove
elif [[ $1 == "p" || $1 == "print"  ]]; then; list
else; usage
fi

cd -
