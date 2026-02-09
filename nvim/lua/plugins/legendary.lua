return {
    "mrjones2014/legendary.nvim",
    dependencies = {
        "kkharji/sqlite.lua",        -- REQUIRED
        "nvim-telescope/telescope.nvim", -- OPTIONAL but strongly recommended
    },
    config = function()
        require("legendary").setup({
            extensions = {
                lazy_nvim = true,
            },
        })
    end,
}
