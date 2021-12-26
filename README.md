# caskaydia-cove
Automatic Nerd Fonts patching of the [Cascadia Code](https://github.com/microsoft/cascadia-code) font

The fonts are patched automatically with a GitHub Action but you can do it manually by running `patch.sh`

## Dependencies
- git
- curl
- unzip
- fonttools
- fontforge

### The script will clone the nerd-fonts repository which is over 6.5GB

## Instructions
Simply run the script and it should do everything for you. The patched fonts will be placed in the patched-fonts directory
