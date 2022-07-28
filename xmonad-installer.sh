#!/bin/sh

# XMonad install via stack

# Install some useful packages
sudo pacman -Sy xorg xorg-xinit dmenu picom nitrogen firefox terminator haskell-x11-xft

# Create default xmonad config file
mkdir ~/.xmonad
cd ~/.xmonad

cat > xmonad.hs << EOF
import XMonad

main = xmonad def
     { terminal = "terminator"
     , modMask = mod4Mask
     }
EOF

# Download stack and xmonad
curl -sSL https://get.haskellstack.org/ | sh
stack setup

git clone "https://github.com/xmonad/xmonad" xmonad-git
git clone "https://github.com/xmonad/xmonad-contrib" xmonad-contrib-git
git clone "https://codeberg.org/xmobar/xmobar" xmobar-git

# Initialize stack and install it
stack init

# Edit the auto-created stack.yaml file, by changing
#flags: {}
#to
#
#flags:
#  xmobar:
#    all_extensions: true
# and extra_deps: [] to
# extra_deps:
#    - netlink-1.1.1.0
sed -i 's/# flags: {}/flags:\n  xmobar:\n    all_extensions: true/g' stack.yaml
sed -i 's/# extra-deps: \[\]/extra-deps:\n    - netlink-1\.1\.1\.0/g' stack.yaml
sed -i 's/# system-ghc/system-ghc:/g' stack.yaml

stack install

# Add ~/.local/bin to your PATH (Assuming you have a .bash_profile)
cat << EOF >>  ~/.bash_profile
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
EOF

# Write a build file
cd ~/.xmonad
cat > build << EOF
#!/bin/sh
exec stack ghc -- \
  --make xmonad.hs \
  -i \
  -ilib \
  -fforce-recomp \
  -main-is main \
  -v0 \
  -o "$1"
EOF

# and make sure it's executable as well
chmod a+x build

# Recompile and restart xmonad
xmonad --recompile && xmonad --restart

# Whenever you update your xmonad/-contrib or xmobar repositories, cd inside ~/.xmonad and run
# stack install
# to rebuild and reinstall everything
