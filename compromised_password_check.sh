#!/usr/bin/env bash

# TODO add attributions
# TODO document including notes on k-anon
# TODO add support for -h flag
# TODO add longer text abut changing password wherever it is used
# TODO add option to show password (hide by default)
# TODO move usage to a function so we can call it with -h

# Attribution ====================================================================================
# color from reddit
# https://linuxacademy.com/blog/security/proactively-identifying-compromised-passwords-roadmap-to-securing-your-infrastructure/
# Packt Mastering Linux Security Book and insert original authorsip

RED='\033[1;31m'
GREEN='\033[0;32m'
NC='\033[0m'
CHECKMARK='\xE2\x9C\x94'
CROSS='\xE2\x9D\x8C'

candidate_password=$1

[ $# -eq 0 ] && { echo -e "\nUsage: ./compromisedpassword 'password'\n"; exit 1; }

printf "\nChecking candidate password %s\n" "$candidate_password"

full_hash=$(echo -n "$candidate_password" | sha1sum | awk '{print substr($1, 0, 32)}')
prefix=$(echo "$full_hash" | awk '{print substr($1, 0, 6)}')
suffix=$(echo "$full_hash" | awk '{print substr($1, 6, 26)}')
if curl https://api.pwnedpasswords.com/range/"$prefix" -s -H "Add-Padding: true"  | grep -q -i "$suffix";
then
    echo -e "\n${RED}${CROSS} Candidate password $candidate_password is compromised ${NC}\n\n"
    echo -e "You should immediately change this password on any other site you amay be using it. More information can be found here (insert link to HIBP\n\n"
else
    echo -e "\n${GREEN}${CHECKMARK} Candidate password $candidate_password is safe for use${NC}\n\n"
fi
exit 0;
