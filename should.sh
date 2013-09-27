#!/bin/bash

GREEN="\e[1;32m"
RED="\e[0;31m"
CLEAR="\e[0;0m"
ERRORS=""

function before() { echo -n ""; }
function after()  { echo -n ""; }

function append_error() {
    ERRORS="$ERRORS\n\n$@"
}

function backtrace() {
    echo "Backtrace:"
    echo "\n"
    i=$1

    while caller $i
    do
        echo "\n"
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
        echo -en "${RED}."
        append_error "\n${RED}Expectation error.\nCommand: $@\nExpected: $EXPECTATION\nGOT: $RESULT\n\n$(backtrace 1)"
    fi
}

function expect_match() {
    REGEXP="$1"
    shift

    if [ "$1" != "from" ]; then
        echo -e "expect usage:\nexpect_match \"^bar\" from \\ \n  ls unf"
    fi

    shift

    RESULT=$($@)
    grep -E "$REGEXP" <(echo $RESULT) > /dev/null
    CODE=$?

    if [ "$CODE" -eq 0 ]; then
        echo -en "${GREEN}."
    else
        echo -en "${RED}."
        append_error "\n${RED}Match error.\nCommand: $@\nExpected match: $(printf "%q" $REGEXP)\nON: $RESULT\n$(backtrace 1)"
    fi
}

function expect_code() {
    EXPECTED_CODE="$1"
    shift

    if [ "$1" != "from" ]; then
        echo -e "expect usage:\nexpect_code 0 from \\ \n  ls unf"
    fi

    shift

    $@ > /dev/null
    CODE=$?

    if [ "$CODE" -eq "$EXPECTED_CODE" ]; then
        echo -en "${GREEN}."
    else
        echo -en "${RED}."
        append_error "\n${RED}Return code error.\nCommand: $@\nExpected code: $EXPECTED_CODE\nGOT: $CODE\n$(backtrace 1)"
    fi
}


function run_all_tests() {
    for test in $(typeset -F | awk '$3 ~ /^t_/ { print $3 }'); do
        before
        eval $test
        after
    done
    echo
    echo -e $ERRORS
    echo -en $CLEAR
}
