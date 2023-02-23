# Some magic for make to see the exit value of a command who's output is piped
SHELL = bash
.SHELLFLAGS = -o pipefail -c


FLAKE8='flake8'
BEHAVE='behave'
PYLINT=pylint

SOURCE=animal

.PHONY: test

all: test

flake8: $(SOURCE)
	$(FLAKE8) --show-source $(SOURCE)

pylint: $(SOURCE)
	$(PYLINT) $(SOURCE)

test: pylint flake8

#test: pylint flake8
#	cd test && make

