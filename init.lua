local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("vim-options")
require("lazy").setup("plugins")
vim.api.nvim_command("filetype plugin on")

-- -- diagnostic box
-- vim.diagnostic.config({
--   virtual_text = false,
--   signs = true,
--   underline = true,
--   severity_sort = true,
--   update_in_insert = false,
-- })
-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor", border = "rounded" })
--   end,
-- })
-- -- optional: quicker hover
-- vim.o.updatetime = 300
-- background like the one loaded by the color scheme plugin
-- vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
