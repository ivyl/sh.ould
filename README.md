# sh.ould

## Project

**BASH** Testing Framework

## Features:
 * WIP
 * Runner
 * Nice matchers
 * Nice output (colors, backtraces)

## Conventions:
 * t\_whatever\_you\_like - functions which names begin in t\_ are runned
   automatically by runner
 * before and after - define those functions, they'll be evaluated every test call (before and after).


## Matchers:

### expect:

Expects output, does not check status code.

    expect "foo\nbar" from \
      ls unf

### expect\_code

    expect_code $SUCCESS from \
       command_under_test

### expect\_match

Regexp. Throught grep -E

    expect_match "regexp" from \
       command_under_test

### negating

All matchers can be negated with not just after name, before expectation

    expect not "foo" from \
       echo bar

## Runner:

    run_all_tests
