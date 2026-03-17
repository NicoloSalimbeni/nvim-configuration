local check, ls = pcall(require, "luasnip")
if not check then
  return
end
local t = ls.text_node   -->text node
local i = ls.insert_node -->insert node
local s = ls.snippet     -->snippet
local sn = ls.snippet_node
local f = ls.function_node
local c = ls.choice_node -->choice node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

local snippets, autosnippets = {}, {}

local group = vim.api.nvim_create_augroup("Lua Snippets", { clear = true })
local file_pattern = "*.lua"

-- local function cs(trigger, nodes, opts)

-- write your snippets here

-- start refactoring
-- end refactoring
return snippets, autosnippets
-- use :set filetype? to know the file types
