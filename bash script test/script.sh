#!/bin/bash
iverilog -o test $1
vvp test