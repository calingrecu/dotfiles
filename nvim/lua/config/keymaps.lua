-- lua/config/keymaps.lua - Key mappings
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local function with_desc(desc)
  return vim.tbl_extend("force", opts, { desc = desc })
end

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", with_desc("Focus left window"))
keymap("n", "<C-j>", "<C-w>j", with_desc("Focus lower window"))
keymap("n", "<C-k>", "<C-w>k", with_desc("Focus upper window"))
keymap("n", "<C-l>", "<C-w>l", with_desc("Focus right window"))

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", with_desc("Increase window height"))
keymap("n", "<C-Down>", ":resize -2<CR>", with_desc("Decrease window height"))
keymap("n", "<C-Left>", ":vertical resize -2<CR>", with_desc("Decrease window width"))
keymap("n", "<C-Right>", ":vertical resize +2<CR>", with_desc("Increase window width"))

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", with_desc("Go to next buffer"))
keymap("n", "<S-h>", ":bprevious<CR>", with_desc("Go to previous buffer"))
keymap("n", "<Tab>", ":bnext<CR>", with_desc("Go to next buffer"))
keymap("n", "<S-Tab>", ":bprevious<CR>", with_desc("Go to previous buffer"))


-- Clear search highlighting
keymap("n", "<leader>h", ":nohlsearch<CR>", with_desc("Clear search highlights"))

-- Better indenting
keymap("v", "<", "<gv", with_desc("Indent left and keep selection"))
keymap("v", ">", ">gv", with_desc("Indent right and keep selection"))

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv", with_desc("Move selected lines down"))
keymap("v", "K", ":m '<-2<CR>gv=gv", with_desc("Move selected lines up"))

-- Stay in visual mode when pasting
keymap("v", "p", '"_dP', with_desc("Paste without yanking replaced text"))

-- File explorer
keymap("n", "<leader>e", ":Neotree toggle<CR>", with_desc("Toggle file explorer"))

-- Legendary command palette
keymap("n", "<leader>p", ":Legendary<CR>", with_desc("Open legendary palette"))
keymap("n", "<leader>pr", ":LegendaryRepeat<CR>", with_desc("Repeat last legendary action"))

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", with_desc("Find files"))
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", with_desc("Search text in project"))
keymap("n", "<leader>fb", ":Telescope buffers<CR>", with_desc("List open buffers"))
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", with_desc("Search help tags"))
keymap("n", "<leader>ft", ":Telescope tags<CR>", with_desc("Telescope tags"))
keymap("n", "<leader>fT", ":Telescope current_buffer_tags<CR>", with_desc("Telescope buffer tags"))

-- Diagnostics
keymap("n", "<leader>sd", vim.diagnostic.open_float, with_desc("Show line diagnostics"))
keymap("n", "[d", vim.diagnostic.goto_prev, with_desc("Go to previous diagnostic"))
keymap("n", "]d", vim.diagnostic.goto_next, with_desc("Go to next diagnostic"))

-- Terminal
keymap("n", "<leader>tF", ":ToggleTerm direction=float<CR>", with_desc("Toggle floating terminal"))
keymap("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", with_desc("Toggle horizontal terminal"))
keymap("t", "<C-x>", "<C-\\><C-n>", with_desc("Exit terminal mode"))
