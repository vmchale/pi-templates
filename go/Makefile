.PHONY: clean test

build:
	go-teak build src/{{ project }}.go -o verilog/{{ project }}.go.v
	mv src/{{ project }}.go.teak teak/

test run:
	go-teak run src/{{ project }}.go

clean:
	rm -rf teak/* verilog/*
