#!/bin/bash

#########################################################################################
# This script is designed to be pulled onto a Geoportal/Geoblacklight solr server using #
# capistrano, then executed to update the solr core from the latest git tag.            #
# See the README.md for more details                                                    #
#########################################################################################

set -eu


## permissions problems
##	1. the solr core dir is owned by 'ulapps' and not 'uldeploy'
##		- potential workaround could be to clone the updated solr core somewhere where uldeploy has write permissions and then chown/chmod it to ulapps.
##		- would maybe need to be a deploy folder in /opt/* which could be chown'd to ulapps and then moved into place?
##	2. systemctl permisisons for restarting solr
##
## ------
## uldeploy can do the following per /etc/sudoers.d/umnlib-deploy-user
## chown: 		/bin/chown -R * /opt/data/solr-cores*, /bin/chown -R * /opt/solr-versions*, /bin/chown -R * /opt/var/solr*, /bin/chown -R * /opt/data*, /bin/chmod -R * /opt/data/solr-cores*
## chmod: 		/bin/chmod -R * /opt/solr-versions*, /bin/chmod -R * /opt/var/solr*, /bin/chmod -R * /opt/data*, 
## systemctl:	/bin/systemctl * solr, /bin/systemctl * ngin
## ------
## we could maybe add the appropriate git commands to let uldeploy run git as ulapps to `geomg-ansible-provision/templates/etc/sudoers.d/umnlib-deploy-user-solr.j2`?
##

# get the newest solr core git tag
# note to future self: the range of characters being cut will eventually need to be adjusted if we get to double digits
SOLR_GIT_TAG=$(curl -o- -fsSL "https://api.github.com/repos/geobtaa/geoportal-solr-config/tags" | jq 'first(.[]).name' | cut -b 2-6)

# set the solr core dir
SOLR_CORE_DIR=/opt/data/solr-cores/geomg

# idea to solve permission problem 1: create a staging directory (now I have three more problems)
mkdir -p /opt/solr/core-staging
chmod 775 /opt/solr/core-staging
chown -R ulapps:uldeploy /opt/solr/core-staging
SOLR_STAGING_DIR=/opt/solr/core-staging

# This will need to run as the uldeploy user, so we can restart solr etc right from here.
sudo /bin/systemctl stop solr.service

# update the solr core itself

git -C $SOLR_CORE_DIR pull --rebase
git -C $SOLR_CORE_DIR checkout $SOLR_GIT_TAG

echo -e \n$(git -C $SOLR_CORE_DIR status)\n

sudo chown -R ulapps:

sudo /bin/systemctl start solr.service

exit 0
