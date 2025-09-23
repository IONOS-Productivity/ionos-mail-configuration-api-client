
.PHONY: help php

help: ## This help.
	@echo "Usage: make [target]"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

php: ## Generate PHP client
	$(eval VERSION=$(shell jq -r '.info.version' .ncw-mail-configuration.json))
	@echo "Generating PHP client for version ${VERSION}"

	./node_modules/.bin/openapi-generator-cli generate \
	--skip-validate-spec \
	-i .ncw-mail-configuration.json \
	-g php \
	-o . \
	--global-property apiTests=false,modelTests=false \
	--additional-properties=httpUserAgent=ionos-mail-configuration-api-client/${VERSION}/PHP \
	-c ./openapi-generator/php_lang.yaml
