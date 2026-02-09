-- lua/plugins/linting.lua - Code linting
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local python_root_markers = {
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      ".git",
    }

    local function first_executable(candidates)
      for _, candidate in ipairs(candidates) do
        if candidate and candidate ~= "" and vim.fn.executable(candidate) == 1 then
          return candidate
        end
      end
      return nil
    end

    local function root_for(bufnr, markers)
      local file = vim.api.nvim_buf_get_name(bufnr)
      local root = vim.fs.find(markers, { path = file, upward = true })[1]
      return root and vim.fs.dirname(root) or vim.fn.getcwd()
    end

    local function python_tool_cmd(tool, bufnr)
      local root_dir = root_for(bufnr, python_root_markers)
      local active_venv = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/" .. tool) or nil
      local project_venv = root_dir .. "/.venv/bin/" .. tool
      return first_executable({ active_venv, project_venv, tool })
    end

    local function configure_python_linters(bufnr)
      local pylint_cmd = python_tool_cmd("pylint", bufnr)
      local mypy_cmd = python_tool_cmd("mypy", bufnr)

      if pylint_cmd then
        lint.linters.pylint = vim.tbl_deep_extend("force", lint.linters.pylint or {}, { cmd = pylint_cmd })
      end
      if mypy_cmd then
        lint.linters.mypy = vim.tbl_deep_extend("force", lint.linters.mypy or {}, { cmd = mypy_cmd })
      end

      local python_linters = {}
      if pylint_cmd then
        table.insert(python_linters, "pylint")
      end
      if mypy_cmd then
        table.insert(python_linters, "mypy")
      end
      lint.linters_by_ft.python = python_linters
    end

    local function configure_java_linters()
      if vim.fn.executable("checkstyle") == 1 then
        lint.linters_by_ft.java = { "checkstyle" }
      else
        lint.linters_by_ft.java = {}
      end
    end

    local js_linter = first_executable({ "eslint_d", "eslint" })

    lint.linters_by_ft = {
      python = {},
      javascript = js_linter and { js_linter } or {},
      javascriptreact = js_linter and { js_linter } or {},
      typescript = js_linter and { js_linter } or {},
      typescriptreact = js_linter and { js_linter } or {},
      java = {},
    }

    configure_java_linters()

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function(args)
        if vim.bo[args.buf].filetype == "python" then
          configure_python_linters(args.buf)
        end
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      if vim.bo.filetype == "python" then
        configure_python_linters(0)
      end
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
