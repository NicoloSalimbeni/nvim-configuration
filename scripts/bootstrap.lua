-- Called by configure.sh with -u NONE; deliberately avoids normal startup.
local function main()
	vim.opt.loadplugins = true -- -u NONE disables this; lazy.nvim requires it.
	local config_dir = assert(vim.env.NVIM_CONFIGURE_DIR, "NVIM_CONFIGURE_DIR is required")
	vim.opt.runtimepath:prepend(config_dir)
	local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.uv.fs_stat(lazy_path) then
		local output = vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--branch=stable",
			"https://github.com/folke/lazy.nvim.git",
			lazy_path,
		})
		assert(vim.v.shell_error == 0, "lazy.nvim bootstrap failed: " .. output)
	end
	vim.opt.runtimepath:prepend(lazy_path)
	require("lazy").setup({
		spec = {
			{ import = "plugins" },
			-- Parser installation is performed synchronously after plugin setup.
			{ "nvim-treesitter/nvim-treesitter", build = false, config = function() end },
		},
		defaults = { lazy = true },
		install = { missing = false },
		checker = { enabled = false },
		change_detection = { enabled = false },
		lockfile = config_dir .. "/lazy-lock.json",
	})
	local function check_plugins()
		for name, plugin in pairs(require("lazy.core.config").plugins) do
			assert(plugin._.installed, "Plugin not installed: " .. name)
			for _, task in ipairs(plugin._.tasks or {}) do
				assert(not task:has_errors(), "Plugin task failed: " .. name .. " (see output above)")
			end
		end
	end
	require("lazy").install({ wait = true, show = false, lockfile = true })
	check_plugins()
	require("lazy").restore({ wait = true, show = false })
	check_plugins()

	-- Load only the installers, leaving their normal config callbacks dormant.
	require("lazy").load({ plugins = { "mason.nvim", "nvim-treesitter", "markdown-preview.nvim" } })
	require("mason").setup()
	local packages = {
		"clangd",
		"bash-language-server",
		"pyright",
		"lua-language-server",
		"html-lsp",
		"css-lsp",
		"typescript-language-server",
		"intelephense",
		"stylua",
		"clang-format",
		"cmakelint",
		"cmakelang",
		"shfmt",
		"black",
		"prettier",
		"debugpy",
	}
	local registry = require("mason-registry")
	registry.refresh()
	local missing = {}
	for _, name in ipairs(packages) do
		if not registry.get_package(name):is_installed() then
			table.insert(missing, name)
		end
	end
	-- Mason's headless command blocks until installation finishes and exits
	-- nonzero for failed packages. Its normal UI command is asynchronous.
	if #missing > 0 then
		vim.cmd("MasonInstall " .. table.concat(missing, " "))
	end
	for _, name in ipairs(packages) do
		assert(registry.get_package(name):is_installed(), "Mason package missing: " .. name)
	end

	local parsers = {
		"c",
		"cpp",
		"cmake",
		"json",
		"bash",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"python",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"php",
		"markdown",
		"markdown_inline",
	}
	require("nvim-treesitter.configs").setup({ ensure_installed = {}, auto_install = false })
	-- This API skips existing parsers and never asks interactive reinstall questions.
	require("nvim-treesitter.install").ensure_installed_sync(parsers)
	local installed = require("nvim-treesitter.info").installed_parsers()
	for _, name in ipairs(parsers) do
		assert(vim.tbl_contains(installed, name), "Tree-sitter parser missing: " .. name)
	end

	local preview = require("lazy.core.config").plugins["markdown-preview.nvim"]
	local node_modules = preview.dir .. "/app/node_modules"
	if vim.fn.isdirectory(node_modules) == 0 then
		local result = vim.system({
			"npm",
			"install",
			"--omit=dev",
			"--no-fund",
			"--no-audit",
			"--package-lock=false",
		}, { cwd = preview.dir .. "/app", text = true }):wait(600000)
		assert(result.code == 0, "Markdown preview install failed: " .. (result.stderr or ""))
	end
	assert(vim.fn.isdirectory(node_modules) == 1, "Markdown preview Node dependencies are missing")
	print("Plugins, Mason tools, parsers and Markdown preview are installed.")
end

local ok, err = xpcall(main, debug.traceback)
if not ok then
	vim.api.nvim_err_writeln(err)
	vim.cmd("cquit 1")
else
	vim.cmd("qa!")
end
