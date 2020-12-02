.PHONY: build solve test

tag = day1

solve: build
	docker run --rm advent-2020:$(tag)

build:
	docker build -t advent-2020:$(tag) .

test: 
	docker run -ti --entrypoint julia advent-2020:$(tag)
