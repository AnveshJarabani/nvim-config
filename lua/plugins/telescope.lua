return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  lazy = false, -- load immediately at startup
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader><leader>",
      function()
        require("telescope.builtin").find_files({ prompt_prefix = "🔍" })
      end,
      desc = "Telescope: Find Files (override)",
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.expand("~") })
      end,
      desc = "Telescope: Find Files (override) root directory",
    },
    {
      "<leader>;",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Telescope: Live Grep (override)",
    },
    {
      "<leader>ct",
      function()
        require("telescope.builtin").diagnostics({
          bufnr = 0, -- set to 0 for current buffer only; omit for all diagnostics
        })
      end,
      desc = "Telescope: Search Diagnostics",
    },
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = {
        width = 0.99,
        height = 0.95,
        preview_width = 0.5,
      },
      prompt_position = "bottom",
      sorting_strategy = "ascending",
      winblend = 0,
      border = true,
    },
    extensions = {
      frecency = {
        auto_validate = false,
        matcher = "fuzzy",
        path_display = { "filename_first" },
      },
    },
    pickers = {
      find_files = {
        hidden = true, -- Show dotfiles by default
      },
    },
  },
}
