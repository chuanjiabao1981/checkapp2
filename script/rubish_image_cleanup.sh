#!/bin/bash
_FILE_DIR=`dirname $0`
_FILE_ABS_DIR=`cd $_FILE_DIR;pwd`
WORK_DIR=$_FILE_ABS_DIR/../

cd $WORK_DIR
##注意这个目录
source "/home/work/.rvm/scripts/rvm"
bundle exec rake images:cleanup RAILS_ENV="production"