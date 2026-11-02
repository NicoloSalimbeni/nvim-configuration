# Neovim configuration

Configuration for C++, Python, LaTeX, Markdown and web development, using
lazy.nvim and Catppuccin Macchiato. Validated with Neovim v0.12.6.
The LSP configuration requires Neovim 0.11 or newer.

## Installation

On Ubuntu 24.04 or newer, clone the repository and run the installer as your
regular user:

```bash
git clone https://github.com/NicoloSalimbeni/nvim-configuration ~/.config/nvim
cd ~/.config/nvim
./configure.sh --dry-run
./configure.sh
```

The script uses `sudo` for APT packages and installs other tools under
`~/.local/bin` and `~/.local/opt`. It installs development tools, clipboard
providers, PDF/browser dependencies, Yazi, lazygit, a Nerd Font, the configured
Mason packages (including debugpy), and Tree-sitter parsers. Plugins are
installed/restored from `lazy-lock.json`. Markdown preview uses Node.js on both
x86-64 and ARM64. APT's Universe repository must be enabled (the Ubuntu default).

It reuses Neovim >= 0.11 and Node.js >= 22 when available; otherwise it downloads
an official Neovim release and Node 24 LTS. Other missing user tools come from
official GitHub releases. Downloads require internet access. Existing tools are
reused on subsequent runs; this is an installer, not a general updater.

Options:

```bash
# Skip the large TeX Live installation when LaTeX is not needed:
./configure.sh --skip-tex
# Reuse your existing AppImage explicitly:
./configure.sh --nvim "$HOME/Executables/nvim-linux-x86_64.appimage"
# Keep your current fonts:
./configure.sh --skip-font
```

`--skip-tex` skips latexmk and TeX Live, while Zathura remains available for PDFs.
The default TeX selection includes common LaTeX, science, bibliography and font
packages; unusual documents may need additional TeX packages. The script does
not change the terminal font: select **JetBrainsMono Nerd Font** yourself.
Firefox is installed using Ubuntu's Snap-backed APT package, so a normal Ubuntu
desktop with Snap support is expected for browser previews.

Open a new terminal after installation, or run `source ~/.bashrc`. The script
adds `~/.local/bin` to Bash's PATH and preserves existing aliases. An existing
`nvim` alias still takes precedence; update/remove it yourself if it points to
an old installation. Run the installer again to retry a failed download or
installation. It never replaces an existing configuration directory, and must
be run from the clone at `${XDG_CONFIG_HOME:-$HOME/.config}/nvim`.

Use `:Lazy` to inspect plugins and `:Mason` to inspect language servers and tools.
`lazy-lock.json` records plugin versions; use `:Lazy restore` to restore them.

## Dependencies

- Git, a C compiler and download/extraction tools for plugin/parser installation.
- Python 3 with venv support and Node.js/npm for Mason-managed tools.
- A true-color terminal and a Nerd Font for icons.
- A clipboard provider: this setup uses `unnamedplus`; X11 has `xclip` installed.
- `rg` (ripgrep) for Telescope project search; it must be on Neovim's PATH.
- Optional external programs: `latexmk` and a TeX distribution for compilation,
  `zathura` for PDF viewing, `firefox` for Markdown preview, `yazi` for the file
  manager and `lazygit` for the Git terminal.
- GDB with DAP support for C++ debugging. Python debugging uses Mason's
  `debugpy`; install it with `:MasonInstall debugpy` on a fresh machine.
- `cppcheck` for additional C/C++ diagnostics. It is not in the installed Mason
  registry; its source is enabled only when the executable is on PATH.

Mason automatically installs configured language servers and formatters,
including StyLua, clang-format, Black, shfmt, Prettier and the CMake tools.
PHP formats through Intelephense. Other supported files format through none-ls
on save; `<Space>gf` runs none-ls formatting manually.

The frozen Tree-sitter `master` branch uses legacy single-node query handlers.
`lua/treesitter-compat.lua` adapts its handlers to Neovim 0.12 capture lists,
including Bash heredoc injections. Neovim 0.11 keeps the original handlers.

Tree-sitter installs an explicit parser list asynchronously. Run `:TSUpdate`
after changing plugin versions. LaTeX parsing is excluded because VimTeX
provides its highlighting.

## Useful mappings

The leader key is Space. `:WhichKey` shows the available mappings.

| Mapping | Action |
| --- | --- |
| `<Space>fo` | Find files |
| `<Space>fs` | Search project text |
| `<Space>ff` | Search current buffer |
| `<Space>fl` | List functions/methods in C++ and Python |
| `<Space>e` | Toggle Neo-tree |
| `<Space>cw` | Open Yazi at the working directory |
| `<Space>j` | Toggle Bash terminal |
| `<Space>nt` | Open a new floating terminal |
| `<Space>lg` | Toggle lazygit |
| `<Space>mp` | Toggle Markdown preview (Markdown buffers) |
| `<Space>lc` | Compile LaTeX (TeX buffers) |
| `<Space>dc` | Start/continue debugger |
| `gd` / `K` | LSP definition / hover |
| `<Space>ca` | LSP code action |

Completion supports LSP, snippets, buffer words and paths. Command-line
completion is enabled for `:`, `/` and `?`.

## Audit notes (November 2026)

Fixed completion dependency declarations, duplicate theme configuration,
filetype mappings leaking globally, Neo-tree invoking commands for multiple
operating systems, deprecated LSP hover setup, repeated Markdown preview
installation and late VimTeX settings. Formatter dependencies and installation
are now explicit. Snippet files no longer clear an unrelated shared autocommand
group; Doxygen attention/warning triggers are distinct.

The installed colorizer plugin still uses deprecated `vim.tbl_flatten` internally.
Telescope is pinned to 0.1.5 and also contains older APIs. These are plugin
maintenance concerns; plugin versions were preserved during this audit.

Some overlap is intentional: Neo-tree and Yazi are different file managers,
while Floaterm and ToggleTerm provide different terminal mappings. Both are
retained so existing shortcuts continue working. Comment.nvim overlaps with
Neovim's built-in commenting, but is retained to preserve its mappings.

The installer supplies `latexmk`, `zathura`, `yazi` and `cppcheck` (unless TeX
installation is skipped).
Run `:checkhealth` to inspect environment-specific dependencies.
