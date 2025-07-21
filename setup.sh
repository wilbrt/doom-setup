##!/bin/bash

set -euo pipefail

# install brew
echo  -e "Installing brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# when libgccjit is installed before emacs, the emacs installer uses native compilation by default
brew install git gcc libgccjit

#install emacs-plus and link it
brew tap d12frosted/emacs-plus
brew install emacs-plus
ln -s /usr/local/opt/emacs-plus/Emacs.app /Applications/Emacs.app

# install java, clojure and clojure tools
brew install --cask temurin@21
brew install clojure/tools/clojure clojure-lsp/brew/clojure-lsp-native babashka/brew/neil borkdude/brew/jet

echo  -e "Installing cljfmt"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/weavejester/cljfmt/HEAD/install.sh)"
echo  -e "Installing clj-kondo"
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/clj-kondo/clj-kondo/master/script/install-clj-kondo)"

# doom prereqs
brew install rg coreutils fd cmake libvterm

# install doom
echo  -e "Installing doom emacs"
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install

rm ~/.config/doom/init.el
rm ~/.config/doom/config.el

cd ~/.config/doom/
echo -e "Downloading config files"
curl -sSLO https://raw.githubusercontent.com/wilbrt/doom-setup/refs/heads/main/config.el
curl -sSLO https://raw.githubusercontent.com/wilbrt/doom-setup/refs/heads/main/init.el
cd -
echo -e "Config files downloaded"

~/.config/emacs/bin/doom sync

# if package installation fails rm -rf the problematic package and try doom sync again

