# Binary name
ProjectName := multiroom
REGISTRY := flexy2dd

SHELL := /bin/bash
# some terminal color escape codes
LIGHT_GREEN := $(shell echo -e "\033[1;32m")
NC := $(shell echo -e "\033[0m") # No Color

.DEFAULT_GOAL := build

build:
	@echo "Building docker image $(ProjectName)"
	docker build --rm -t ${REGISTRY}/$(ProjectName) .
.PHONY: build

clean-all:
	@echo "Clean docker image $(ProjectName)"
	@docker rm -v $(ProjectName)
	@docker rmi ${REGISTRY}/$(ProjectName)
.PHONY: clean-all
	
exec:
	@echo "Exec docker image $(ProjectName)"
	docker exec -t -i $(ProjectName) /bin/bash
.PHONY: exec

rebuild:
	@echo "Rebuilding docker image $(ProjectName)"
	docker rmi ${REGISTRY}/$(ProjectName)
	docker build -q -t ${REGISTRY}/$(ProjectName) .
.PHONY: rebuild

run:
	@echo "Running docker image $(ProjectName)"
	docker run --net=host --rm -it --name $(ProjectName) -v /home/multiroom/datas:/var/lib/mopidy/.config -d ${REGISTRY}/$(ProjectName)
.PHONY: run

logs:
	@echo "View logs of docker process $(ProjectName)"
	docker logs $(ProjectName) -f
.PHONY: logs

kill:
	@echo "Kill docker process $(ProjectName)"
	docker kill $(ProjectName)
.PHONY: kill
