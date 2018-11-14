hash= $(shell ./bin/md5_hash.py requirements.txt)
PYTHON_VERSION=3.6
venv = .venv/py${PYTHON_VERSION}-${hash}
dev = $DEVELOMPENT
export DEVELOPMENT=false
default: update_venv

.PHONY: default

${venv}: requirements.txt
	python${PYTHON_VERSION} -m venv ${venv}
	. ${venv}/bin/activate; pip install -r requirements.txt --cache .tmp/

update_venv: requirements.txt ${venv}
	@rm -f .venv/current
	@ln -s py${PYTHON_VERSION}-$(hash) .venv/current
	@echo Success, to activate the development environment, run:
	@echo "\tsource .venv/current/bin/activate"

publish_pkg:
	python${PYTHON_VERSION} -m pip install --user --upgrade setuptools wheel twine
	python${PYTHON_VERSION} setup.py sdist bdist_wheel
	python${PYTHON_VERSION} -m twine upload dist/*
	@rm -rf dist/ build/ hitools.egg-info/
