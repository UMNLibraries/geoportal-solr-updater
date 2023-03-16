#!/bin/bash

#########################################################################################
# This script is designed to be pulled onto a Geoportal/Geoblacklight solr server using #
# capistrano, then executed to update the solr core from the latest git tag.            #
# See the README.md for more details                                                    #
#########################################################################################

set -eu

##
## permissions problems
##	1. the solr core dir is owned by 'ulapps' and not 'uldeploy'
##		- *solved*: gave uldeploy permission to run git with sudo
##
##	2. systemctl permisisons for restarting solr
##

# get the newest solr core git tag
# note to future self: the range of characters being cut will eventually need to be adjusted if we get to double digits
SOLR_GIT_TAG=$(curl -o- -fsSL "https://api.github.com/repos/geobtaa/geoportal-solr-config/tags" | jq 'first(.[]).name' | cut -b 2-6)

# set the solr core dir
SOLR_CORE_DIR=/opt/data/solr-cores/geomg

# This will need to run as the uldeploy user, so we can restart solr etc right from here.
sudo /bin/systemctl stop solr.service

# update the solr core itself
sudo -u ulapps git -C $SOLR_CORE_DIR reset --hard
sudo -u ulapps git -C $SOLR_CORE_DIR pull --rebase
sudo -u ulapps git -C $SOLR_CORE_DIR checkout $SOLR_GIT_TAG

echo -e \n$(sudo -u ulapps git -C $SOLR_CORE_DIR status)\n

# funky dirty terrible, don't try this at home kids
sudo chown uldeploy:uldeploy $SOLR_CORE_DIR/conf/solrconfig.xml $SOLR_CORE_DIR/core.properties
mv -f $SOLR_CORE_DIR/conf/solrconfig.xml $SOLR_CORE_DIR/conf/solrconfig.git
mv -f $SOLR_CORE_DIR/core.properties $SOLR_CORE_DIR/core.properties.git
sed 's/production/geomg/g' $SOLR_CORE_DIR/core.properties.git > $SOLR_CORE_DIR/core.properties
# will need to escape some of this
sed '80g/<requestHandler name="/replication" class="solr.ReplicationHandler" startup="lazy" />'  $SOLR_CORE_DIR/conf/solrconfig.xml.git > $SOLR_CORE_DIR/conf/solrconfig.xml



sudo /bin/systemctl start solr.service

exit 0
