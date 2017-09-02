RulzUrLibrary
=============

Development environment for RulzUrLibrary. Based on docker-compose, provides
utilities to set up a base architecture.

Getting Started
---------------


Reinstall VPS
-------------

```bash
# First check that your connection is working and ssh to the VPS
make ssh

# Install needed software and start services
pacman -S docker docker-compose certbot

# Exit from VPS
exit

# Push backups and start prod again without creating a backup
make backup.push
NO_BACKUP=1 make prod
```

Tips
----

You can connect to the database by running the following command when all
containers are up:

```
docker exec -ti rulzurlibrary_db psql -U rulzurlibrary
```
