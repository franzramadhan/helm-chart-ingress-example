.PHONY: chart db scripts

prepare:
	eval ./scripts/dependencies.sh

build:
	eval ./scripts/build.sh

compose:
	docker-compose -f docker-compose.yaml config && docker-compose up --build --force-recreate

init:
	eval ./scripts/initialize.sh

lint:
	helm lint ./chart

pack:
	helm package ./chart

check: lint
	helm install --dry-run --debug mychart ./chart

install: lint
	eval ./scripts/generate_config.sh
	helm install mychart ./chart

update: lint
	helm upgrade mychart ./chart

uninstall:
	helm uninstall mychart || true
	kubectl delete configmaps app-configmap db-configmap || true
	kubectl delete secrets app-secrets db-secrets || true

destroy:
	eval ./scripts/destroy.sh

help:
	cat ./Makefile
