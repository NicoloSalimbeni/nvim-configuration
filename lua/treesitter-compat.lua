-- The frozen nvim-treesitter/master branch registers single-node query
-- handlers with all=false, which Neovim 0.12 no longer supports. Keep the
-- legacy handlers compatible until this configuration migrates to main.
local M = {}

function M.setup()
	if vim.fn.has("nvim-0.12") == 0 then
		return
	end

	local query = vim.treesitter.query
	local function node(match, id)
		local nodes = match[id]
		return nodes and nodes[#nodes] -- Match the former all=false behavior.
	end
	local function directive(name, handler)
		query.add_directive(name, handler, { force = true })
	end
	local function predicate(name, handler)
		query.add_predicate(name, handler, { force = true })
	end

	directive("downcase!", function(match, _, source, pred, metadata)
		local id = pred[2]
		local capture = node(match, id)
		if not capture then
			return
		end
		local text = vim.treesitter.get_node_text(capture, source, { metadata = metadata[id] }) or ""
		metadata[id] = metadata[id] or {}
		metadata[id].text = text:lower()
	end)

	directive("set-lang-from-mimetype!", function(match, _, source, pred, metadata)
		local capture = node(match, pred[2])
		if not capture then
			return
		end
		local text = vim.treesitter.get_node_text(capture, source)
		local aliases = {
			importmap = "json",
			module = "javascript",
			["application/ecmascript"] = "javascript",
			["text/ecmascript"] = "javascript",
		}
		metadata["injection.language"] = aliases[text] or text:match("[^/]+$")
	end)

	directive("set-lang-from-info-string!", function(match, _, source, pred, metadata)
		local capture = node(match, pred[2])
		if not capture then
			return
		end
		local text = vim.treesitter.get_node_text(capture, source):lower()
		local aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
		metadata["injection.language"] = vim.filetype.match({ filename = "a." .. text }) or aliases[text] or text
	end)

	predicate("nth?", function(match, _, _, pred)
		local capture = node(match, pred[2])
		local index = tonumber(pred[3])
		return capture ~= nil and capture:parent() ~= nil and capture:parent():named_child(index) == capture
	end)

	predicate("kind-eq?", function(match, _, _, pred)
		local capture = node(match, pred[2])
		return not capture or vim.tbl_contains({ unpack(pred, 3) }, capture:type())
	end)

	predicate("is?", function(match, _, source, pred)
		local capture = node(match, pred[2])
		if not capture then
			return true
		end
		local _, _, kind = require("nvim-treesitter.locals").find_definition(capture, source)
		return vim.tbl_contains({ unpack(pred, 3) }, kind)
	end)
end

return M
