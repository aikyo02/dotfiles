#!/bin/sh

curl -L "https://github.com/aikyo02/dotfiles/archive/master.tar.gz" | tar xv
mv -f dotfiles-master "~/dotfiles"
cd ~/.dotfiles

for f in .??*
do
    [ "$f" = ".git" ] && continue

    ln -snfv "$f" "$HOME"/"$f"
done
