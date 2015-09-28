#!/bin/sh

curl -L "https://github.com/aikyo02/dotfiles/archive/master.tar.gz" | tar xv
mv dotfiles-master ~/dotfiles

for f in ~/dotfiles/.??*
do
    [ "$f" = ".git" ] && continue

    ln -snfv ~/dotfiles/"$f" "$HOME"/"$f"
done
