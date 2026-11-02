vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<cr>", {
	buffer = true,
	silent = true,
	desc = "VimTeX compile",
})
vim.keymap.set("n", "<leader>mn", "<cmd>write<cr><cmd>FloatermNew ./makeNote.sh<cr>", {
	buffer = true,
	desc = "Run makeNote script in current directory",
})
