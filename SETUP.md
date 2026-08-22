# Shared typesetting setup (LaTeX + Typst across two macOS accounts)

**Set up:** 2026-08-22
**Machine:** Darks-MacBook-Air (macOS)
**Accounts:** `darq` (general) and `darqstudying` (study)

## Goal

One canonical copy of the LaTeX preamble/classes and the Typst local packages,
editable from either account, with no manual syncing. Edit a file in one
account and the other account sees the change immediately — they are the same
file on disk, not copies.

## Where everything actually lives

Single source of truth:

```
/Users/Shared/typesetting/
├── texmf/            ← git repo (preamble.sty, pset.cls, homework.cls, logos, ...)
│   └── tex/latex/common/
└── typst-packages/   ← Typst @local packages (mymath, ...)  [NOT under git]
```

`/Users/Shared/` is used because macOS home directories are readable only by
their owner — neither account can reach into the other's home folder, but both
can reach `/Users/Shared`.

## Symlinks pointing at it

Nothing is duplicated. Each account has symlinks (pointers) where the tools
expect to find these files:

| Account        | Link                                              | Target                                  |
|----------------|---------------------------------------------------|-----------------------------------------|
| `darq`         | `~/texmf`                                         | `/Users/Shared/typesetting/texmf`       |
| `darq`         | `~/Library/texmf`                                 | `/Users/Shared/typesetting/texmf`       |
| `darq`         | `~/Library/Application Support/typst/packages/local` | `/Users/Shared/typesetting/typst-packages` |
| `darqstudying` | `~/texmf`                                         | `/Users/Shared/typesetting/texmf`       |
| `darqstudying` | `~/Library/texmf`                                 | `/Users/Shared/typesetting/texmf`       |
| `darqstudying` | `~/Library/Application Support/typst/packages/local` | `/Users/Shared/typesetting/typst-packages` |

### Why both `~/texmf` AND `~/Library/texmf`

The two accounts resolve `TEXMFHOME` (the per-user TeX search path)
differently — this was discovered mid-setup, not chosen:

- `darq` → `/Users/darq/texmf`
- `darqstudying` → `/Users/darqstudying/Library/texmf` (the MacTeX default)

Rather than track down where the override on `darq` comes from, **both** paths
are linked in **both** accounts. Costs nothing and is robust to GUI editors
(TeXShop, VS Code) that don't read shell config and may resolve `TEXMFHOME`
differently from the terminal.

## Deliberate design decisions

**`TEXMFHOME` is used, `TEXMFLOCAL` is untouched.**
`TEXMFLOCAL` (`/usr/local/texlive/texmf-local`) is shared by both accounts by
design, so it looks like the obvious place. It was rejected because it needs
`sudo` to write and `sudo mktexlsr` to rebuild its index after *every* new
file. `TEXMFHOME` is not indexed, so edits and new files are picked up
instantly. For an actively-edited preamble that matters a lot.

**TeX Live itself is NOT shared by this setup — it just happens to be shared
already.** Both accounts run the same installation: `TEXMFLOCAL` is
`/usr/local/texlive/texmf-local` and `pdflatex` is
`/Library/TeX/texbin/pdflatex` in both. So `tlmgr update` in one account
updates both. If a second TeX distribution is ever installed (e.g. via
Homebrew under its own prefix), that stops being true and documents may
compile in one account but not the other. Verify with `which -a pdflatex` in
both accounts.

**Typst packages are versioned directories.** A local package lives at
`typst-packages/<name>/<version>/` with a `typst.toml` beside its entrypoint,
imported as `#import "@local/mymath:0.1.0": *`. Bumping `0.1.0` → `0.2.0`
creates a *new* directory; documents pinning the old version keep compiling
against it. While the preamble is still churning, editing `0.1.0` in place is
simpler than real version bumps.

**`typst-packages/` is not under git.** Only `texmf/` is a repository. Worth
revisiting if the Typst side grows.

## Permissions

Files created by one account default to owner-only write, which would block
the other account. An inherited ACL grants the `staff` group full access,
including on files created later:

```bash
sudo chmod -R +a "group:staff allow list,add_file,search,delete,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,file_inherit,directory_inherit" /Users/Shared/typesetting
```

Both accounts are in `staff` (verified with `id -Gn <user>`; it is the macOS
default primary group).

Git refuses repos owned by another user ("dubious ownership"), so each account
has:

```bash
git config --global --add safe.directory /Users/Shared/typesetting/texmf
```

## Fonts — known gap, NOT yet done

Custom fonts in `~/Library/Fonts` are per-account and are **not** shared by
this setup. Relevant to the Statale/Touying Beamer theme, which needs Carlito.
Symptom: slides compile in one account and silently fall back to a substitute
font in the other. Fix: move custom fonts to `/Library/Fonts` (system-wide,
needs admin).

## Verifying it still works

In either account:

```bash
kpsewhich preamble.sty
ls ~/"Library/Application Support/typst/packages/local"
touch /Users/Shared/typesetting/texmf/writetest && rm /Users/Shared/typesetting/texmf/writetest && echo WRITE_OK
```

Expect: a path ending in `preamble.sty`; `mymath` listed; `WRITE_OK`.
The `WRITE_OK` check is the one that catches permission drift — without it, a
broken ACL only surfaces later as a confusing "permission denied" when saving
an edit from the study account.

Path resolution is not proof. The real test is compiling a document that uses
`preamble.sty` in **both** accounts and comparing the PDFs.

## If something looks wrong

Check whether a path is a link or a real directory:

```bash
ls -ld ~/texmf
```

The first character of the permissions block tells you: `l` = symlink (an
`-> /Users/Shared/...` arrow follows), `d` = real directory. If it says `d`
where the table above says it should be a link, the link is missing and that
account is editing an independent copy.

**Removing a symlink:** `unlink ~/texmf` — never with a trailing slash, and
never `rm -rf ~/texmf/`, which follows the link and destroys the shared target.

**Recreating a link:** if the target path already exists as a real directory,
`ln -s A B` does *not* replace `B` — it drops the link *inside* `B`. Remove or
rename the existing directory first. (This caused a nested
`typesetting/texmf/texmf` during setup.)

**zsh gotcha:** `#` is not a comment on the interactive zsh command line.
Pasting `unlink ~/texmf   # or rm ...` passes the comment as extra arguments
and fails.

## Leftovers from setup

Temporary backups, safe to delete once compiles are confirmed in both accounts:

- `darq`: `~/texmf-backup-copy`
- `darqstudying`: `~/texmf-old-backup`

Both were verified identical to the shared repo (same commits `659b3dc` /
`389d927`; only `.git/index` stat-cache differences).
