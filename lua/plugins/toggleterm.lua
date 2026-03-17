return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      -- function to open lazygit
      require("toggleterm").setup {
        insert_mappings = true,
        terminal_mappings = true,
      }

      local Terminal = require("toggleterm.terminal").Terminal
      local bash = Terminal:new({ cmd = "/bin/bash", hidden = true, direction = "horizontal" })

      function _bash_toggle()
        bash:toggle()
      end

      vim.api.nvim_set_keymap("n", "<leader>j", "<cmd>lua _bash_toggle()<CR>", { noremap = true, silent = true })

      local TerminalGit = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap(
        "n",
        "<leader>lg",
        "<cmd>lua _lazygit_toggle()<CR>",
        { noremap = true, silent = true }
      )
    end,
  },
}
