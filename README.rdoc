= Vim

It is recommended that you use gVim in either Windows or Linux and
MacVim for Mac.

 * (Windows) http://www.vim.org/download.php#pc (gvim73.exe)
 * (Mac) http://code.google.com/p/macvim/downloads/list (snapshot-52)


== Installation

Clone this repo into your home folder and copy/link as necessary for
your environment. The repo root should be represented as ".vim" in a
Unix environment, or "vimfiles" in a Windows environment. Likewise,
vimrc should be represented as .vimrc in a Unix environment, or _vimrc
in Windows.

Example:

  git clone git://github.com/jimf/vimfiles.git ~/.vim
  cd ~/.vim
  ln -s $PWD/vimrc $HOME/.vimrc

After initial istallation, initialize submodules:

  git submodule init
  git submodule update
