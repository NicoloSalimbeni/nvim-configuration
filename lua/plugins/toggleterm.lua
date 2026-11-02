return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      -- function to open lazygit
      require("toggleterm").setup({
        insert_mappings = true,
        terminal_mappings = true,
      })

      local Terminal = require("toggleterm.terminal").Terminal
      local bash = Terminal:new({ cmd = "/bin/bash", hidden = true, direction = "horizontal" })

      vim.keymap.set("n", "<leader>j", function()
        bash:toggle()
      end, { silent = true, desc = "Toggle Bash terminal" })

      local lazygit_path = vim.fn.exepath("lazygit")
      if lazygit_path == "" then
        lazygit_path = vim.fn.expand("~/go/bin/lazygit") -- Existing Go installation.
      end
      local lazygit = Terminal:new({ cmd = vim.fn.shellescape(lazygit_path), hidden = true, direction = "float" })

      vim.keymap.set("n", "<leader>lg", function()
        lazygit:toggle()
      end, { silent = true, desc = "Toggle lazygit" })
    end,
  },
}
