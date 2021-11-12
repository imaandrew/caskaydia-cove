#!/bin/bash

echo 'Downloading fonts'
mkdir -p tmp/{ttf,ttx,renamed_fonts}
curl -Ls https://api.github.com/repos/microsoft/cascadia-code/releases/latest | grep -wo "https.*CascadiaCode-.*.zip" | xargs curl -L -o tmp/CascadiaCode.zip
unzip -q tmp/CascadiaCode.zip -d tmp/CascadiaCode
mv tmp/CascadiaCode/ttf/static/*.ttf tmp/ttf
rm tmp/ttf/*PL*

echo 'Extracting TTF fonts'
ttx -q -d tmp/ttx tmp/ttf/*.ttf

echo 'Renaming TTF fonts'
sed -i 's/Cascadia Code/Caskaydia Cove/g' tmp/ttx/CascadiaCode-*.ttx
sed -i 's/Cascadia Mono/Caskaydia Mono/g' tmp/ttx/CascadiaMono-*.ttx
sed -i 's/CascadiaCode/CaskaydiaCove/g' tmp/ttx/CascadiaCode-*.ttx
sed -i 's/CascadiaMono/CaskaydiaMono/g' tmp/ttx/CascadiaMono-*.ttx

echo 'Compiling TTF Fonts'
ttx -q -d tmp/renamed_fonts tmp/ttx/*.ttx

echo 'Cloning nerd fonts repository'
git clone --depth=1 https://github.com/ryanoasis/nerd-fonts

for f in tmp/renamed_fonts/*.ttf; do
  if [[ "$f" =~ "CascadiaCode" ]]; then
    newfile="${f/CascadiaCode/CaskaydiaCove}"
    mv "$f" "$newfile"
  else
    newfile="${f/CascadiaMono/CaskaydiaMono}"
    mv "$f" "$newfile";
  fi
  echo "Patching $newfile"
  nerd-fonts/font-patcher -wscq -out patched_fonts/win "$newfile" &>/dev/null
  nerd-fonts/font-patcher -scq -out patched_fonts/non_win "$newfile" &>/dev/null
done
rm -rf tmp 
echo "Done. Patched fonts are located in the patched_fonts directory."
