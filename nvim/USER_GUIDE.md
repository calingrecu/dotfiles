# Beginner Manual: Using Your Neovim Plugins Effectively

This manual is built from the exact configuration in this repository.

It is designed for two cases:

1. You know basic Vim movement but not modern Neovim plugins.
2. You want practical, repeatable workflows for Python, Java, and Node.js.

## 1. First Principles

### 1.1 What this setup gives you

- Project navigation (`neo-tree`, `telescope`)
- Language intelligence (`LSP` for Python, JS/TS, Java, Lua)
- Completion and snippets (`nvim-cmp`, `LuaSnip`)
- Formatting and linting (`conform.nvim`, `nvim-lint`)
- Testing (`neotest` + adapters)
- Debugging (`nvim-dap`, `nvim-dap-ui`)
- Diagnostics and symbol panes (`trouble.nvim`, `aerial.nvim`)

### 1.2 Key notation used in this guide

- `<leader>` means your leader key. In this config, leader is `Space`.
- `<C-x>` means `Ctrl + x`.
- `Normal mode` means press `Esc` first.
- `Visual mode` means select text with `v`, `V`, or `<C-v>`.

Examples:

- `<leader>ff` means: press `Space`, then `f`, then `f`.
- `gD` means: press `g`, then `D` (uppercase `D`).

### 1.3 The most important idea

Prefer this order when working:

1. LSP navigation/refactors (`gd`, `gr`, `<leader>rn`)
2. Search (`<leader>fg`, `<leader>ff`)
3. Diagnostics (`[d`, `]d`, `<leader>xx`)
4. Tests (`<leader>tt`) and debug (`<leader>dc`) only when needed

This minimizes context switching and keeps your loop fast.

### 1.4 Practice Exercises

1. Open Neovim and press `<leader>ff`, then cancel the picker with `<Esc>`.
2. Press `<leader>fg`, type any word, and verify search results appear.
3. Say out loud what `gD` means (declaration) before moving to Chapter 4.

## 2. First Session Setup (Beginner Friendly)

### 2.1 First boot in a fresh machine

1. Open Neovim: `nvim`
2. Let plugins install through Lazy.
3. Let Mason tools install (auto via `mason-tool-installer`).
4. Run `:checkhealth`.

### 2.2 Verify language services are alive

- `:LspInfo` shows active LSP clients for current buffer.
- `:Mason` shows installed tools and language servers.
- `:messages` shows recent errors if something failed silently.

### 2.3 Python-only first step

- Use `<leader>vs` to pick your virtual environment.

This matters because LSP, linting, and debugging prefer your active venv.

### 2.4 Practice Exercises

1. Run `:Mason` and confirm tools are installed (or installing).
2. Open a Python/JS/Java file and run `:LspInfo`; confirm at least one client is attached.
3. Run `:messages` and verify there are no startup errors you need to handle.

## 3. Core Navigation and Editing

### 3.1 File and project navigation

- `<leader>e`: open/close project tree (Neo-tree)
- `<leader>ff`: fuzzy find files
- `<leader>fg`: grep text across project
- `<leader>fb`: switch open buffers
- `<leader>fh`: search Neovim help
- `<leader>ft`: search tags in project
- `<leader>fT`: search tags in current file

When to use what:

- Use `<leader>ff` when you know file name fragments.
- Use `<leader>fg` when you know text/symbol usage but not file location.

### 3.2 Window and buffer movement

- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: move focus between splits
- `<C-Up>`, `<C-Down>`, `<C-Left>`, `<C-Right>`: resize split
- `<Tab>` / `<S-Tab>`: next/previous buffer

### 3.3 Quick edit helpers

- `<leader>h`: clear search highlight
- Visual `<` / `>`: reindent selection and keep selection active
- Visual `J` / `K`: move selected lines down/up
- Visual `p`: paste without overwriting unnamed register

### 3.4 Commenting and surrounding text

From default plugin behavior:

