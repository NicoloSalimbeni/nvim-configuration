return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	keys = {
		{ "<leader>tl", "<cmd>TodoTelescope<cr>", desc = "Search project TODO comments" },
	},
}
