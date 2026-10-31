SRCS := $(wildcard src/*.js)
DISTS := $(SRCS:src/%.js=dist/%.txt)

.PHONY: all clean

all: $(DISTS)

dist/%.txt: src/%.js build
	./build $< > $@.tmp
	mv $@.tmp $@

clean:
	rm -f dist/*.txt
