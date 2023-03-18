#!/bin/bash

# dependency xidel https://videlibri.sourceforge.net/xidel.html

BASE_URL=https://github.com/VSCodium/vscodium/releases/download/
VSCODIUM_RELEASES=$(xidel https://github.com/VSCodium/vscodium/releases --xpath3 /html/body/div[1]/div[4]/div/main/turbo-frame/div/div/div[3]/section[1]/div/div[2]/div/div[1]/div[1]/div[1]/div[1]/span/a)
#HTMLISPInformation="$(curl --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/111.0" https://github.com/VSCodium/vscodium/releases)"

echo $VSCODIUM_RELEASES | tee /tmp/vscodium.txt

tag=$( tail -n 1 /tmp/vscodium.txt )

echo "Last version: [$tag]"

#BASE_URL=https://github.com/VSCodium/vscodium/releases/download/1.76.1.23069/codium_1.76.1.23069_amd64.deb

