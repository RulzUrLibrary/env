.PHONY: clean clean-dist clean-virsh init run

GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)

go_api_path = $(GOPATH)/src/github.com/rulzurlibrary/api

init: front api app

push:
	rsync -Lrav -e ssh --exclude=".go" --exclude="backup" . \
		root@rulz.xyz:/root/rulzurlibrary

backup.pull:
	rsync -rav root@rulz.xyz:/root/backup .

backup.push:
	rsync -rav backup root@rulz.xyz:/root/backup

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
