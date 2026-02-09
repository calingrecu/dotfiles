-- lua/plugins/colorscheme.lua
--return {
--  {
--    "folke/tokyonight.nvim",
--    lazy = false,
--    priority = 1000,
--    config = function()
--      require("tokyonight").setup({
--        style = "night",
--        transparent = false,
--        terminal_colors = true,
--        styles = {
--          comments = { italic = true },
--          keywords = { italic = true },
--        },
--      })
--      vim.cmd([[colorscheme tokyonight]])
--    end,
--  },
--}

return {
    {
        -- version of solarized color scheme; works better with true color terminals
        "lifepillar/vim-solarized8",
        branch = "neovim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            if os.getenv("THEME") == "light" then
                vim.cmd("set background=light")
                vim.cmd("colorscheme solarized8_flat")
            else
                vim.cmd("set background=dark")
                vim.cmd("colorscheme solarized8_flat")
                vim.cmd("highlight! Search guifg=#694f00")

                vim.cmd("highlight! Keyword ctermfg=106 guifg=#859900")

                vim.cmd("highlight clear @punctuation")
                vim.cmd("highlight! @punctuation ctermfg=106 guifg=#859900")

                vim.cmd("highlight clear @operator")
                vim.cmd("highlight! @operator ctermfg=White guifg=White")
                vim.cmd("highlight clear @keyword.operator")
                vim.cmd("highlight! @keyword.operator ctermfg=White guifg=White")
                vim.cmd("highlight clear @lsp.type.operator")
                vim.cmd("highlight! @lsp.type.operator ctermfg=White guifg=White")
            end

            -- Aim is to have solarized colorscheme, where identifiers are normal colour, keywords
            -- (green), types (yellow), methods (blue), builtin (red) elements are easily identifiable,
            -- operators (white) pop out to be easily seen.

            vim.cmd("highlight! LineNr cterm=NONE gui=NONE")

            -- tweak colors
            vim.cmd("highlight clear @variable")
            vim.cmd("highlight! link @variable Normal")
            vim.cmd("highlight clear @lsp.type.property")
            vim.cmd("highlight link @lsp.type.property Normal")

            -- spelling mistakes should be just underlined
            vim.cmd("highlight clear SpellBad")
            vim.cmd("highlight clear SpellCap")
            vim.cmd("highlight clear SpellRare")
            vim.cmd("highlight clear SpellLocal")
            vim.cmd("highlight! SpellBad cterm=underline gui=undercurl")
            vim.cmd("highlight! link SpellCap SpellBad")
            vim.cmd("highlight! link SpellRare SpellBad")
            vim.cmd("highlight! link SpellLocal SpellBad")
        end,
    },
}
