return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        automatic_enable = false,
        ensure_installed = {
          "clangd",
          "bashls",
          "pyright",
          "lua_ls",
          "html",
          "cssls",
          "ts_ls",
          "intelephense",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local border = "rounded"

      local function setup_lsp(name, opts)
        vim.lsp.config(name, opts or {})
        vim.lsp.enable(name)
      end

      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        severity_sort = true,
        update_in_insert = false,
        float = {
          border = border,
        },
      })

      vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
      vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })

      vim.o.updatetime = 300

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, {
            focusable = false,
            scope = "cursor",
            border = border,
          })
        end,
      })

      setup_lsp("clangd", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
        end,
      })

      setup_lsp("bashls", {
        capabilities = capabilities,
      })

      setup_lsp("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      setup_lsp("lua_ls", {
        capabilities = capabilities,
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

      setup_lsp("html", {
        capabilities = capabilities,
      })

      setup_lsp("cssls", {
        capabilities = capabilities,
      })

      setup_lsp("ts_ls", {
        capabilities = capabilities,
      })

      -- PHP
      setup_lsp("intelephense", {
        capabilities = capabilities,
      })

      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({ border = border })
      end, { desc = "LSP hover" })

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
        desc = "LSP go to definition",
      })

      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
        desc = "LSP code action",
      })
    end,
  },
}
