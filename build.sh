#!/bin/bash
as -o test.o test.s
ld -s -o test test.o