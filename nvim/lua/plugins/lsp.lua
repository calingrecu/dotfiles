-- lua/plugins/lsp.lua - LSP Configuration
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      local lsp_keymaps_group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_keymaps_group,
        callback = function(args)
          local bufnr = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = bufnr,
              silent = true,
              noremap = true,
              desc = desc,
            })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          map("n", "gr", vim.lsp.buf.references, "Show references")
          map("n", "K", vim.lsp.buf.hover, "Show hover documentation")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Run code action")
        end,
      })

      -- Python LSP (pyright)
      local function first_executable(candidates)
        for _, candidate in ipairs(candidates) do
          if candidate and candidate ~= "" and vim.fn.executable(candidate) == 1 then
            return candidate
          end
        end
        return nil
      end

      local function python_path_for_root(root_dir)
        local active_venv_python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. "/bin/python") or nil
        local project_venv_python = root_dir and (root_dir .. "/.venv/bin/python") or nil

        return first_executable({
          active_venv_python,
          project_venv_python,
          vim.fn.exepath("python3"),
          vim.fn.exepath("python"),
          "python3",
          "python",
        })
      end

      local function root_for(bufnr)
        local markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" }
        local file = vim.api.nvim_buf_get_name(bufnr)
        local root = vim.fs.find(markers, { path = file, upward = true })[1]
        return root and vim.fs.dirname(root) or nil
      end

      vim.lsp.config.pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          local root_dir = root_for(bufnr)
          local python_path = python_path_for_root(root_dir)
          if python_path then
            client.config.settings = client.config.settings or {}
            client.config.settings.python = client.config.settings.python or {}
            client.config.settings.python.pythonPath = python_path
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
        end,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      }
      vim.lsp.enable("pyright")

      -- JavaScript/TypeScript LSP (ts_ls)
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
            },
          },
        },
      }
      vim.lsp.enable("ts_ls")

      -- ESLint for JavaScript/TypeScript
      vim.lsp.config.eslint = {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { ".eslintrc", ".eslintrc.js", ".eslintrc.json", "package.json", ".git" },
        capabilities = capabilities,
      }
      vim.lsp.enable("eslint")

      -- Lua LSP for Neovim config
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      }
      vim.lsp.enable("lua_ls")
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "ts_ls",
          "eslint",
          "lua_ls",
        },
        automatic_installation = true,
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP servers
          "pyright",
          "typescript-language-server",
          "eslint-lsp",
          "lua-language-server",
          "jdtls",

          -- Formatters
          "black",
          "isort",
          "prettier",
          "google-java-format",

          -- Linters
          "pylint",
          "mypy",
          "eslint_d",

          -- Debug adapters / DAP tooling
          "debugpy",
          "js-debug-adapter",
          "java-debug-adapter",
          "java-test",
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 24,
      })
    end,
  },
}
