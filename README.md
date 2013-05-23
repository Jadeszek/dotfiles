
## What?

My public configuration-files and personal scripts. They might not work for
you, but feel free to steal from them.

I change those files a lot and sometimes I break things, so be careful.

My [vim config](https://github.com/poxar/vimfiles) lives in in a separate
repository, so I can use it without having to fetch all of my dotfiles.

## ZSH

My zsh configuration is organised in three folders:

* **zsh/core:** basic zsh configuration like completion and prompt
* **zsh/fpath:** completion functions
* **zsh/plugin:** functions and aliases organised by topics

And into three files, that are linked into $HOME

* **zshrc** sets shell options and loads the files in proper order
* **zlogin** configures keychain and links stuff to /tmp
* **zlogout** clears the screen when logging out

The files, that will be loaded from **core** have to be specified in **zshrc**.
This way you can add a new configuration relatively easy (Copy the old file and
edit).

A lot of the configuration is stolen from [grml](http://grml.org/zsh/).

## Install

Make sure you have zsh and git installed and in your $PATH.

```sh
cd ~
git clone git://github.com/herrblau/dotfiles.git .dotfiles
cd .dotfiles
make
```

Note, that no old files will be overwritten. That means you have to move them
away by hand, or call `make clean` if you feel adventurous.


If you want to deploy the complete set with vim:

```sh
cd ~
git clone git://github.com/herrblau/dotfiles.git .dotfiles
cd .dotfiles
make full
```

This will pull my vim configuration and all the plugins I use from GitHub.
Again you will have to move your vim configuration away for this to work (or
call `make cleanall`).

You can also narrow down the selection, look into Makefile to see which targets
are available.

However I recommend you cook up your own zsh configuration (maybe using this as
a starting point) or clone something like
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) or the
[grml-zsh-config](http://grml.org/zsh/).
