DOCKER=docker
DOCKER_VOLUME=-v ${PWD}:/usr/src
DOCKER_USER=-u `id -u`:`id -g`

DOCKER_IMAGE?=vidbina/gdb-play-001

image:
	${DOCKER} build --rm --force-rm -t ${DOCKER_IMAGE} .

shell:
	${DOCKER} run --rm -it \
		${DOCKER_IMAGE} \
		/bin/bash

mounted-shell:
	${DOCKER} run --rm -it \
		${DOCKER_VOLUME} ${DOCKER_USER} \
		${DOCKER_IMAGE} \
		/bin/bash

.PHONY: image mounted-shell shell
