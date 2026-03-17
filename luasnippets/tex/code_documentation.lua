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

local attention = s(
  {
    trig = "attention",
    dscr = "Attention enviroment ",
  },
  fmt(
    [[
        {{\color{{red}} \rule{{\linewidth}}{{0.5mm}}}}
        \textcolor{{red}}{{\textbf{{Attention:}}}} {} \\
        {{\color{{red}} \rule{{\linewidth}}{{0.5mm}}}}
    ]],
    {
      i(1, "write message here"),
    }
  )
)

table.insert(snippets, attention)

local note = s(
  {
    trig = "nb",
    dscr = "N.B. enviroment ",
  },
  fmt(
    [[
        {{\color{{blue}} \rule{{\linewidth}}{{0.5mm}}}}
        \textcolor{{blue}}{{\textbf{{N.B.:}}}} {} \\
        {{\color{{blue}} \rule{{\linewidth}}{{0.5mm}}}}
    ]],
    {
      i(1, "write message here"),
    }
  )
)

table.insert(snippets, note)

local code_inline = s(
  {
    trig = "code inline",
    dscr = "inline code enviroment",
  },
  fmt(
    [[
      \begin{{lstlisting}}[language=C++,mathescape=true,breaklines=true,caption={}, label={}]
      {}
      \end{{lstlisting}}
    ]],
    {
      i(1, "caption"),
      i(2, "label"),
      i(3, "code"),
    }
  )
)

table.insert(snippets, code_inline)

local code_from_file = s(
  {
    trig = "code from file",
    dscr = "code from file enviroment",
  },
  fmt(
    [[
      \lstinputlisting[language=C++,mathescape=true,breaklines=true,caption={}, label={}]{{{}}}
    ]],
    {
      i(1, "caption"),
      i(2, "label"),
      i(3, "path to file"),
    }
  )
)

table.insert(snippets, code_from_file)

return snippets, autosnippets
