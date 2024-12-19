#!/bin/bash
SRC_FILE=${1:-test.s}

OBJ_FILE="${SRC_FILE%.s}.o"
EXE_FILE="${SRC_FILE%.s}"

as -o "$OBJ_FILE" "$SRC_FILE"
ld -s -o "$EXE_FILE" "$OBJ_FILE"