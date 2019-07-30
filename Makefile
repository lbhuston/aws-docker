# Simple makefile to setup enviornment for docker.  To build the docker
# containers you need to explictly run `make docker`.  This can be slow the
# first time.

SHELL = /bin/bash

.PHONY: all
all: docker


# Build the docker container.  We don't do this by default since it can
# take a while in some cases.
.PHONY: docker
docker: terraform
	docker build -t lbhuston/aws_dev -f Dockerfile.aws_dev .

# Get Linux terraform binary to add to the docker image
terraform:
	wget -qO- https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip | tar -xf-


.PHONY: clean
clean:
	# These can throw errors if the images don't exist
	-docker rmi -f lbhuston/aws_dev 2> /dev/null; true
	-docker image prune -f 2> /dev/null; true
	rm -f terraform


.PHONY: runaws
runaws: docker
	docker run -it lbhuston/aws_dev

