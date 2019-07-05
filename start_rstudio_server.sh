#!/bin/bash

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
USER=`whoami`
# set a user-specific secure cookie key
COOKIE_KEY_PATH=/tmp/rstudio-server/${USER}_secure-cookie-key
rm -f $COOKIE_KEY_PATH
mkdir -p $(dirname $COOKIE_KEY_PATH)
uuid > $COOKIE_KEY_PATH
chmod 600 $COOKIE_KEY_PATH

# store the currently activated conda environment in a file to be ready by rsession.sh
CONDA_ENV_PATH=/tmp/rstudio-server/${USER}_current_env
rm -f $CONDA_ENV_PATH
echo "## Current env is >>"
echo $CONDA_PREFIX
echo $CONDA_PREFIX > $CONDA_ENV_PATH

/usr/lib/rstudio-server/bin/rserver --server-daemonize=0 \
  --www-port $1 \
  --secure-cookie-key-file $COOKIE_KEY_PATH \
  --rsession-which-r=$(which R) \
  --rsession-ld-library-path=$CONDA_PREFIX/lib \
  --rsession-path="$CWD/rsession.sh"