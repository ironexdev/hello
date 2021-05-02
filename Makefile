composer:
	docker exec php-fpm composer $(action) # make composer action=install

build-image:
	@docker buildx build --platform linux/amd64 ./etc/${image}/.

build-images:
	@docker buildx build --platform linux/amd64 -f ./etc/mysql/Dockerfile -t ironex/mysql .
	@docker buildx build --platform linux/amd64 -f ./etc/nginx/Dockerfile -t ironex/nginx .
	@docker buildx build --platform linux/amd64 -f ./etc/php-fpm/Dockerfile -t ironex/php-fpm .

push-image:
	@cd etc/${image};
	@echo $(shell pwd);
	@docker push ironex/${image};

push-images:
	@cd etc/mysql;
	@echo $(shell pwd);
	@docker push ironex/mysql;
	@cd etc/nginx;
	@echo $(shell pwd);
	@docker push ironex/nginx;
	@cd etc/php-fpm;
	@echo $(shell pwd);
	@docker push ironex/php-fpm;