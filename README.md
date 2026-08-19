# hackable

The [Base42](https://42.mk) hackable desktop: self-written replacements
for the day-to-day system software we use, in the suckless spirit —
small C programs, compiled-in configuration, minimal dependencies,
`-Wall -Wextra -pedantic` clean.

Each tool lives in its own repository and is usable on its own; this
meta-repo ties them together. The submodule pins are a **known-good
set**: these exact commits run together as a live desktop session.

| Project | What it is |
|---|---|
| [hed](https://github.com/42dotmk/hed) | Terminal text editor, plugin-first architecture, tree-sitter highlighting, swappable vim/emacs/vscode keymaps |
| [hterm](https://github.com/42dotmk/hterm) | SDL2 terminal emulator; SDL-free emulator core with headless tests |
| [hwm](https://github.com/42dotmk/hwm) | Scrollable-column (niri-style layout, dwm-style construction) X11 tiling window manager |
| [hws](https://github.com/42dotmk/hws) | Niri-style workspace/window overview overlay for X11 (EWMH, live composited thumbnails) |
| [htray](https://github.com/42dotmk/htray) | System tray + status bar overlay for X11 (XEmbed, single file) |
| [hnd](https://github.com/42dotmk/hnd) | Desktop notification daemon (org.freedesktop.Notifications over raw libdbus, single file) |
| [hml](https://github.com/42dotmk/hml) | IMAP/Maildir mail sync, mbsync-compatible on-disk state, in progress |
| [hsm](https://github.com/42dotmk/hsm) | Runit-style service supervisor (daemon `hsmd` + client `hsm`), in progress |

Planned, not yet started: `hweb` (browser).

## Build the whole desktop

```sh
git clone --recursive https://github.com/42dotmk/hackable
cd hackable
make            # build every project
make install    # symlink everything into ~/.local/bin (no sudo)
make hwm        # or build just one
```

Each subproject's own README covers its usage and per-project install.

## Conventions

- Pure C99 (hed is C11), minimal dependencies; the compiler flags are
  the linter.
- Configuration is compiled in (`config.h` / `config.c`), never runtime
  config files: change the source, recompile.
- `make` builds, `make install` symlinks into `~/.local/bin`,
  `make clean` cleans — in every repo.
- The tools interoperate only through standard protocols (EWMH, XEmbed,
  D-Bus, OSC escape sequences), so each remains usable with third-party
  counterparts.
