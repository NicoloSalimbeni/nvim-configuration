return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "bashls",
          "pylsp",
          "cmake",
          "lua_ls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lsp_util = require("lspconfig.util")

      -- helper for 0.11 style
      local function setup_lsp(name, cfg)
        -- 1) define / merge the config
        vim.lsp.config(name, {
          cmd = cfg.cmd,
          root_dir = cfg.root_dir or lsp_util.root_pattern(".git")(vim.loop.cwd()) or vim.loop.cwd(),
          filetypes = cfg.filetypes,
          settings = cfg.settings,
          capabilities = cfg.capabilities or capabilities,
          on_attach = cfg.on_attach,
        })

        -- 2) enable it (starts it automatically for matching buffers)
        vim.lsp.enable(name)
      end

      -- clangd
      setup_lsp("clangd", {
        -- extra flags = better indexing, tidy checks, header insertion, inlay hints
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--inlay-hints" },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        -- keep null-ls (clang_format) as the only formatter
        on_attach = function(client, bufnr)
          -- turn off clangd formatting so it won't fight null-ls
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          -- inline type hints (Neovim 0.10+)
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      })

      -- bash
      setup_lsp("bashls", {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh" },
      })

      -- python
      setup_lsp("pylsp", {
        cmd = { "pylsp" },
        filetypes = { "python" },
      })

      -- cmake
      setup_lsp("cmake", {
        cmd = { "cmake-language-server" },
        filetypes = { "cmake" },
      })

      -- lua
      setup_lsp("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })

      -- keymaps (global, same as yours)
      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({ border = "rounded" })   -- "single" / "solid" / "double" / "none"
      end, { desc = "LSP quick description" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP go to definition" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })

      -- diagnostic window look
      vim.diagnostic.config({
        virtual_text = false,                     -- keep buffer clean; use popup
        signs = true,
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        float = { border = "none" },             -- no border
      })
      -- make the popup background match the editor
      vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
      vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
      -- auto-show diagnostic under cursor after a short pause
      vim.o.updatetime = 300
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor", border = "rounded"})
        end,
      })


      -- lsp quick description window look 
      local _border = "rounded"  -- or "single", "solid", "double", "shadow", "none"
      -- Customize hover handler
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = _border }
      )
      -- Customize signature help (shows function arguments while typing)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = _border }
      )


    end,
  },
}
