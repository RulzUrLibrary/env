.PHONY: clean clean-dist clean-virsh init run

GOPATH = $(CURDIR)/go
GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)

go_api_path = $(GOPATH)/src/github.com/rulzurlibrary/api


$(go_api_path):
	git clone git@github.com:rulzurlibrary/$(notdir $@) $@
	cd $@ && go get -d ./...


clean-dist: clean
	rm -rf $(wildcard $(GOPATH)/src/*)
clean:
	rm -f $(wildcard $(GOPATH)/bin/*)
	rm -rf $(wildcard $(GOPATH)/pkg/*)
