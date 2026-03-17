-- telescope to search functions and methods: https://neovim.discourse.group/t/telescope-lsp-lsp-document-symbols-how-to-show-only-functions/2971/2
vim.keymap.set("n", "<leader>fl", function()
  require("telescope.builtin").lsp_document_symbols({
    symbols = { "function", "method" },
  })
end, { desc = "list of functions" })
