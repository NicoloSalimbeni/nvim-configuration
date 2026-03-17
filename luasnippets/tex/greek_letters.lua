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

-- custom snipptes below

-- #######################
-- #  GREEK LETTERS      #
-- #######################

local greek_letters = {
	"Alpha",
	"Beta",
	"Gamma",
	"Delta",
	"Epsilon",
	"Zeta",
	"Eta",
	"Theta",
	"Iota",
	"Kappa",
	"Lambda",
	"Mu",
	"Nu",
	"Xi",
	"Omicron",
	"Pi",
	"Rho",
	"Sigma",
	"Tau",
	"Upsilon",
	"Phi",
	"Chi",
	"Psi",
	"Omega",
}

for count = 1, #greek_letters do
	local letter = greek_letters[count]
	local snip_upper = s({ trig = letter, dscr = "Uppercase greek letter " .. letter:lower() }, { t("\\" .. letter) })
	local snip_lower = s(
		{ trig = letter:lower(), dscr = "Lowercase greek letter " .. letter:lower() },
		{ t("\\" .. letter:lower()) }
	)
	table.insert(snippets, snip_upper)
	table.insert(snippets, snip_lower)
end

return snippets, autosnippets
