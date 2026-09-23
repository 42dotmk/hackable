# hackable

The [Base42](https://42.mk) hackable desktop: self-written replacements
for the day-to-day system software we use, in the suckless spirit —
small C programs, compiled-in configuration, minimal dependencies,
`-Wall -Wextra -pedantic` clean.

It comes in two shapes:

- **A distro.** [hos](https://github.com/42dotmk/hos) is the hackable
  tools as a bootable live ISO, from the kernel up: hos's own init,
  initramfs, boot scripts, service manager and installer over packages
  and a kernel from the Void repositories — the whole desktop as an
  operating system, sources included.
- **Separate apps.** Every tool lives in its own repository, builds on
  its own, and runs on any Linux desktop. They interoperate only through
  standard protocols (EWMH, XEmbed, D-Bus, OSC escape sequences,
  sendmail-compatible SMTP), so each one can replace — or be replaced
  by — its third-party counterpart. Use one, a few, or all of them.

This meta-repo ties the pieces together. The submodule pins are a
**known-good set**: these exact commits run together as a live desktop
session, and are what a hos ISO is built from.

## The tools

| Project | What it is |
|---|---|
| [hed](https://github.com/42dotmk/hed) | Terminal text editor, plugin-first architecture, tree-sitter highlighting, swappable vim/emacs/vscode keymaps |
| [hterm](https://github.com/42dotmk/hterm) | SDL2 terminal emulator; SDL-free emulator core with headless tests |
| [hwm](https://github.com/42dotmk/hwm) | Scrollable-column (niri-style layout, dwm-style construction) X11 tiling window manager |
| [hws](https://github.com/42dotmk/hws) | Niri-style workspace/window overview overlay for X11 (EWMH, live composited thumbnails) |
| [htray](https://github.com/42dotmk/htray) | System tray + status bar overlay for X11 (XEmbed, single file) |
| [hnd](https://github.com/42dotmk/hnd) | Desktop notification daemon (org.freedesktop.Notifications over raw libdbus, single file) |
| [hbg](https://github.com/42dotmk/hbg) | Background setter/rotator: cover-scales images onto each monitor, esetroot pixmap protocol (single file) |
| [hmenu](https://github.com/42dotmk/hmenu) | Rofi-style launcher (item lists from shell commands, matching delegated to `fzf --filter`, single file) |
| [hml](https://github.com/42dotmk/hml) | Mail in one binary: IMAP/Maildir sync with mbsync-compatible on-disk state, SMTP send, notmuch-style search index (SQLite FTS5) |
| [hstt](https://github.com/42dotmk/hstt) | Speech-to-text dictation: hotkey-toggled recording, local whisper.cpp transcription, types into the focused window (single file) |
| [hweb](https://github.com/42dotmk/hweb) | Vim-like WebKitGTK browser: one window per process, modal keys, events on stdout / commands on stdin |
| [hai](https://github.com/42dotmk/hai) | Hackable AI: agentic loop in C for any OpenAI-compatible model (tool calling, SSE streaming), daemon + client, speaks and listens through piper and hstt |
| [hsm](https://github.com/42dotmk/hsm) | Runit-style service supervisor (daemon `hsmd` + client `hsm`); runs as PID 1 on hos |

## The distro

[hos](https://github.com/42dotmk/hos) turns the toolset into a bootable
live ISO: packages and kernel from the Void repositories (xbps), and
above them hos's own — a static C init in an initramfs it builds itself,
`hsmd` as pid 1 with hos's boot scripts, a grub menu, an installer — with
the tools' sources on the ISO at `/usr/src/hackable` and binaries
symlinked into `/bin`. Boot it, edit the source, `make`, and you are
running your change. The ISO is described by `PACKAGES`, `SERVICES`,
`IGNORE`, `overlay/` and `init/`; no void-mklive, no dracut.

```sh
cd hos
make iso     # build the ISO (no sudo: root work runs in a user namespace)
make qemu    # boot the newest ISO under kvm
```

## The apps, on your existing desktop

```sh
git clone --recursive https://github.com/42dotmk/hackable
cd hackable
make            # build every project
make install    # symlink everything into ~/.local/bin (no sudo)
make hwm        # or build (and cd hwm && make install) just one
```

Each subproject's own README covers its usage and per-project install.
Nothing here assumes the rest of the set is present.

## Conventions

- Pure C11, minimal dependencies; the compiler flags are the linter.
- Configuration is compiled in (`config.h`): change the source,
  recompile. Exception in progress: hmenu pilots `hconf`, a tiny reader
  that overlays `~/.config/hackable/<tool>.conf` onto the compiled-in
  defaults; if it holds, the other tools adopt it.
- `make` builds, `make install` symlinks into `~/.local/bin`,
  `make clean` cleans — in every repo.
- The tools interoperate only through standard protocols, so each
  remains usable with third-party counterparts.
