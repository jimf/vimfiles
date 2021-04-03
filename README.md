# Vim

My personal configuration files for the [Vim](https://www.vim.org/) text editor, which I normally run on macOS within a [tmux](https://github.com/tmux/tmux/wiki) session using [iTerm2](https://iterm2.com/).

## Installation

Be sure to install Vim 8.0+ or NeoVim per your environment. Python and ruby
support are strongly recommended. I personally install vim via Homebrew:

    brew install vim

Then clone this repo, initialize git submodules, and copy/link as necessary for
your environment and preferences.

    git clone https://github.com/jimf/vimfiles.git ~/git
    ln -s ~/git/vimfiles ~/.vim
    ln -s ~/git/vimfiles/vimrc ~/.vimrc
    cd ~/git/vimfiles
    git submodule init
    git submodule update
