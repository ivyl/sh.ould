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

function build_output() {
    while [ "$#" -gt 0 ]; do
        echo "$1\n"
        echo "\n"
        shift
    done
}

function backtrace() {
    echo "Backtrace:"
    echo "\n"
    local i=$1

    while caller $i
    do
        echo "\n"
        i=$((i+1))
    done
}

function expect() {
    local OPERATOR='='
    if [ "$1" = "not" ]; then
        local ERR="NOT"
        OPERATOR='!='
        shift
    fi

    local EXPECTATION=$(echo "$1")
    shift


    if [ "$1" != "from" ]; then
        echo -e "expect usage:\nexpect [not] \"foo bar\" from \\ \n  ls unf"
    fi

    shift

    local RESULT=$($@)

    if [ "$RESULT" $OPERATOR "$EXPECTATION" ]; then
        echo -en "${GREEN}."
    else
        echo -en "${RED}."
        append_error "$( build_output \
            "${RED}Expectation error." \
            "Command: $@" \
            "$ERR Expected: $EXPECTATION" \
            "GOT: $RESULT" \
            "$(backtrace 1)")"
    fi
}

function expect_match() {
    OPERATOR='-eq'
    if [ "$1" = "not" ]; then
        local ERR="NOT"
        OPERATOR="-ne"
        shift
    fi

    local REGEXP="$1"
    shift

    if [ "$1" != "from" ]; then
        echo -e "expect usage:\nexpect_match [not] \"^bar\" from \\ \n  ls unf"
    fi

    shift

    local RESULT=$($@)
    grep -E "$REGEXP" <(echo $RESULT) > /dev/null
    local CODE=$?

    if [ "$CODE" $OPERATOR 0 ]; then
        echo -en "${GREEN}."
    else
        echo -en "${RED}."
        append_error "$( build_output \
            "${RED}Match error." \
            "Command: $@" \
            "$ERR Expected match: $(printf "%q" $REGEXP)" \
            "ON: $RESULT" \
            "$(backtrace 1)")"
    fi
}

function expect_code() {
    local OPERATOR='-eq'
    if [ "$1" = "not" ]; then
        local ERR="NOT"
        OPERATOR='-ne'
        shift
    fi

    local EXPECTED_CODE="$1"
    shift

    if [ "$1" != "from" ]; then
        echo -e "expect usage:\nexpect_code [not] 0 from \\ \n  ls unf"
    fi

    shift

    $@ > /dev/null
    local CODE=$?

    if [ "$CODE" $OPERATOR "$EXPECTED_CODE" ]; then
        echo -en "${GREEN}."
    else
        echo -en "${RED}."
        append_error "$( build_output \
            "${RED}Return code error." \
            "Command: $@" \
            "$ERR Expected code: $EXPECTED_CODE" \
            "GOT: $CODE" \
            "$(backtrace 1)")"
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
