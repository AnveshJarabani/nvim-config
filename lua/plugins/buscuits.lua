return {
  "code-biscuits/nvim-biscuits",
  event = "VeryLazy",
  config = function()
    require("nvim-biscuits").setup({
      default_config = {
        max_length = 12,
        min_distance = 5,
        prefix_string = " 󰆘 ",
      },
      language_config = {
        html = {
          prefix_string = " 🌐 ",
        },
        javascript = {
          prefix_string = " ⚡ ",
        },
        lua = {
          prefix_string = " 🌙 ",
        },
      },
    })
  end,
}
