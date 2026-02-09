-- lua/plugins/python-node.lua - Python and Node.js specific tools
return {
  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
      "jay-babu/mason-nvim-dap.nvim",
      "mxsdev/nvim-dap-vscode-js",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup()

      -- Virtual text
      require("nvim-dap-virtual-text").setup()

      -- Ensure core adapters are installed/configured via Mason
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "python",
        },
        automatic_installation = true,
      })

      local function first_executable(candidates)
        for _, candidate in ipairs(candidates) do
          if candidate and candidate ~= "" and vim.fn.executable(candidate) == 1 then
            return candidate
          end
        end
        return nil
      end

      local function root_for_current_file()
        local markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" }
        local file = vim.api.nvim_buf_get_name(0)
        local root = vim.fs.find(markers, { path = file, upward = true })[1]
        return root and vim.fs.dirname(root) or vim.fn.getcwd()
      end

      local function resolve_python()
        local root_dir = root_for_current_file()
        return first_executable({
          vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or nil,
          root_dir .. "/.venv/bin/python",
          vim.fn.exepath("python3"),
          vim.fn.exepath("python"),
          "python3",
          "python",
        }) or "python3"
      end

      -- Python debugging
      require("dap-python").setup(resolve_python())
      require("dap-python").resolve_python = resolve_python

      -- Node.js debugging (vscode-js-debug / pwa-node)
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
        adapters = {
          "pwa-node",
          "node-terminal",
          "pwa-chrome",
          "pwa-extensionHost",
        },
      })

      dap.configurations.javascript = {
        {
          name = "Launch file",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          console = "integratedTerminal",
        },
        {
          name = "Attach to process",
          type = "pwa-node",
          request = "attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      dap.configurations.typescript = dap.configurations.javascript
      dap.configurations.javascriptreact = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.javascript

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Keymaps
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
    end,
  },
  -- Testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
      "rcasia/neotest-java",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
          }),
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
          require("neotest-java")({}),
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>tt", function()
        require("neotest").run.run()
      end, { desc = "Run nearest test" })

      vim.keymap.set("n", "<leader>tf", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { desc = "Run current file" })

      vim.keymap.set("n", "<leader>td", function()
        require("neotest").run.run({ strategy = "dap" })
      end, { desc = "Debug nearest test" })

      vim.keymap.set("n", "<leader>ts", function()
        require("neotest").summary.toggle()
      end, { desc = "Toggle test summary" })

      vim.keymap.set("n", "<leader>to", function()
        require("neotest").output.open({ enter = true })
      end, { desc = "Show test output" })

      vim.keymap.set("n", "<leader>tj", "<cmd>NeotestJava setup<CR>", { desc = "Set up neotest-java runner" })
    end,
  },
  -- Python virtual environment
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      name = { "venv", ".venv", "env", ".env" },
    },
    event = "VeryLazy",
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
    },
  },
}
