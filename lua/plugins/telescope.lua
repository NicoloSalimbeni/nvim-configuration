return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set(
        "n",
        "<leader>ff",
        builtin.current_buffer_fuzzy_find,
        { desc = "fuzzy find in current file" }
      )
      vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "grep in current project directory" })
      vim.keymap.set(
        "n",
        "<leader>fo",
        ":Telescope find_files<CR>",
        { desc = "find a file in current directory" }
      )
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
