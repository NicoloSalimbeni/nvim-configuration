vim.api.nvim_create_augroup("PHPFormatOnSave", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = "PHPFormatOnSave",
	pattern = "*.php",
	callback = function(args)
		vim.lsp.buf.format({
			bufnr = args.buf,
			filter = function(client)
				return client.name == "intelephense"
			end,
			timeout_ms = 5000,
		})
	end,
})
