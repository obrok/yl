.PHONY: build run

build:
	./rebar3 escriptize

run: build
	_build/default/bin/yl
