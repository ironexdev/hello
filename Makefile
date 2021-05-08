#tls-cert
CERT_EMAIL=info@by-ironex.com
CERT_DOMAINS=hello.by-ironex.com
#secrets
MYSQL_DATABASE=$(shell openssl rand -base64 20)
MYSQL_PASSWORD=$(shell openssl rand -base64 20)
MYSQL_ROOT_PASSWORD=$(shell openssl rand -base64 20)
MYSQL_USER=$(shell openssl rand -base64 20)
#composer
COMPOSER_IMAGE=ironex/composer
COMPOSER_VENDOR_VOLUME=hello_vendor

shutdown:
	@docker stack rm hello

deploy:
	@docker stack deploy hello -c docker-compose.prod.yml

secrets:
	@echo $(MYSQL_DATABASE) | docker secret create mysql_database -
	@echo $(MYSQL_PASSWORD) | docker secret create mysql_password -
	@echo $(MYSQL_ROOT_PASSWORD) | docker secret create mysql_root_password -
	@echo $(MYSQL_USER) | docker secret create mysql_user -
	@history -d -5--1 # remove bash history

# Volume has to be prefixed with stack name (hello)
tls-cert:
	@docker run --rm -p 443:443 -p 80:80 -v hello_certbot:/etc/letsencrypt ironex/certbot certonly -n -m $(CERT_EMAIL) -d $(CERT_DOMAINS) --standalone --agree-tos

composer:
	@docker run --rm --interactive --tty --volume $$PWD/app:/app --volume $(COMPOSER_VENDOR_VOLUME):/app/vendor $(COMPOSER_IMAGE) $(action)

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