- `gcc`: comment/uncomment current line
- Visual select + `gc`: comment/uncomment block
- `ysiw"`: surround inner word with quotes
- `cs"'`: change surrounding `"` to `'`
- `ds"`: delete surrounding quotes

### 3.5 Practice Exercises

1. Open any project and locate a file only with `<leader>ff`.
2. Create a split (`:vsplit`) and move focus with `<C-h>` and `<C-l>`.
3. Select 3 lines in visual mode and use `J`/`K` to move them.
4. Comment and uncomment one line with `gcc`.

## 4. LSP Commands Explained (Most Important Chapter)

These mappings exist only when LSP is attached to the current buffer.

### 4.1 `gd` vs `gD` (common confusion)

- `gd` = go to **definition**
  - Usually jumps to where function/class is implemented.
- `gD` = go to **declaration**
  - Usually jumps to where symbol is declared (interface/type/extern).

In dynamic languages, both can feel similar. In typed systems, `gD` can land in a different location than `gd`.

### 4.2 Other core LSP actions

- `gi` = go to implementation
  - Useful when cursor is on interface/protocol/abstract symbol.
- `gr` = list references
  - Shows every location that uses this symbol.
- `K` = hover documentation
  - Shows type info, signature, docs.
- `<leader>rn` = rename symbol safely project-wide
  - Better than text replace because it is semantic.
- `<leader>ca` = code action
  - Quick fixes, import actions, refactors (depends on language server).

### 4.3 Diagnostics keys

- `<leader>sd` = show diagnostics for current line/cursor
- `[d` = previous diagnostic
- `]d` = next diagnostic

Recommended beginner loop:

1. Jump to next issue with `]d`
2. Inspect details with `<leader>sd`
3. Apply quick fix with `<leader>ca`

### 4.4 Practice Exercises

1. Place cursor on a known function call and press `gd`.
2. Return with `<C-o>`, then try `gD` on the same symbol and compare location.
3. Use `gr`, jump to one reference, then return to the list.
4. Trigger `<leader>rn` on a local symbol and preview the rename impact.

## 5. Search, Tags, References, and Symbol Trees

### 5.1 Telescope usage in practice

- Open file finder: `<leader>ff`
- Open text grep: `<leader>fg`
- In Telescope insert mode:
  - `<C-j>` / `<C-k>` move selection
  - `<C-q>` send selected items to quickfix and open quickfix list

Use `<C-q>` when doing multi-file edits. It creates a task list you can process with `:cnext` / `:cprev`.

### 5.2 Trouble for diagnostics and references

- `<leader>xx`: all diagnostics
- `<leader>xX`: diagnostics in current buffer only
- `<leader>xq`: quickfix list in Trouble UI
- `<leader>xl`: location list in Trouble UI
- `gR`: references in Trouble UI

Why Trouble matters:

- It turns scattered errors/references into a focused list you can iterate.

### 5.3 Aerial for code structure

- `<leader>so`: toggle symbol outline
- `[s` / `]s`: previous/next symbol

Use it when you need to quickly traverse methods/classes in large files.

### 5.4 ctags fallback (works even when LSP is limited)

- `:CtagsRegen` regenerates project tags
- `<leader>ft` and `<leader>fT` search tags
- `<C-]>` jump to tag under cursor
- `<C-t>` jump back

Good fallback for generated code or edge cases where LSP is incomplete.

### 5.5 Practice Exercises

1. Search a keyword with `<leader>fg`, then press `<C-q>` in Telescope to send results to quickfix.
2. Open diagnostics with `<leader>xx`, then jump to one entry from Trouble.
3. Toggle Aerial with `<leader>so` and move between symbols using `[s` and `]s`.
4. Run `:CtagsRegen`, then use `<leader>ft` and `<C-]>` on one symbol.

## 6. Completion and Snippets

In insert mode (`nvim-cmp`):

- `<C-Space>`: trigger completion menu
- `<C-j>` / `<C-k>`: next/previous completion item
- `<CR>`: confirm selected completion
- `<C-e>`: abort completion
- `<C-b>` / `<C-f>`: scroll completion docs

