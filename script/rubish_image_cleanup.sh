#!/bin/bash
_FILE_DIR=`dirname $0`
_FILE_ABS_DIR=`cd $_FILE_DIR;pwd`
WORK_DIR=$_FILE_ABS_DIR/../

cd $WORK_DIR

bundle exec rake images:cleanup RAILS_ENV="production"