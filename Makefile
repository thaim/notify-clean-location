function := "NotifyCleanLocation"

.PHONY: help deps lint test fmt build clean

help: ## Show help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

venv: ## generate venv (for local development)
	python3 -m venv venv

test:  ## Run tests
	echo "test not implemented yet"

package: ## generate package for lambda
	mkdir -p package
	pip install -r requirements.txt -t package
	cp notify.py package/
	cd package; zip -r9 ../function.zip .

deploy: package ## deploy lambda function
	aws lambda update-function-code \
		--function-name $(function) \
		--zip-file fileb://function.zip

clean: ## Remove unnecessary files
	-@rm -r function.zip package
