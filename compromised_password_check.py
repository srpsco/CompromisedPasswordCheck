#!/usr/bin/env bash

# todo add attributions
# add explicit exit code
# document including notes on k-anon 
# add support for -h flag

# Attribution ====================================================================================
# https://linuxacademy.com/blog/security/proactively-identifying-compromised-passwords-roadmap-to-securing-your-infrastructure/
# Packt Mastering Linux Security Book and insert original authorsip 

RED='\033[1;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

candidate_password=$1

[ $# -eq 0 ] && { echo -e "\nUsage: compromisedpassword 'password'\n"; exit 1; }

printf "\nChecking candidate password $candidate_password\n\n"

full_hash=$(echo -n $candidate_password | sha1sum | awk '{print substr($1, 0, 32)}')
prefix=$(echo $full_hash | awk '{print substr($1, 0, 6)}')
suffix=$(echo $full_hash | awk '{print substr($1, 6, 26)}')
if curl https://api.pwnedpasswords.com/range/$prefix -H "Add-Padding: true"  | grep -i $suffix;
  then 
    printf "\n${RED}Candidate password $candidate_password is compromised${NC}\n\n";
  else 
    printf "\n${GREEN}Candidate password $candidate_password is OK for use${NC}\n\n";
fi
exit 0;
