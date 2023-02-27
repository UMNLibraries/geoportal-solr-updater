#!/bin/bash

#########################################################################################
# This script is designed to be pulled onto a Geoportal/Geoblacklight solr server using #
# capistrano, then executed to update the solr core from the latest git tag.            #
# See the README.md for more details                                                    #
#########################################################################################

set -eu

# get the newest solr core git tag
# note to future self: the range of characters being cut will eventually need to be adjusted if we get to double digits
SOLR_GIT_TAG=$(curl -o- -fsSL "https://api.github.com/repos/geobtaa/geoportal-solr-config/tags" | jq 'first(.[]).name' | cut -b 2-6)

SOLR_CORE_DIR=/opt/data/solr-cores/geomg

# This will need to run as the uldeploy user, so we can restart solr etc right from here.
sudo /bin/systemctl stop solr.service

# update the solr core itself
git -C $SOLR_CORE_DIR pull --rebase
git -C $SOLR_CORE_DIR checkout $SOLR_GIT_TAG

echo $(git -C $SOLR_CORE_DIR status)

sudo /bin/systemctl start solr.service

exit 0
