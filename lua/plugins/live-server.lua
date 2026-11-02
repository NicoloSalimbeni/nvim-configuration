vim.g.live_server = {
  port = 8080,
  browser = true,
}

return {
  {
    "https://forge.barrettruth.com/barrettruth/live-server.nvim",
    lazy = true,
    cmd = {
      "LiveServerStart",
      "LiveServerStop",
      "LiveServerToggle",
    },
    keys = {
      {
        "<leader>ls",
        "<cmd>LiveServerToggle<cr>",
        desc = "Toggle Live Server",
      },
    },
  },
}
