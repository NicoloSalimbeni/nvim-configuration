return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "ErrorMsg",
        linehl = "",
        numhl = "",
      })

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
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 1 },
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

      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "debugger continue" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "debugger set breakpoint" })
      vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "debugger step-over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "debugger step-into" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "debugger step-out" })
      vim.keymap.set("n", "<leader>dt", function()
        dapui.toggle()
      end, { desc = "debugger toggle ui" })

      vim.keymap.set("n", "<leader>dC", function()
        dap.clear_breakpoints()
        vim.notify("Breakpoints cleared", vim.log.levels.WARN, {
          title = "debugger",
        })
      end, { desc = "debugger clear" })

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
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local dap = require("dap")
      local dap_python = require("dap-python")

      local debugpy_path = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
      dap_python.setup(debugpy_path)

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch Python file",
          program = function()
            return vim.fn.input("Path to Python file: ", vim.fn.expand("%:p"), "file")
          end,
          args = function()
            local input = vim.fn.input("Arguments (optional): ")
            if input == "" then
              return {}
            end
            return vim.split(input, "%s+", { trimempty = true })
          end,
          console = "integratedTerminal",
          redirectOutput = true,
        },
      }
    end,
  },
}
