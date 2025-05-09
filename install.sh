POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -u|--git-user-name)
      GIT_USER_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    -e|--git-email)
      GIT_EMAIL="$2"
      shift # past argument
      shift # past value
      ;;
    -t|--github-packages-token)
      GITHUB_PACKAGES_TOKEN="$2"
      shift # past argument
      shift # past value
      ;;
    -x|--exclude)
      IFS=',' read -r -a EXCLUDE <<< "$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

usage (){
  echo "Usage: ./install.sh -u|--git-user-name <YOUR-GIT-USER-NAME> -e|--git-email <YOUR-GIT-EMAIL> -t|--github-packages-token <GITHUB-PACKAGES-TOKEN> [-x|--exclude <comma separated string for apps that will not be installed>]"
  echo "Usage: Github packages token can be fetched from: github.com => settings => developer settings => personal access tokens"
  echo "Usage: Available excludes: whatsapp,discord,telegram,visual-studio-code,github,gh,datagrip,atom,iterm2"
}

if [ -z "${GIT_USER_NAME}" ] || [ -z "${GIT_EMAIL}" ] || [ -z "${GITHUB_PACKAGES_TOKEN}" ]; then
  usage
  exit 1
fi

arrayContains (){
  declare -a array=("${!1}")
  local match=$2

  for item in "${array[@]}"
  do
    if [[ "$item" == "$match" ]]; then
      return 1
    fi
  done

  return 0
}

install (){
  local name=$1
  local options=$2
  arrayContains EXCLUDE[@] $name
  if [[ "$?" == "0" ]]; then
    brew install ${options} $name
  fi
}

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo "eval \"\$(/opt/homebrew/bin/brew shellenv)"\" >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
BREW_PREFIX=$(brew --prefix)

# Zsh
0>/dev/null sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
chmod 755 /usr/local/share/zsh
chmod 755 /usr/local/share/zsh/site-functions

echo "Make sure to edit .zshrc with t"

# Applications
brew install --cask notion
install iterm2 --cask

# Dev Apps
brew install --cask webstorm
echo "export PATH=\"/Applications/WebStorm.app/Contents/MacOS:$PATH\"" >> ~/.zshrc
brew install --cask pycharm
brew install --cask postman
brew install --cask ngrok
install datagrip --cask
install github --cask
brew install --cask chatgpt

# Cloud CLIs
brew tap heroku/brew && brew install heroku
brew install awscli
brew install --cask session-manager-plugin

# Text editors
install atom --cask
brew install --cask sublime-text
install visual-studio-code --cask

# Communication
install whatsapp --cask
install telegram --cask
install discord --cask
brew install --cask slack
brew install --cask zoom

# Mongo
brew install --cask mongodb-compass
brew tap mongodb/brew
brew install mongodb-database-tools
brew install mongodb-atlas-cli

# Node
brew install nvm
brew install yarn
echo "//npm.pkg.github.com/:_authToken=$GITHUB_PACKAGES_TOKEN" > ~/.npmrc

# docker
brew install --cask docker

# Git
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_EMAIL"

# P4merge
brew install --cask p4v
git config --global merge.tool p4mergetool
git config --global mergetool.p4mergetool.cmd
git config --global mergetool.p4mergetool.cmd '/Applications/p4merge.app/Contents/MacOS/p4merge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
git config --global mergetool.p4mergetool.trustExitCode false
git config --global mergetool.keepBackup false
git config --global diff.tool p4difftool
git config --global difftool.p4difftool.cmd '/Applications/p4merge.app/Contents/MacOS/p4merge "$LOCAL" "$REMOTE"'

#github
install gh

# SSH
ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL"

# Mobile
brew install cocoapods
brew install fastlane
brew install openjdk@17
brew install --cask android-studio
echo "export ANDROID_HOME=$HOME/Library/Android/sdk" >> ~/.zshrc
echo "export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH" >> ~/.zshrc

#Configurations
# echo "prompt_context() {
#   if [[ \"\$USER\" != \"\$DEFAULT_USER\" || -n \"\$SSH_CLIENT\" ]]; then
#     prompt_segment black default \"%(!.%{%F{yellow}%}.)\$USER\"
#   fi
# }

# Profile changes:
echo "# Default editor
export EDITOR='subl -w'

# NVM
export NVM_DIR=\"$HOME/.nvm\"
[ -s \"${BREW_PREFIX}/opt/nvm/nvm.sh\" ] && \. \"${BREW_PREFIX}/opt/nvm/nvm.sh\"  # This loads nvm
[ -s \"${BREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm\" ] && \. \"${BREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm\"  # This loads nvm bash_completion
" >> ~/.zshrc

# Folders
mkdir ~/dev

# Rosseta
softwareupdate --install-rosetta

# Shell
echo "export JAVA_HOME=/opt/homebrew/opt/openjdk@17" >> ~/.zshrc
echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.zshrc
echo "setopt HIST_IGNORE_SPACE" >> ~/.zshrc

# Yarn modern
echo "export KAI_PACKAGES_TOKEN=${GITHUB_PACKAGES_TOKEN}"
