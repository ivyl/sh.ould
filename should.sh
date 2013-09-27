#!/bin/bash

GREEN="\e[1;32m"
RED="\e[0;31m"
CLEAR="\e[0;0m"

function before() { echo -n ""; }
function after()  { echo -n ""; }

function backtrace() {
    echo "Backtrace:"
    i=0

    while caller $i
    do
        i=$((i+1))
    done
}

function expect() {
    EXPECTATION="$1"
    shift

    if [ "$1" != "from" ]; then
        echo -e "expect usage:\nexpect \"foo bar\" from \\ \n  ls unf"
    fi

    shift

    RESULT=$($@)

    if [ "$RESULT" = "$EXPECTATION" ]; then
        echo -en "${GREEN}."
    else
        echo -e "\n${RED}Expectation error.\nCommand: $@\nExpected: $EXPECTATION\nGOT: $RESULT$CLEAR"
        backtrace
    fi
}


function run_all_tests() {
    for test in $(typeset -F | awk '$3 ~ /^t_/ { print $3 }'); do
        before
        eval $test
        after
    done
}
