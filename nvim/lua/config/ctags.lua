-- lua/config/ctags.lua - ctags command integration
vim.api.nvim_create_user_command("CtagsRegen", function()
  local cmd = table.concat({
    "ctags -R",
    "--exclude=.git",
    "--exclude=node_modules",
    "--exclude=dist",
    "--exclude=build",
    "--exclude=target",
    "--exclude=.venv",
    ".",
  }, " ")

  vim.notify("ctags: regenerating tags...", vim.log.levels.INFO)

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 1 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 1 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.WARN)
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("ctags: done", vim.log.levels.INFO)
      else
        vim.notify("ctags: failed (exit " .. code .. ")", vim.log.levels.ERROR)
      end
    end,
  })
end, {})
