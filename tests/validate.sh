#!/bin/bash

# Exit immediately on any failure
set -o errexit

# All vars here
APIHOST=https://${CI_SERVER_HOST}
EXITCODE=0


# Highlight failures
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

for FILENAME in *.yaml; do 
  echo $FILENAME

  RESULT=`jq --null-input --arg yaml "$(<$FILENAME)" '.content=$yaml' | curl --header "Content-Type: application/json" --header "PRIVATE-TOKEN: $ACCESSTOKEN" "$APIHOST/api/v4/ci/lint" --data @- 2>/dev/null`
  if [ `echo $RESULT | jq -r '.status'` == "valid" ]; then
    printf "${GREEN}Pass${NC}\n"
  else
    printf "${RED}Fail${NC}\n"
    printf "${RED}${RESULT}${NC}\n"
    EXITCODE=1
  fi
  echo 
done
exit $EXITCODE
