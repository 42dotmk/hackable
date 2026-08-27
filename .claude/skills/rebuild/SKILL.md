---
name: rebuild
description: Rebuild and reinstall one hackable project (or all of them) from
  ~/projects/hackable. Use when the user says /rebuild, asks to rebuild,
  reinstall, or redeploy hed/hterm/hwm/hws/htray/hnd/hmenu/hsm/hml/hstt, or
  wants a config.h change made live.
---

Rebuild hackable projects. Argument: a project name (hed, hterm, hwm, hws,
htray, hnd, hmenu, hsm, hml, hstt) or nothing/`all` for everything.

Steps:

1. For a single project: run `make` in ~/projects/hackable/<project>.
   For all: run `make` in ~/projects/hackable (the root Makefile fans out).
2. The build must finish warning-free (-pedantic -Wall -Wextra). If there
   are warnings or errors, stop and report them — do not install a broken
   build.
3. Install the symlinks: `make install` in the project directory — except
   hed, whose symlink target is `make install-dev`. For the all case,
   `make install` at the root already handles the hed exception.
4. If the project has tests, run them: hed `make test`, hterm `make check`.
5. If hwm was rebuilt, tell the user: the running hwm re-execs itself as
   soon as `make` replaces its binary — the live session has already
   picked it up.

Report which projects were rebuilt, test results, and any live-session
effects.
