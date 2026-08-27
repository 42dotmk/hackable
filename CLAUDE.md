# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A workspace of self-written replacements for the user's day-to-day system software ("hackable" tools — see `hackable.md`). It is not one codebase: each subdirectory is an **independent git repository** with its own `CLAUDE.md` containing the build commands, architecture, and style rules for that project. Always read the subproject's `CLAUDE.md` before working in it; this file only orients you across them.

| Project | What it is |
|---|---|
| `hed/` | Terminal text editor in C, plugin-first architecture, tree-sitter highlighting, swappable vim/emacs/vscode keymaps |
| `hterm/` | SDL2 terminal emulator; SDL-free emulator core (`term.c`) with headless tests via `make check` |
| `hwm/` | Scrollable-column (niri-style layout, dwm-style construction) X11 tiling window manager |
| `hws/` | Niri-style workspace/window overview overlay for X11 (EWMH client, live composited thumbnails) |
| `htray/` | System tray + status bar overlay for X11 (XEmbed, single file) |
| `hnd/` | Desktop notification daemon (org.freedesktop.Notifications over raw libdbus, single file) |
| `hmenu/` | Rofi-style launcher (centered X11 window, item lists from shell commands, matching delegated to `fzf --filter`, single file) |
| `hsm/` | Runit-style service supervisor (daemon `hsmd` + client `hsm`), in progress |
| `hml/` | IMAP/Maildir mail sync, mbsync-compatible on-disk state (shares `~/.mail` with mbsync), in progress |
| `hstt/` | Speech-to-text dictation: hotkey-toggled mic recording, local whisper.cpp transcription, types into the focused X11 window via XTEST (single file) |

Planned, not yet started: `hweb` (browser).

## Shared conventions

All projects follow the same suckless-style ethos, so cross-project habits transfer:

- Pure C11, minimal dependencies, `-pedantic -Wall -Wextra` builds that must stay warning-free — the compiler flags are the linter.
- Configuration is compiled in: every project keeps its settings in a `config.h` included by the main source file (hed's is `src/config.h`), never runtime config files. Changing settings means editing source and recompiling.
- `make` builds, `make install` symlinks into `~/.local/bin` (no sudo), `make clean` cleans. The root `Makefile` fans these out across all projects (`make`, `make install`, `make <project>`); hed is the one exception — its symlink install target is `install-dev`, which the root makefile uses.
- Only hed (`make test`) and hterm (`make check`) have test suites. The X11 projects are verified by running them (hwm can be driven under Xephyr; see its CLAUDE.md).
- `vendor/stb_ds.h` is the shared dynamic-array vendored dependency where one is needed.
- Prefer deleting features to adding flags; keep code small and readable. Formatting is uniform: every repo carries the same `.clang-format` (hed's — 4-space indent, attached braces, 80 columns, sorted includes; hed's `fmt` plugin runs plain `clang-format -i`), so run `clang-format -i` on files you touch.

## Cross-project relationships

These tools are developed against each other and run together as the user's live desktop session: `hwm` is the WM, `hterm` the terminal, `hed` the editor, `htray`/`hws` are EWMH companions to `hwm`. Consequences:

- A bug observed in one tool may belong to a sibling (e.g. terminal rendering issues seen in hed may be hterm's or hwm's fault); fixes sometimes land in the neighbor repo.
- Rebuilding can go live immediately: a running `hwm` watches its own binary and re-execs after `make` replaces it. Be aware of this before rebuilding hwm on the user's machine.
- `hws`, `htray`, and `hwm` interoperate purely through EWMH root-window messages — they must stay WM/client-agnostic, not grow private protocols.
- `hws` yields its keyboard/pointer grab (and stops re-raising) while an override-redirect `_NET_WM_WINDOW_TYPE_DIALOG` window is mapped — that is how `hmenu` works on top of the overview. It keys on the EWMH window type, not on hmenu specifically; any grabbing popup that sets DIALOG gets the same courtesy.
