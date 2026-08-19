# Builds and installs every hackable project. Each subdir has its own
# makefile; this just fans out. All installs are symlinks into ~/.local/bin
# (hed's plain `install` copies to /usr/local, so we use its install-dev).

PROJECTS = hed hterm hwm hws htray hnd hmenu hsm hml

all:
	@for p in $(PROJECTS); do $(MAKE) -C $$p || exit 1; done

install: all
	@for p in $(PROJECTS); do \
		tgt=install; [ "$$p" = hed ] && tgt=install-dev; \
		$(MAKE) -C $$p $$tgt || exit 1; \
	done

uninstall:
	@for p in $(PROJECTS); do \
		tgt=uninstall; [ "$$p" = hed ] && tgt=uninstall-dev; \
		$(MAKE) -C $$p $$tgt || exit 1; \
	done

clean:
	@for p in $(PROJECTS); do $(MAKE) -C $$p clean || exit 1; done

# `make hed`, `make hwm`, ... build a single project
$(PROJECTS):
	$(MAKE) -C $@

.PHONY: all install uninstall clean $(PROJECTS)
