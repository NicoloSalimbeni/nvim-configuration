local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = false -- show relative line numbers
opt.number = true          -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2       -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2    -- 2 spaces for indent width
opt.expandtab = true  -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

vim.keymap.set("n", "x", '"_x')

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>tt", ":tabnew<CR>", { desc = " open new tab" })        -- open new tab
vim.keymap.set("n", "<leader>tw", ":tabclose<CR>", { desc = "close current tab" })  -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "got to next tab" })        --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "go to previous tab" })     --  go to previous tab

vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "split window vertically" })   -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally" }) -- split window horizontally
