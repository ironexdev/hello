shutdown:
	@docker stack rm hello

deploy:
	@docker stack deploy hello -c docker-compose.prod.yml

# Volume has to be prefixed with stack name (hello)
tls-cert:
	@docker run --rm -p 443:443 -p 80:80 -v hello_certbot:/etc/letsencrypt ironex/certbot certonly -n -m "info@by-ironex.com" -d hello.by-ironex.com --standalone --agree-tos

composer:
	@docker run --rm --interactive --tty --volume $$PWD/app:/app --volume vendor:/app/vendor ironex/composer $(action)

remove-containers:
	@docker container rm $(docker ps -aq) --force

build-image:
	@docker buildx build --platform linux/amd64 --no-cache -f ./etc/${image}/Dockerfile -t ironex/${image} .

build-images:
	@docker buildx build --platform linux/amd64 --no-cache -f ./etc/certbot/Dockerfile -t ironex/certbot .
	@docker buildx build --platform linux/amd64 --no-cache -f ./etc/composer/Dockerfile -t ironex/composer .
	@docker buildx build --platform linux/amd64 --no-cache -f ./etc/mysql/Dockerfile -t ironex/mysql .
	@docker buildx build --platform linux/amd64 --no-cache -f ./etc/nginx/Dockerfile -t ironex/nginx .
	@docker buildx build --platform linux/amd64 --no-cache -f ./etc/php-fpm/Dockerfile -t ironex/php-fpm .

push-image:
	@cd etc/${image};
	@echo $(shell pwd);
	@docker push ironex/${image};

push-images:
	@cd etc/certbot;
	@echo $(shell pwd);
	@docker push ironex/certbot;
	@cd etc/composer;
	@echo $(shell pwd);
	@docker push ironex/composer;
	@cd etc/mysql;
	@echo $(shell pwd);
	@docker push ironex/mysql;
	@cd etc/nginx;
	@echo $(shell pwd);
	@docker push ironex/nginx;
	@cd etc/php-fpm;
	@echo $(shell pwd);
	@docker push ironex/php-fpm;

remove-images:
	@docker rmi $$(docker images -a -q) --force