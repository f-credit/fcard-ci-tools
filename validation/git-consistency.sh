#!/bin/bash

cd $PWD

BASE_HEAD=$(git rev-parse --short ${BASE_BRANCH:-'origin/master'})
CURRENT_HEAD=$(git rev-parse --short HEAD)
DIFF_INFO=$(git diff --shortstat $BASE_HEAD..$CURRENT_HEAD ':(exclude)*.lock' ':(exclude)package-lock.json')

SOFT_LIMIT_INSERTIONS=150
HARD_LIMIT_INSERTIONS=200
SOFT_LIMIT_DELETIONS=300
HARD_LIMIT_DELETIONS=400

if [[ $REPO_TYPE == "mobile" ]]; then
    SOFT_LIMIT_INSERTIONS=300
    HARD_LIMIT_INSERTIONS=400
    SOFT_LIMIT_DELETIONS=600
    HARD_LIMIT_DELETIONS=800
fi
  
# number of commits

NUMBER_OF_COMMITS=$(git rev-list --count $BASE_HEAD..$CURRENT_HEAD)
if [[ $NUMBER_OF_COMMITS -ne 1 ]]; then
    echo "ERROR #1: There are more than one commits"
    exit 1
fi

# number of insertions/deletions

NUMBER_OF_INSERTIONS=$(echo $DIFF_INFO | perl -n -e'/(\d+) insertions/ && print $1')
NUMBER_OF_DELETIONS=$(echo $DIFF_INFO | perl -n -e'/(\d+) deletions/ && print $1')

if [[ $NUMBER_OF_INSERTIONS -gt $HARD_LIMIT_INSERTIONS ]]; then
    echo "ERROR #2: There are more than $HARD_LIMIT_INSERTIONS insertions"
    exit 1
fi

if [[ $NUMBER_OF_DELETIONS -gt $HARD_LIMIT_DELETIONS ]]; then
    echo "ERROR #3: There are more than $HARD_LIMIT_DELETIONS deletions"
    exit 1
fi

# warnings

if [[ $NUMBER_OF_INSERTIONS -gt $SOFT_LIMIT_INSERTIONS ]]; then
    echo "WARNING #1: There are more than $SOFT_LIMIT_INSERTIONS insertions"
fi

if [[ $NUMBER_OF_DELETIONS -gt $SOFT_LIMIT_DELETIONS ]]; then
    echo "WARNING #2: There are more than $SOFT_LIMIT_DELETIONS insertions"
fi

echo "Success: This branch is ready to be merged!"
