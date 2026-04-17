# dotfiles

Personal dotfiles, tailored to my workflow and preferences, built around my specific setup.

---

## Prerequisites

- [git](https://git-scm.com/)
- [Stow](https://www.gnu.org/software/stow/)
- Linux or macOS

### Dependencies

Some packages depend on the following tools:

- [7-Zip](https://www.7-zip.org/): used by Yazi
- [atuin](https://atuin.sh/): required by zsh
- [bat](https://github.com/sharkdp/bat): required by zsh, used by Neovim
- [delta](https://github.com/dandavison/delta): required by zsh and git
- [eza](https://github.com/eza-community/eza): required by zsh, used by Neovim
- [fd](https://github.com/sharkdp/fd): required by zsh and theme switcher, used by Neovim and Yazi
- [fzf](https://github.com/junegunn/fzf): required by zsh and theme switcher, used by Neovim and Yazi
- [jq](https://github.com/jqlang/jq): used by Yazi
- [ripgrep](https://github.com/BurntSushi/ripgrep): required by zsh, used by Neovim and Yazi
- [zoxide](https://github.com/ajeetdsouza/zoxide): required by zsh, used by Neovim and Yazi

---

## Install

> [!WARNING]
> Make sure to read the [Theme Switcher](#theme-switcher) section. Themes are not stored in source control since they are dynamically generated from templates.
> Some apps will fail to start without a valid theme configuration file.

### Directory structure

Each package lives in its own directory at the repo root. Inside it, files are arranged to mirror the structure they'd have relative to `${HOME}`. For example:

```
dotfiles/
├── ghostty/
│   └── .config/
│       └── ghostty/
│           ├── config
│           └── themes/
│               └── theme
```

### Packages

- [atuin](https://github.com/atuinsh/atuin)
- [bat](https://github.com/sharkdp/bat)
- [btop++](https://github.com/aristocratos/btop)
- [cava](https://github.com/karlstav/cava)
- [eza](https://github.com/eza-community/eza)
- [ghostty](https://ghostty.org/)
- [git](https://git-scm.com/)
- [nvim](https://neovim.io/)
- themes (template files)
- [yazi](https://github.com/sxyazi/yazi)
- [zathura](https://pwmt.org/projects/zathura/)
- [zsh](https://www.zsh.org/)

### Clone the repository

Clone this repository into any directory of your choice:

```sh
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Stow

[GNU Stow](https://www.gnu.org/software/stow/) is used to manage symlinks. From the repo root, run:

```sh
stow <package>
```

This creates symlinks in `${HOME}` (set up in the `.stowrc` file) pointing to the files inside the given package folder.

To stow multiple packages at once:

```sh
stow zsh git ghostty
```

To remove symlinks for a package:

```sh
stow -D <package>
```

---

## Notes

### Theme switcher

A very basic and crude theme switcher that allows theme configuration and hot-reload of supported apps is provided. After stowing the `themes` package, it can be found in `${XDG_CONFIG_HOME}/themes/switch_theme.sh`.

You can either pass a valid theme as an argument or run it for an interactive theme selection with `fzf`. It will copy the theme configuration file for all the detected packages, and hot-reload the apps (when supported).

### Powerlevel10k configuration

After installing the [Powerlevel10k](https://github.com/romkatv/powerlevel10k) plugin, the wizard may automatically run. By default, it will generate a `.p10k.zsh` file in your home directory (`${HOME}`). There are two paths:

1. **Use the wizard-generated configuration:**
   - Complete the Powerlevel10k wizard setup.
   - Move or copy the `.p10k.zsh` file to `.config/p10k/` to ensure it's loaded by the `.zshrc` config file.

2. **Stow the existing config file:**
   - Skip the wizard.
   - Stow the appropriate `.p10k.zsh` file by running `stow p10k`.

Make sure your `.zshrc` is set up to load the correct configuration file based on your choice.

### Custom themes with zdharma-continuum fast-syntax-highlighting

Stow the `fsh` package and activate the theme with [fast-theme](https://github.com/zdharma-continuum/fast-syntax-highlighting/blob/master/fast-theme):

```sh
stow fsh
fast-theme XDG:<theme>
```

For example:

```sh
stow fsh
fast-theme XDG:catppuccin-mocha
```

---

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
