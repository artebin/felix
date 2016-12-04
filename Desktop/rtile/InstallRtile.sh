#!/bin/sh

SCRIPT_PATH=$(readlink -f "$0")
BASEDIR=$(dirname ${SCRIPT_PATH})

configure_rtile(){
  cd ${BASEDIR}
  git clone https://github.com/xhsdf/rtile
}

configure_rtile
