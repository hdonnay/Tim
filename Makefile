DESTDIR ?= $(HOME)
BINDIR ?= .bin

install:
	install -Dm 0755 tim $(DESTDIR)/$(BINDIR)/tim
