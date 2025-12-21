# Neovim Config

Minimal Neovim config targeting Neovim 0.11+.

Portability and built-in functionality are the primary constraints — avoid plugins when a built-in equivalent exists.

## Mode system

**Lite mode is the default.**

Full mode is enabled by the presence of `local.lua` in the config directory (gitignored). A fresh clone on a server stays in lite mode automatically.

- Lite mode: built-in options and keymaps only
- Full mode: packages, LSP, custom colorscheme
- `local.lua` is sourced at the end of `init.lua` and can hold machine-specific overrides

## Plugin philosophy

Keep the plugin list as short as possible.

The three currently active plugins were each kept because no adequate built-in alternative exists:

- `modus-themes.nvim` — preferred colorscheme
- `vim-sleuth` — per-project indentation detection
- `nvim-autopairs` — autopairs (no correct built-in equivalent)

**`nvim-lspconfig` is intentionally absent.** Neovim 0.11+ ships built-in LSP server configs; `vim.lsp.enable()` uses them directly.

## Style

- ASCII section banners for major sections
- Minimal inline comments — only for non-obvious constraints
- No multi-line docstrings or explanation comments
- All config lives in `init.lua`; no split into multiple files (portability)
