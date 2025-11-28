return {
  -- add dracula
  { "Mofiqul/dracula.nvim" },

  -- add onedark
  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup({
        style = "deep",
      })
      require("onedark").load()
    end,
  },

  -- Configure LazyVim to load dracula
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        italic_comments = true,
      })
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false, -- load immediately at startup
    priority = 1000, -- ensure it loads before other plugins
    config = function()
      vim.opt.background = "dark" -- set this to "dark" or "light"
      -- Optional: Add transparent background
      -- Uncomment the lines below if you want transparency
      -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        -- Add your configuration here if needed
        options = {
          compile_path = vim.fn.stdpath("cache") .. "/github-theme",
          compile_file_suffix = "_compiled",
          hide_end_of_buffer = true,
          hide_nc_statusline = true,
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
        },
      })
    end,
  },
}
