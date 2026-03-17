return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		vim.keymap.set("n", "<leader>tl", ":TodoTelescope<CR>", { desc = "show all todo instances in current file" }),
	},
}
