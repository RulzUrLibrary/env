.PHONY: clean clean-dist clean-virsh init run backup

GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)

go_api_path = $(GOPATH)/src/github.com/rulzurlibrary/api
ssh = ssh root@rulz.xyz
rsync = rsync -av -e ssh --delete

init: front api app

ssh:
	$(ssh)

push:
	$(rsync) --exclude=".go" --exclude="backup" --exclude="app" \
		. root@rulz.xyz:/root/rulzurlibrary

backup:
ifndef NO_BACKUP
	$(ssh) "rulzurlibrary/assets/backup.sh"
endif

backup.pull:
	$(rsync) root@rulz.xyz:/root/backup .

backup.push:
	$(rsync) backup root@rulz.xyz:/root/

prod: push backup backup.pull
	$(ssh) "cd rulzurlibrary && assets/setup.prod.sh ../backup/latest"

api:
	mkdir -p $(dir $(go_api_path))
	git clone git@github.com:rulzurlibrary/$(notdir $@) $(@)
	ln -s $(abspath $@) $(go_api_path)
	cd $(go_api_path) && go get -d ./...

front: api
	git clone git@github.com:rulzurlibrary/$(notdir $@) $@
	ln -s $(abspath $@) $(go_api_path)/assets/front

app:
	git clone git@github.com:rulzurlibrary/$(notdir $@) $@

clean-dist: clean
	rm -rf $(GOPATH) api front
clean:
	rm -f $(wildcard $(GOPATH)/bin/*)
	rm -rf $(wildcard $(GOPATH)/pkg/*)
