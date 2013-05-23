#!/bin/bash
#这个脚本使用与杀出
_FILE_DIR=`dirname $0`
_FILE_ABS_DIR=`pwd $_FILE_DIR`
WORK_DIR=$_FILE_ABS_DIR/../

cd $WORK_DIR

bundle exec rake images:cleanup