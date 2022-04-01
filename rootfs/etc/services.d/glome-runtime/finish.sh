#!/usr/bin/execlineb -S0
# ==============================================================================
# Home Assistant Add-on: Glome runtime
# Take down the S6 supervision tree when the Glome runtime fails
# ==============================================================================
if -n { s6-test $# -ne 0 }
if -n { s6-test ${1} -eq 256 }

s6-svscanctl -t /var/run/s6/services