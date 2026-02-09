-- lua/plugins/workflow.lua - workflow/navigation helpers
return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble: diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble: buffer diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble: quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble: location list" },
      { "gR", "<cmd>Trouble lsp_references toggle<CR>", desc = "Trouble: references" },
    },
  },
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      show_guides = true,
      attach_mode = "global",
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = {
        min_width = 28,
        default_direction = "prefer_right",
      },
    },
    keys = {
      { "<leader>so", "<cmd>AerialToggle!<CR>", desc = "Aerial: toggle outline" },
      { "[s", "<cmd>AerialPrev<CR>", desc = "Aerial: previous symbol" },
      { "]s", "<cmd>AerialNext<CR>", desc = "Aerial: next symbol" },
    },
  },
}