Beginner strategy:

- Type first, call completion only when needed.
- Use `<CR>` only when you are sure selection is correct.

### 6.1 Practice Exercises

1. In insert mode, type part of a symbol and press `<C-Space>` to open completion.
2. Move selection with `<C-j>`/`<C-k>` and confirm with `<CR>`.
3. Re-open completion and cancel it with `<C-e>`.

## 7. Formatting and Linting

### 7.1 Formatting

- Save triggers formatting via `conform.nvim`.
- `<leader>mp` formats manually (normal mode) or selected range (visual mode).

Per-language formatter:

- Python: `black`, `isort`
- JS/TS: `prettier`
- Java: `google-java-format`
- Lua: `stylua`

### 7.2 Linting

- `<leader>l` runs linter(s) for current file.
- Also runs automatically on `BufEnter`, `BufWritePost`, and `InsertLeave`.

Per-language lint setup:

- Python: `pylint` + `mypy`
- JS/TS: `eslint_d` with fallback to `eslint`
- Java: optional `checkstyle` (if executable exists)

### 7.3 Practice Exercises

1. Add trailing spaces to a line and save; confirm whitespace is cleaned (except ignored filetypes).
2. Run `<leader>mp` in normal mode to format the file.
3. Introduce a small lint issue, then run `<leader>l` and inspect diagnostics.

## 8. Debugging Manual

### 8.1 Universal debug keys (all supported languages)

- `<leader>db`: toggle breakpoint
- `<leader>dc`: start/continue
- `<leader>di`: step into
- `<leader>do`: step over
- `<leader>dO`: step out
- `<leader>dr`: open debug REPL
- `<leader>du`: toggle debug UI
- `<leader>dl`: run last debug config
- `<leader>dt`: terminate debug session

### 8.2 Python debugging

- Uses `nvim-dap-python` and resolves interpreter from:
  1. active `VIRTUAL_ENV`
  2. project `.venv`
  3. system Python

Practical flow:

1. Open test/function file
2. Put breakpoint with `<leader>db`
3. Start with `<leader>dc`
4. Inspect state via `<leader>du` and `<leader>dr`

### 8.3 Node.js debugging

- Uses `pwa-node` via `vscode-js-debug`
- Supports launching current file and attaching to a process

If breakpoints do not bind:

- check source maps and cwd (`${workspaceFolder}` expected)

### 8.4 Java debugging

- Driven through `nvim-jdtls` integration in `ftplugin/java.lua`
- Uses Mason bundles: `java-debug-adapter`, `java-test`

Open a Java project root (`pom.xml` or `build.gradle`) before debugging.

### 8.5 Practice Exercises

1. Set one breakpoint with `<leader>db`, start with `<leader>dc`, then step with `<leader>do`.
2. Open debug UI with `<leader>du` and inspect current frame/variables.
3. End the session with `<leader>dt`.

## 9. Testing Manual

### 9.1 Common keys (`neotest`)

- `<leader>tt`: run nearest test
- `<leader>tf`: run tests in current file
- `<leader>td`: debug nearest test
- `<leader>ts`: toggle summary panel
- `<leader>to`: open detailed output

### 9.2 Python tests

- Adapter: `neotest-python`
- Runner: `pytest`

### 9.3 Node tests

- Adapter: `neotest-jest`
- Command: `npm test --`
- Expects `jest.config.js`

### 9.4 Java tests

- Adapter: `neotest-java`
- `<leader>tj`: run Java neotest setup command
- Java-specific alternatives:
  - `<leader>jm`: test nearest method (JDTLS)
  - `<leader>jM`: test current class (JDTLS)

### 9.5 Practice Exercises

1. Place cursor in a test and run `<leader>tt`.
2. Run all tests in current file with `<leader>tf`.
3. Open summary with `<leader>ts` and failed output with `<leader>to`.
4. Debug one test with `<leader>td`.

## 10. Language Playbooks

