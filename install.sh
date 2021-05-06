GIT_USER_NAME=GITHUB_USER_NAME
GIT_EMAIL=GITHUB_EMAIL
GITHUB_PACKAGES_TOKEN=TOKEN # settings => developer settings => personal access tokens


# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
chmod 755 /usr/local/share/zsh
chmod 755 /usr/local/share/zsh/site-functions

echo "Make sure to edit .zshrc with t"

# Applications

# Dev Apps
brew cask install webstorm
brew cask install pycharm
brew cask install postman
brew cask install atom
brew cask install sublime-text
brew cask install ngrok
brew cask install github
brew cask install mongodb-compass

# General Purpose Apps
brew cask install telegram
brew cask install slack
brew cask install tandem
brew cask install zoom
brew cask install notion

#Development

# Node
brew install nvm
brew install yarn
echo "//npm.pkg.github.com/:_authToken=$GITHUB_PACKAGES_TOKEN" > ~/.npmrc

# docker
brew cask install docker

# Git
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_EMAIL"

#github
brew install gh

# SSH
ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL"

#Configurations
# echo "prompt_context() {
#   if [[ \"\$USER\" != \"\$DEFAULT_USER\" || -n \"\$SSH_CLIENT\" ]]; then
#     prompt_segment black default \"%(!.%{%F{yellow}%}.)\$USER\"
#   fi
# }

echo "# Default editor
export EDITOR='subl -w'

# NVM
export NVM_DIR=\"\$HOME/.nvm\"
[ -s \"/usr/local/opt/nvm/nvm.sh\" ] && . \"/usr/local/opt/nvm/nvm.sh\"  # This loads nvm
[ -s \"/usr/local/opt/nvm/etc/bash_completion.d/nvm\" ] && . \"/usr/local/opt/nvm/etc/bash_completion.d/nvm\"  # This loads nvm bash_completion

[[ -s \"\$HOME/.gvm/scripts/gvm\" ]] && source \"\$HOME/.gvm/scripts/gvm\"" >> ~/.zshrc

# Folders
mkdir ~/dev


