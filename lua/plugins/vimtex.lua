return {
  "lervag/vimtex",
  config = function()
    -- Use init for configuration, don't use the more common "config".
    vim.cmd([[let g:vimtex_view_method = 'zathura']])
  end,
}
