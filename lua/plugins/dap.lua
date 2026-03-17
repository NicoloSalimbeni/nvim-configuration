return {
  "https://github.com/mfussenegger/nvim-dap",
  dependencies = {
    "https://github.com/rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")

    -- icons
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" })

    dapui.setup()
    -- dap ui functions
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- dap keymaps
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "debugger continue" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "debugger set breakpoint" })
    vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "debugge step-over" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "debugger step-into" })
    vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "debugger step-out" })
    vim.keymap.set("n", "<leader>dt", "<cmd>lua require('dapui').toggle()<cr>", { desc = "debugger toggle ui" })
    vim.keymap.set("n", "<leader>dC", function()
      dap.clear_breakpoints()
      local notify = require("notify")
      notify("Breakpoints cleared", "warn", {
        render = "compact",
        title = "debugger",
        time = 3000,
        icon = "",
      })
    end, { desc = "debugger clear" })

    -- c++ configuration for gdb
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "-i", "dap" },
    }
    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
    }

    dapui.setup({
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = "",
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      force_buffers = true,
      icons = {
        collapsed = "",
        current_frame = "",
        expanded = "",
      },
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            {
              id = "repl",
              -- size = 0.5,
              size = 1,
            },
            -- {
            -- 	id = "console",
            -- 	size = 0.5,
            -- },
          },
          position = "bottom",
          size = 10,
        },
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    })
  end,
}
