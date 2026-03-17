return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "cpp", "cmake", "json", "bash" },
      auto_install = true,
      sync_install = true,
      highlight = {
        enable = true,
        disable = { "latex" }, -- VimTex takes care of .tex files
      },
      indent = { enable = true },
    })
  end,
}
