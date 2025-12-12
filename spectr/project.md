# nvim Context

## Purpose
Personal daily driver neovim configuration for polyglot development. Optimized for working across 30+ programming languages including Go, Rust, Python, TypeScript, Nix, C/C++, Zig, and many others.

## Tech Stack
- **Neovim** - Editor (Lua-based configuration)
- **lazy.nvim** - Plugin management with lazy loading
- **nvim-lspconfig** - LSP client configuration for language servers
- **blink.cmp** - Completion engine
- **Tree-sitter** - Syntax highlighting and code analysis
- **Telescope** - Fuzzy finding and navigation
- **neotest** - Testing framework integration
- **Git integrations**: fugitive, gitsigns, signify, octo (GitHub)
- **oil.nvim** - File navigation
- **fidget.nvim** - LSP progress notifications

## Project Conventions

### Code Style
- **Formatter**: StyLua
- **Indentation**: Tabs (width: 2)
- **Column width**: 160 characters
- **Line endings**: Unix (LF)
- **Quote style**: Double quotes preferred
- **Leader key**: `\` (backslash)
- **Local leader**: `<Space>`

### Architecture Patterns
- **Plugin files**: Named as `<name>-plugin.lua` in `lua/plugins/`
- **Keymaps**: Organized by mode in `lua/keymaps/` (normal, visual, insert)
- **Core config**: `lua/conneroisu/` for options, debugger, keymaps, multigrep
- **Filetype overrides**: `after/ftplugin/` for language-specific settings
- **Lazy loading**: Plugins load on events (BufReadPost, BufNewFile) or filetypes

### Testing Strategy
- Manual testing in neovim after changes
- `:checkhealth` for plugin/LSP diagnostics
- CI validation on push

### Git Workflow
- **Trunk-based development**: Short-lived branches, frequent integration to main
- Commit messages should be descriptive
- Changes validated before merge

## Domain Context
- This config is part of a larger NixOS dotfiles repository using the Denix framework
- LSP servers are typically installed via Nix, not Mason
- Format-on-save is enabled for most filetypes (Go uses vim-go instead)
- Custom filetypes registered: `templ`, `rasi`, `hyprlang`

## Important Constraints
- **Performance focus**: Startup time and responsiveness are priorities
- **NixOS integration**: Managed via Home Manager; external tools come from Nix
- **Lazy loading**: Plugins should load lazily to minimize startup time
- **No Mason**: LSP servers managed by Nix, not neovim plugin managers

## External Dependencies
- **Nix/NixOS**: Provides LSP servers, formatters, and external tools
- **Language servers**: gopls, rust-analyzer, lua_ls, nixd, pyrefly, ts_ls, etc.
- **Git**: Required for fugitive, gitsigns, octo integrations
- **ripgrep**: Used by Telescope for grep operations
- **fd**: Used by Telescope for file finding
