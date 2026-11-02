return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c",
        "cpp",
        "cmake",
        "json",
        "bash",
      },

      auto_install = true,
      sync_install = true,

      highlight = {
        enable = true,
        disable = { "latex" }, -- VimTeX handles .tex files
      },

      indent = {
        enable = true,
      },
    })
  end,
}
