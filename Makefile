DOCKER_USERNAME = poldrack
CONTAINER_NAME = shinyserver

# code to check environment variables
# from https://stackoverflow.com/questions/4728810/makefile-variable-as-prerequisite

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

current_dir = $(shell pwd)

# commands for building and testing docker image

docker-deploy: docker-login docker-upload

docker-login: guard-DOCKER_USERNAME guard-DOCKER_PASSWORD
	docker login --username=$(DOCKER_USERNAME) --password=$(DOCKER_PASSWORD)

docker-upload: guard-DOCKER_USERNAME
	docker push $(DOCKER_USERNAME)/${CONTAINER_NAME}

docker-build: guard-DOCKER_USERNAME
	docker build -t $(DOCKER_USERNAME)/${CONTAINER_NAME} .

docker-run-simple: # run shiny server
	docker run -p 3838:3838 --rm $(DOCKER_USERNAME)/${CONTAINER_NAME}

docker-run: 
	docker run --rm -d -v /srv/shinyapps/:/srv/shiny-server/ -v /srv/shinylog/:/var/log/shiny-server/ \
	-p 80:3838 $(DOCKER_USERNAME)/${CONTAINER_NAME}
    	

shell: guard-DOCKER_USERNAME
    docker run -it --entrypoint=bash -v $(current_dir):/analysis $(DOCKER_USERNAME)/${CONTAINER_NAME} /bin/bash
