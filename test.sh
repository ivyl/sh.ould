#!/bin/bash

source should.sh

function t_expect() {
    expect "foo" from \
        echo foo
}

function t_expect_error() {
    expect "bar" from \
        echo foo
}

function t_not_expect() {
    expect not "foo" from \
        echo bar
}

function t_not_expect_error() {
    expect not "bar" from \
        echo bar
}

function t_match() {
    expect_match "^foo" from \
        echo foo
}

function t_match_error() {
    expect_match "^bar" from \
        echo foo
}

function t_not_match() {
    expect_match not "^foo" from \
        echo bar
}

function t_not_match_error() {
    expect_match not "^foo" from \
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

function t_not_code() {
    expect_code not 1 from \
        echo foo
}

function t_not_code_error() {
    expect_code not 0 from \
        echo foo
}

run_all_tests
