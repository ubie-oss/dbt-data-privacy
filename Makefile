lint: lint-yaml lint-bash

lint-yaml:
	bash ./ci/lint_yaml.sh

lint-bash:
	bash ./ci/lint_bash.sh

generate-toc:
	markdown-toc --maxdepth 5 -i README.md
