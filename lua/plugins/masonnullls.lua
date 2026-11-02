return {
	"jay-babu/mason-null-ls.nvim",
	dependencies = { "mason.nvim", "none-ls.nvim" },
	opts = {
		ensure_installed = {
			"stylua",
			"clang_format",
			"cmake_lint",
			"cmake_format",
			"shfmt",
			"black",
			"prettier",
		},
	},
}
