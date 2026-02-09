-- lua/config/autocmds.lua - Autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  group = augroup("strip_whitespace", { clear = true }),
  pattern = "*",
  callback = function(args)
    local ignored_filetypes = {
      markdown = true,
      text = true,
      gitcommit = true,
    }

    if ignored_filetypes[vim.bo[args.buf].filetype] then
      return
    end

    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Python specific settings
autocmd("FileType", {
  group = augroup("python_settings", { clear = true }),
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- JavaScript/TypeScript specific settings
autocmd("FileType", {
  group = augroup("js_settings", { clear = true }),
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
