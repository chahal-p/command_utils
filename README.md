# Prerequisite
  Install pflags from https://github.com/chahal-p/pflags
# Installation
  1. Download a version from https://github.com/chahal-p/command_utils/releases
  1. Unzip the file
  1. Navigate to extracted directory
     ```sh
     cd command_utils
     chmod 755 install.sh
     ```
  1. ```sh
     # Use sudo if required.
     # Default installation path is /usr/local/bin
     bash ./install.sh --installation_path <installation_path>
     ```
  1. For bash, add below to .bashrc
     ```
     source "<installation_path>/cu_init.bash"
     ```
     For zsh, add below to .zshrc
     ```
     source "<installation_path>/cu_init.zsh"
     ```
