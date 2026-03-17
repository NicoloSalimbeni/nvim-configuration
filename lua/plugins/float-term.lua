return {
  "voldikss/vim-floaterm",
  config = function()
    vim.keymap.set("n", "<leader>nt", ":FloatermNew<CR>", { desc = "open floating terminal" })
  end,
}
