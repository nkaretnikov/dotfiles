Collection of config files, which is managed by [GNU
Stow](https://gnu.org/software/stow).

`stow <package>` will install the package into the parent directory
(relative to the one where the command is executed).  The default
behavior can be changed with the `-t` option.  For instance, `sudo
stow -t / nixos` will create this symlink in `/etc`:

```
lrwxrwxrwx 1 root root   39 Jan 26 00:27 nixos -> ../home/nikita/dotfiles/nixos/etc/nixos
```
