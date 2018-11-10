#!/bin/bash

BASE_D=$(realpath "${BASH_SOURCE%/*}/..")
export NODE=$(basename $BASE_D)
exec python "$BASE_D/service"
