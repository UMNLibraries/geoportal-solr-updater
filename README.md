# Geomg Solr Core Updater

This capistrano workbook deploys and executes a simple script to clone the latest version of the [BTAA Geoportal solr configuration](https://github.com/geobtaa/geoportal-solr-config), based on the most recent git tag for that repo.

## Usage

1. install a recent Ruby (ie., with [`rbenv`](https://github.com/rbenv/rbenv) and [`ruby-build`](https://github.com/rbenv/ruby-build))
2. run `bundle install` in the root directory
3. execute `bundle exec cap dev deploy deploy:update_solr`

The third step will do the following:

1. clone this repo to `/tmp`
2. execute the `geoportal-core-updater.sh` script

### Potential Pitfalls

1. the solr core config must be versioned using a git tag.
2. If your operating system (e.g., MacOS) doesn't automatically load your ssh keys into an agent, run `ssh-add` to add your keys. Consult [`ssh-add(1)`](https://man.openbsd.org/ssh-add.1) for more information.[^1]

Tested using ruby 3.1.2/capistrano 3.17.1

[^1]: see also: [ArchWiki](https://wiki.archlinux.org/title/SSH_keys#SSH_agents), [Ubuntu](https://help.ubuntu.com/community/SSH/OpenSSH/Keys), [Void](https://docs.voidlinux.org/config/services/user-services.html)
