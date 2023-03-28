#!/bin/bash

#########################################################################################
# This script is designed to be pulled onto a Geoportal/Geoblacklight solr server using #
# capistrano, then executed to update the solr core from the latest git tag.            #
# See the README.md for more details                                                    #
#########################################################################################

set -eu

# get the newest solr core git tag
SOLR_GIT_TAG=$(curl -o- -fsSL "https://api.github.com/repos/geobtaa/geoportal-solr-config/tags" | jq --raw-output 'first(.[]).name')

# set the solr core dir
SOLR_CORE_DIR="/opt/data/solr-cores/geomg"

# update the solr core itself
sudo -u ulapps git -C $SOLR_CORE_DIR checkout develop
sudo -u ulapps git -C $SOLR_CORE_DIR pull
sudo -u ulapps git -C $SOLR_CORE_DIR checkout tags/$SOLR_GIT_TAG

# just to make sure you don't miss the output
echo -e "\nsolr core git status:\n"
sudo -u ulapps git -C $SOLR_CORE_DIR status
echo -e "\n"

sudo /bin/systemctl restart solr

exit 0
