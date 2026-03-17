-- load luasnip
local ls = require("luasnip")

-- support functions
-- function to find a snippet
local function findSnippet(trigger)
  local snip_list = ls.get_snippets("tex")
  for i = 1, #snip_list do
    if snip_list[i].trigger == trigger then
      return snip_list[i]
    end
  end
  return nil -- Restituisce nil se lo snippet non è stato trovato
end

-- function to execute a snippet
local function execute_snippet(trig)
  local snip = findSnippet(trig)
  if snip ~= nil then
    ls.snip_expand(snip)
  else
    print("ERROR: can't find snippet: " .. trig)
  end
end
