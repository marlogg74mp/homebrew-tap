# Homebrew tap for ZipMount

[ZipMount](https://github.com/marlogg74mp/zipmount) mounts zip, 7z, tar and
tar.gz archives read-only, without extracting — as a folder in Finder on
macOS, through the system's own NFS client (no macFUSE, no kernel extension).

```
brew install marlogg74mp/tap/zipmount
zipmount shell-install      # "Mount with ZipMount" in Finder's Quick Actions
```

The formula builds ZipMount from the source of the tagged release, on your
Mac: nothing to sign, nothing for Gatekeeper to object to.

Issues and questions belong in the
[main repository](https://github.com/marlogg74mp/zipmount/issues).
