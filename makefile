# upcase
# See LICENSE for copyright and license details.

PREFIX := /usr/local

install: build
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f build/upcase $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/upcase

uninstall:
	if [ -f $(DESTDIR)$(PREFIX)/bin/upcase ]; then \
		rm $(DESTDIR)$(PREFIX)/bin/upcase; \
	fi; \

build: object
	if [ ! -d build ]; then \
		mkdir build; \
	fi; \
	ld -o build/upcase upcase.o

object: upcase.asm
	nasm -f elf64 -o upcase.o upcase.asm

object-debug: upcase.asm
	if [ ! -d build ]; then \
		mkdir build; \
	fi; \
	nasm -f elf64 -g -F dwarf -o upcase-dbg.o upcase.asm

debug: object-debug
	ld -o build/upcase-dbg upcase-dbg.o

clean:
	if [ -d build ]; then \
		rm -r build; \
	fi; \
	if [ -f upcase.o ]; then \
		rm upcase.o; \
	fi; \
	if [ -f upcase-dbg.o ]; then \
		rm upcase-dbg.o; \
	fi; \
