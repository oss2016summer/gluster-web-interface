#! /bin/sh

PORT=3000
SUBDOMAIN=gluster
PROJ_PATH=

$PROJ_PATH/rails s &
lt -p $PORT -s $SUBDOMAIN
