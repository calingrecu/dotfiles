-- nvim/ftplugin/java.lua - start jdtls per Java project
local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local function root_dir_for_java()
  local markers = {
    "gradlew",
    "mvnw",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
    ".git",
  }
  return vim.fs.root(0, markers) or vim.fn.getcwd()
end

local function os_config_dir(base)
  if vim.fn.has("mac") == 1 then
    return base .. "/config_mac"
  end
  if vim.fn.has("win32") == 1 then
    return base .. "/config_win"
  end
  return base .. "/config_linux"
end

local root_dir = root_dir_for_java()
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
local jdtls_install = mason_packages .. "/jdtls"
local launcher = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")

if launcher == "" then
  vim.notify("jdtls launcher not found. Install jdtls in :Mason", vim.log.levels.WARN)
  return
end

local bundles = {}
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(mason_packages .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n", {
    trimempty = true,
  })
)
vim.list_extend(
  bundles,
  vim.split(vim.fn.glob(mason_packages .. "/java-test/extension/server/*.jar"), "\n", { trimempty = true })
)

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=WARN",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher,
    "-configuration",
    os_config_dir(jdtls_install),
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  init_options = {
    bundles = bundles,
  },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
    },
  },
  on_attach = function(_, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    local ok_dap, jdtls_dap = pcall(require, "jdtls.dap")
    if ok_dap then
      jdtls_dap.setup_dap_main_class_configs()
    end

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = bufnr,
        silent = true,
        noremap = true,
        desc = desc,
      })
    end

    map("n", "<leader>ji", jdtls.organize_imports, "Java: organize imports")
    map("n", "<leader>jv", jdtls.extract_variable, "Java: extract variable")
    map("v", "<leader>jv", function()
      jdtls.extract_variable(true)
    end, "Java: extract variable")
    map("n", "<leader>jc", jdtls.extract_constant, "Java: extract constant")
    map("v", "<leader>jc", function()
      jdtls.extract_constant(true)
    end, "Java: extract constant")
    map("n", "<leader>jm", jdtls.test_nearest_method, "Java: test nearest method")
    map("n", "<leader>jM", jdtls.test_class, "Java: test class")
  end,
}

jdtls.start_or_attach(config)
