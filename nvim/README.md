# Neovim Configuration for Python, Java, and Node.js Development

A language-focused Neovim setup built on `lazy.nvim` with LSP, formatting, linting, testing, and debugging.

## Quick Start

1. Start Neovim:
```bash
nvim
```

2. Let Lazy install plugins.

3. Let Mason install tools automatically on startup (`mason-tool-installer`).

4. Verify health:
```vim
:checkhealth
```

## Language Support

### Python
- LSP: `pyright`
- Format: `black`, `isort`
- Lint: `pylint`, `mypy`
- Test: `neotest-python` (`pytest`)
- Debug: `nvim-dap-python` (`debugpy`)
- Venv selection: `venv-selector`

### JavaScript / TypeScript / Node.js
- LSP: `ts_ls`, `eslint`
- Format: `prettier`
- Lint: `eslint_d` (fallback to `eslint`)
- Test: `neotest-jest`
- Debug: `pwa-node` via `vscode-js-debug`

### Java
- LSP: `nvim-jdtls`
- Format: `google-java-format` (Conform)
- Lint: JDTLS diagnostics (+ optional `checkstyle` if available)
- Test: `neotest-java` and JDTLS test commands
- Debug: JDTLS + Java debug/test bundles

## Key Bindings

Leader key: `Space`

### Navigation
- `<leader>e`: toggle file explorer
- `<leader>ff`: find files
- `<leader>fg`: live grep
- `<leader>fb`: open buffers
- `<leader>ft`: project tags
- `<leader>fT`: buffer tags

### LSP (buffer-local, active only when LSP is attached)
- `gd`: definition
- `gD`: declaration
- `gi`: implementation
- `gr`: references
- `K`: hover docs
- `<leader>rn`: rename
- `<leader>ca`: code action
- `<leader>sd`: line diagnostics
- `[d` / `]d`: prev/next diagnostic

### Formatting and Linting
- `<leader>mp`: format file/range
- `<leader>l`: lint current file

### Testing
- `<leader>tt`: run nearest test
- `<leader>tf`: run current file tests
- `<leader>td`: debug nearest test
- `<leader>ts`: test summary
- `<leader>to`: test output
- `<leader>tj`: neotest-java setup

### Debugging
- `<leader>db`: toggle breakpoint
- `<leader>dc`: continue
- `<leader>di`: step into
- `<leader>do`: step over
- `<leader>dO`: step out
- `<leader>dr`: debug REPL
- `<leader>dl`: run last
- `<leader>du`: toggle debug UI
- `<leader>dt`: terminate

### Java-specific (`ftplugin/java.lua`)
- `<leader>ji`: organize imports
- `<leader>jv`: extract variable
- `<leader>jc`: extract constant
- `<leader>jm`: test nearest method
- `<leader>jM`: test class

### Diagnostics and Symbols
- `<leader>xx`: Trouble diagnostics
- `<leader>xX`: Trouble buffer diagnostics
- `<leader>xq`: Trouble quickfix list
- `<leader>xl`: Trouble location list
- `gR`: Trouble LSP references
- `<leader>so`: toggle Aerial symbol outline
- `[s` / `]s`: previous/next symbol

### Terminal
- `<C-\\>`: toggle floating terminal
- `<leader>tF`: toggle floating terminal
- `<leader>th`: toggle horizontal terminal
- `<C-x>`: exit terminal mode

## Notes

- Conform is the single save-time formatter pipeline.
- LSP keymaps are scoped to attached buffers to avoid no-client errors.
- Python tooling prefers active venv, then project `.venv`, then system executables.
