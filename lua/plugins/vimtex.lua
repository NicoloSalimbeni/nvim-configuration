return {
  "lervag/vimtex",
  init = function()
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.cmd([[let g:vimtex_view_method = 'zathura']])
  end,
}
