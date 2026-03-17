local check, ls = pcall(require, "luasnip")
if not check then
	return
end
local t = ls.text_node -->text node
local i = ls.insert_node -->insert node
local s = ls.snippet -->snippet
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

-- fraction snippet
local doxygen_function_comment = s(
	{
		trig = "/**",
		dscr = "dogygen style function comment",
	},
	fmt(
		[[
  /**
   {}
  */
  ]],
		{
			i(1, "comment"),
		}
	)
)
table.insert(snippets, doxygen_function_comment)

local doxygen_variable_comment = s(
	{
		trig = "/**<",
		dscr = "dogygen style variable comment",
	},
	fmt([[/**< {} */]], {
		i(1, "comment"),
	})
)
table.insert(snippets, doxygen_variable_comment)

local doxygen_attention_flag = s(
	{
		trig = "\\",
		dscr = "dogygen attention flag",
	},
	fmt([[\attention {}]], {
		i(1, "comment in attention section"),
	})
)
table.insert(snippets, doxygen_attention_flag)

local doxygen_warning_flag = s(
	{
		trig = "\\",
		dscr = "dogygen warning flag",
	},
	fmt([[\attention {}]], {
		i(1, "comment in warning section"),
	})
)
table.insert(snippets, doxygen_warning_flag)

local doxygen_parameter_flag = s(
	{
		trig = "@param",
		dscr = "dogygen parameter flag",
	},
	fmt([[@param {}]], {
		i(1, "parameter comment"),
	})
)
table.insert(snippets, doxygen_parameter_flag)

local doxygen_file_flag = s(
	{
		trig = "@file",
		dscr = "dogygen file flag",
	},
	fmt([[@file {}]], {
		i(1, "file comment"),
	})
)
table.insert(snippets, doxygen_file_flag)

-- start refactoring
-- end refactoring
return snippets, autosnippets
-- use :set filetype? to know the file types
