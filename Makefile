.PHONY: clean clean-dist clean-virsh init run

GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)

go_api_path = $(GOPATH)/src/github.com/rulzurlibrary/api
go_bind_data = $(GOPATH)/src/github.com/jteeuwen/go-bindata

init:  front api

$(go_bind_data):
	go get -u github.com/jteeuwen/go-bindata/...

api: $(go_bind_data)
	git clone git@github.com:rulzurlibrary/$(notdir $@) $(@)
	mkdir -p $(dir $(go_api_path))
	ln -s $(abspath $@) $(go_api_path)
	cd $(go_api_path) && go get -d ./...

front: api
	git clone git@github.com:rulzurlibrary/$(notdir $@) $@
	ln -s $(abspath $@) $(go_api_path)/assets/front

clean-dist: clean
	rm -rf $(GOPATH) api front
clean:
	rm -f $(wildcard $(GOPATH)/bin/*)
	rm -rf $(wildcard $(GOPATH)/pkg/*)
