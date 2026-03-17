vim.api.nvim_set_keymap(
	"n",
	"<leader>mp",
	"<cmd>MarkdownPreviewToggle<cr>",
	{ noremap = true, silent = true, desc = "toggle markdown preview" }
)
