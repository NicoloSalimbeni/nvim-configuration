vim.keymap.set("n", "<leader>fl", function()
  require("telescope.builtin").lsp_document_symbols({
    symbols = { "function", "method" },
  })
end, { buffer = true, desc = "list of functions" })
