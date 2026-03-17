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

-- custom snipptes below

-- fraction snippet
local frac = s(
  {
    trig = "frac",
    dscr = "Insert fraction",
  },
  fmt(
    [[
  \frac{{{}}}{{{}}}
  ]],
    {
      i(1, "numerator"),
      i(2, "denominator"),
    }
  )
)
table.insert(snippets, frac)

return snippets, autosnippets
