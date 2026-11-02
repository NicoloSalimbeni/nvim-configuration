return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "mason.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,

				-- C++
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.diagnostics.cppcheck.with({
					condition = function()
						return vim.fn.executable("cppcheck") == 1
					end,
				}),

				-- CMake
				null_ls.builtins.diagnostics.cmake_lint,
				null_ls.builtins.formatting.cmake_format,

				-- Bash
				null_ls.builtins.formatting.shfmt,

				-- Python
				null_ls.builtins.formatting.black,

				-- JavaScript / TypeScript / HTML / CSS / JSON
				null_ls.builtins.formatting.prettier,

				-- PHP
				-- null_ls.builtins.formatting.phpcsfixer,
			},

			on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					local group = vim.api.nvim_create_augroup("LspFormatting_" .. bufnr, { clear = true })

					vim.api.nvim_create_autocmd("BufWritePre", {
						group = group,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(format_client)
									return format_client.name == "null-ls"
								end,
								timeout_ms = 5000,
							})
						end,
					})
				end
			end,
		})

		vim.keymap.set("n", "<leader>gf", function()
			vim.lsp.buf.format({
				filter = function(client)
					return client.name == "null-ls"
				end,
				timeout_ms = 5000,
			})
		end, { desc = "Format current file" })
	end,
}
