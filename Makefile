LIBS=-L lib

.PHONY: clean floor deps examples

clean:
	rm -rf lib && mkdir lib

floor:
	rm -f lib/libfloor-*
	rustc $(LIBS) --opt-level=3 src/lib.rs --out-dir lib/

test:
	rustc -L lib --opt-level=3 --test src/lib.rs -o floor-test
	./floor-test --test --bench

deps:
	@if [ -e .git ] ; then \
		git submodule init; \
		git submodule sync; \
		git submodule update; \
	fi
	rm -f lib/libhttp*
	cd lib/rust-http; ./configure
	make -C lib/rust-http clean
	make -C lib/rust-http http
	cp lib/rust-http/build/libhttp* lib/

examples:
	rustc $(LIBS) examples/example.rs -o examples/example

doc:
	rustdoc $(LIBS) src/lib.rs

all: clean deps floor examples

run:
	./examples/example