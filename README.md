# Vim

It is recommended that you use gVim in either Windows or Linux and
MacVim for Mac.

 * (Windows) http://www.vim.org/download.php#pc (gvim73.exe)
 * (Mac) http://code.google.com/p/macvim/downloads/list (snapshot-52)

## Installation

Clone this repo into your home folder and copy/link as necessary for
your environment. The repo root should be represented as `.vim` in a
Unix environment, or `vimfiles` in a Windows environment. Likewise,
vimrc should be represented as `.vimrc` in a Unix environment, or `_vimrc`
in Windows.

Example:

```sh
$ git clone https://github.com/jimf/vimfiles.git ~/.vim
$ cd ~/.vim
$ ln -s $PWD/vimrc $HOME/.vimrc
```

After initial installation, initialize submodules:

```sh
$ git submodule init
$ git submodule update
```

## Building Vim From Source

My setup requires a number of compilation options to be enabled. MacVim comes
with these already, but when using Linux, compiling from source is recommended.
First install all necessary build dependencies, then clone the official
[vim git repo](https://github.com/vim/vim), configure, and install (apt-based
distro assumed):

```sh
$ sudo apt-get install libncurses5-dev libgnome2-dev libgnomeui-dev \
      libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
      libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
      python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git

$ git clone https://github.com/vim/vim.git
$ cd vim/src
$ make distclean # not needed if run for the first time
$ ./configure --with-features=huge \
              --enable-multibyte \
              --enable-rubyinterp=yes \
              --enable-pythoninterp=yes \
              --with-python-config-dir=/usr/lib/python2.7/config \
              --enable-python3interp=yes \
              --with-python3-config-dir=/usr/lib/python3.5/config \
              --enable-perlinterp=yes \
              --enable-luainterp=yes \
              --enable-gui=gtk2 \
              --enable-cscope
```
