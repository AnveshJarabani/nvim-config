return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      -- Setup DAP UI
      dapui.setup()

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup()

      -- Find Python executable
      local function get_python_path()
        -- Check for virtual environment
        local venv_python = os.getenv("VIRTUAL_ENV")
        if venv_python then
          return venv_python .. "/bin/python"
        end

        -- Check common Python locations
        local python_paths = {
          "/usr/bin/python3",
          "/usr/local/bin/python3",
          "/opt/homebrew/bin/python3",
          "python3",
          "python",
        }

        for _, path in ipairs(python_paths) do
          if vim.fn.executable(path) == 1 then
            return path
          end
        end

        return "python3" -- fallback
      end

      -- Setup Python debugging with proper path
      local python_path = get_python_path()
      print("Using Python path: " .. python_path)
      dap_python.setup(python_path)

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Key mappings
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
    end,
  },
}