### 10.1 Python daily loop

1. `<leader>vs` select venv
2. Write code with completion (`<C-Space>`, `<C-j>`, `<CR>`)
3. Navigate with `gd`, `gr`
4. Rename with `<leader>rn`
5. Save + `<leader>l`
6. `<leader>tt` for nearest test
7. `<leader>td` if test fails and needs debug

### 10.2 Node.js daily loop

1. Open project root
2. Use `<leader>fg` for quick impact analysis
3. Refactor via `gd`/`gr`/`<leader>rn`
4. Save or `<leader>mp`
5. `<leader>l` for lint check
6. `<leader>tt` or `<leader>tf`
7. `<leader>dc` for runtime issue debugging

### 10.3 Java daily loop

1. Open folder with `pom.xml`/`build.gradle`
2. Wait for JDTLS attach (`:LspInfo` if unsure)
3. Use `gd`, `gr`, `K`
4. Organize imports with `<leader>ji`
5. Refactor with `<leader>jv` / `<leader>jc`
6. Save or `<leader>mp` for format
7. Run tests via `<leader>jm` / `<leader>jM` or neotest keys

### 10.4 Practice Exercises

1. Pick one language project and execute the full 7-step loop once, without skipping steps.
2. Time the loop and write down where you lost the most time.
3. Repeat the loop and try to reduce that bottleneck by using one shortcut from earlier chapters.

## 11. Terminal and Git Workflows

### 11.1 Terminal

- `<C-\\>`: floating terminal
- `<leader>tF`: floating terminal
- `<leader>th`: horizontal terminal
- `<C-x>`: leave terminal mode to normal mode

### 11.2 Git (hunk-level control)

- `]c` / `[c`: next/previous hunk
- `<leader>hp`: preview hunk
- `<leader>hs`: stage hunk
- `<leader>hr`: reset hunk
- `<leader>hb`: line blame

Great for staging only intentional refactor changes.

### 11.3 Practice Exercises

1. Open a floating terminal with `<leader>tF`, run one command, then exit terminal mode with `<C-x>`.
2. Modify a file, navigate hunks with `]c`/`[c`, and preview with `<leader>hp`.
3. Stage one hunk with `<leader>hs` and leave another unstaged.

## 12. Troubleshooting and Recovery

### 12.1 "LSP keys don’t work"

- LSP mappings are buffer-local now.
- Check `:LspInfo` in that file.
- Ensure language server is installed in `:Mason`.

### 12.2 "Formatting not happening"

- Run `<leader>mp` manually.
- Check formatter binary exists (example: `black`, `prettier`, `google-java-format`).

### 12.3 "Debugging does not start"

- Verify adapters are installed in `:Mason`.
- For Java, confirm you opened project root and JDTLS attached.

### 12.4 "Tests don’t run"

- Open `<leader>to` output pane to see exact error.
- Ensure correct runner config exists (`pytest`, `jest.config.js`, Java project setup).

### 12.5 "I don’t remember a key"

- `<leader>p` opens Legendary command palette.
- `:map <key>` or `:verbose map <key>` can show what is currently mapped.

### 12.6 Practice Exercises

1. In a file where LSP is not attached, run `:LspInfo` and identify the missing server/tool.
2. Run `:verbose map gd` and confirm how that key is mapped in the current buffer.
3. Force a failing test, open `<leader>to`, and identify the root cause from output only.

## 13. High-Value Beginner Habits

1. Learn `gd`, `gr`, `<leader>rn` first. These pay off immediately.
2. Use `<leader>fg` + `<C-q>` for large refactors across many files.
3. Keep `Trouble` open while fixing diagnostics in big changes.
4. Use tests before debugging. Debug only when test output is insufficient.
5. Use hunk staging (`<leader>hs`) before commits to avoid noisy diffs.

### 13.1 Practice Exercises

1. For your next PR, enforce all five habits and note which one saved the most time.
2. At the end of that session, write 3 keymaps you used most and 1 keymap you should use more.
