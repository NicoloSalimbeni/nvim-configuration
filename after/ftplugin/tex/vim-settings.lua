vim.cmd([[
setlocal wrap
set spell spelllang=en_us
let g:vimtex_quickfix_open_on_warning = 0  " Don’t open QuickFix for warnings only
]])
vim.api.nvim_set_keymap(
	"n",
	"<leader>lc",
	":VimtexCompile<CR>",
	{ noremap = true, silent = true, desc = "vimtex compile" }
)
vim.keymap.set(
	"n",
	"<leader>mn",
	":w<CR> :FloatermNew ./makeNote.sh <CR>",
	{ desc = "run makeNote script in current directory" }
)
