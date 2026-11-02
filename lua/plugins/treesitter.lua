return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function()
    require("treesitter-compat").setup()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c",
        "cpp",
        "cmake",
        "json",
        "bash",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "python",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "php",
        "markdown",
        "markdown_inline",
      },

      auto_install = false,
      ignore_install = { "latex" }, -- VimTeX supplies LaTeX highlighting.
      sync_install = false,

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
