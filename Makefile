.PHONY: build run deps test

build:
	./rebar3 escriptize

run: build
	_build/default/bin/yl

deps:
	mix deps.get

test:
	mix test
