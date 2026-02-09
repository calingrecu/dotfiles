-- lua/config/options.lua - Editor options
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.updatetime = 250
opt.timeoutlen = 300

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Backup and undo
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- File encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Wrap
opt.wrap = false

-- ctags: allow searching for a project-local tags file upward
-- This does not affect LSP; it only enables tag-based navigation fallback.
do
  local existing = vim.opt.tags:get() or {}
  local desired = { "./tags;", "tags;" }

  local function contains(t, v)
    for _, x in ipairs(t) do
      if x == v then
        return true
      end
    end
    return false
  end

  for _, v in ipairs(desired) do
    if not contains(existing, v) then
      table.insert(existing, v)
    end
  end

  vim.opt.tags = existing
end

-- Python and Node specific
local python_host = vim.fn.exepath("python3")
if python_host ~= "" then
  vim.g.python3_host_prog = python_host
end

local node_host_local = vim.fn.stdpath("data") .. "/node_modules/.bin/neovim-node-host"
if vim.fn.executable(node_host_local) == 1 then
  vim.g.node_host_prog = node_host_local
else
  local node_host_global = vim.fn.exepath("neovim-node-host")
  if node_host_global ~= "" then
    vim.g.node_host_prog = node_host_global
  end
end

-- -- Show diagnostics in a floating window on cursor hold
-- vim.diagnostic.config({
--     float = {
--         source = "always", -- Show source of diagnostic
--         border = "rounded",
--     },
--     virtual_text = true, -- Show diagnostic text inline at end of line
--     signs = true,
--     underline = true,
--     update_in_insert = false,
-- })
--
-- -- Automatically show diagnostic on cursor hold
-- vim.api.nvim_create_autocmd("CursorHold", {
--     callback = function()
--         vim.diagnostic.open_float(nil, { focus = false })
--     end,
-- })
