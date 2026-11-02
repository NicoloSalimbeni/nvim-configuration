local group = vim.api.nvim_create_augroup("PHPFormatOnSave_" .. vim.api.nvim_get_current_buf(), { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	buffer = 0,
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
