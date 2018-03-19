#!/bin/bash
#
#  Step 1 - get a list of the hosts
#
RUBYOPT='-W0' vagrant status | grep running | awk '{print $1}' | tee vml.txt
