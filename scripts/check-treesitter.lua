-- Run from this repository: nvim --headless '+luafile scripts/check-treesitter.lua'
local function check()
	local samples = {
		{
			name = "bash",
			filetype = "sh",
			child = "lua",
			lines = { "#!/usr/bin/env bash", "cat <<'LUA'", "local answer = 42", "LUA" },
		},
		{
			name = "html",
			filetype = "html",
			child = "javascript",
			lines = { '<script type="application/ecmascript">', 'const answer = "hello";', "</script>" },
		},
		{
			name = "markdown",
			filetype = "markdown",
			child = "bash",
			lines = { "# Example", "```sh", 'echo "hello"', "```" },
		},
	}
	for _, sample in ipairs(samples) do
		local buffer = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_set_current_buf(buffer)
		vim.api.nvim_buf_set_lines(buffer, 0, -1, false, sample.lines)
		vim.bo[buffer].filetype = sample.filetype
		local parser = vim.treesitter.get_parser(buffer)
		parser:parse(true)
		assert(parser:children()[sample.child], sample.name .. ": missing " .. sample.child .. " injection")
		-- Invalidate the tree and parse again, as happens while editing.
		vim.api.nvim_buf_set_lines(buffer, 0, 0, false, { "" })
		parser:parse(true)
		assert(parser:children()[sample.child], sample.name .. ": injection lost after edit")
		print("PASS: " .. sample.name .. " highlighting and " .. sample.child .. " injection")
	end
	local buffer = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_set_current_buf(buffer)
	vim.api.nvim_buf_set_lines(buffer, 0, -1, false, vim.fn.readfile(vim.fn.stdpath("config") .. "/configure.sh"))
	vim.bo[buffer].filetype = "sh"
	vim.treesitter.get_parser(buffer):parse(true)
	print("PASS: configure.sh with its embedded heredocs")
end

local ok, err = xpcall(check, debug.traceback)
if not ok then
	vim.api.nvim_err_writeln(err)
	vim.cmd("cquit 1")
else
	vim.cmd("qa!")
end
