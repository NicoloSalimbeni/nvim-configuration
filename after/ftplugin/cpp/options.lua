vim.opt_local.spell = true

-- fold settings
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]]
vim.wo.foldnestmax = 3
vim.wo.foldminlines = 1

vim.wo.foldlevel = 99 -- Keep folds open when entering a file.
