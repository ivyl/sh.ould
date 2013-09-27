#!/bin/bash

source should.sh

function t_expect() {
    expect "foo" from \
        echo foo
}

function t_expect_fail() {
    expect "bar" from \
        echo foo
}

function t_match() {
    expect_match "^foo" from \
        echo foo
}

function t_match_error() {
    expect_match "^bar" from \
        echo foo
}

function t_code() {
    expect_code 0 from \
        echo foo
}

function t_code_error() {
    expect_code 1 from \
        echo foo
}

run_all_tests
