#!/bin/bash

echo 'Downloading Fonts'
curl -Ls https://api.github.com/repos/microsoft/cascadia-code/releases/latest | grep -wo "https.*CascadiaCode-.*.zip" | wget -qi -
unzip -q CascadiaCode-*.zip -d CascadiaCode
mkdir fonts
mv CascadiaCode/ttf/static/*.ttf fonts
rm fonts/*PL*
cd fonts || exit

mkdir ttx
echo 'Extracting TTF Fonts'
ttx -q -d ttx ./*.ttf
sed -i 's/Cascadia Code/CaskaydiaCove/g' ttx/CascadiaCode-*.ttx
sed -i 's/Cascadia Mono/CaskaydiaCove/g' ttx/CascadiaMono-*.ttx
sed -i 's/CascadiaCode/CaskaydiaCove/g' ttx/CascadiaCode-*.ttx
sed -i 's/CascadiaMono/CaskaydiaCove/g' ttx/CascadiaMono-*.ttx
mkdir out
echo 'Compiling TTF Fonts'
ttx -q -d out ttx/*.ttx

rm -rf ttx
rm -rf Cascadia*
mv out/* .
rm -rf out
cd ..

git clone --depth=1 https://github.com/ryanoasis/nerd-fonts

mkdir patched-fonts
for f in fonts/*.ttf;
do
  echo "Patching ${f}"
  if [[ "$f" == *"CascadiaCode"* ]]; then
      nerd-fonts/font-patcher -wcq -out patched-fonts "$f" &>/dev/null
	  nerd-fonts/font-patcher -cq -out patched-fonts "$f" &>/dev/null
  else
      nerd-fonts/font-patcher -wscq -out patched-fonts "$f" &>/dev/null
      nerd-fonts/font-patcher -scq -out patched-fonts "$f" &>/dev/null
  fi
done
rm -rf fonts 
echo "Done. Patched fonts are loacted in the patched-fonts directory."
