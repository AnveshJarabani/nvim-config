-- lua/config/keymaps.lua or within a LazyVim plugin spec

-- Combine Normal ('n') and Visual ('x') modes where appropriate
-- Note: 'v' mode usually refers to character-wise visual mode in old Vim documentation,
-- but for keymaps, 'x' generally covers all visual modes (character, line, block).
-- If you want to be extremely precise about character-wise visual, use 'v'.
-- However, 'x' is typically sufficient for these kinds of remaps.
local map = vim.keymap.set

-- Remap window navigation to Ctrl-ArrowKeys
map("n", "<M-Left>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<M-Down>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<M-Up>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<M-Right>", "<C-w>l", { desc = "Go to Right Window", remap = true })

--Remap ctrl backspce in insert mode to delete by word
map("i", "<C-H>", "<C-W>", { noremap = true })
-- Normal mode: Move current line
map("n", "<A-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- save file with Alt-S
map({ "n", "i", "v" }, "<A-s>", "<cmd>w<cr>", { desc = "Save File (Alt+S)", noremap = true, silent = true })

map("n", "<C-Home>", "gg", { noremap = true, silent = true })
map("n", "<C-End>", "G", { noremap = true, silent = true })
-- Delete operations for Normal and Visual modes
map({ "n", "x" }, "d", [["_d]], { desc = "Delete to blackhole register" })
-- 'dd' is line-wise, so it only makes sense in Normal mode
map("n", "dd", [["_dd]], { desc = "Delete line to blackhole register" })
map({ "n", "x" }, "x", [["_x]], { desc = "Delete to blackhole register" }) -- 'x' is char delete

-- Change operations for Normal and Visual modes
map({ "n", "x" }, "c", [["_c]], { desc = "Change to blackhole register" })
map({ "n", "x" }, "C", [["_C]], { desc = "Change to blackhole register" })
-- 'cc' is line-wise, so it only makes sense in Normal mode
map("n", "cc", [["_cc]], { desc = "Change line to blackhole register" })
-- Specific Normal mode operations that don't have direct visual mode equivalents
-- or are typically used differently
map("n", "ciw", [["_ciw]], { desc = "Change inner word to blackhole register" })
map("n", "cw", [["_cw]], { desc = "Change word to blackhole register" })
-- ... and other normal mode specific operations

-- For 'S' (substitute line), it's a normal mode command.
-- map("n", "S", [["_S]], { desc = "Substitute line to blackhole register" })

-- use escape to close any popup windows
map("n", "<Esc>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end, { desc = "Close all floating windows with Esc" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "noice", "copilot", "qf", "help", "markdown" }, -- add filetypes that open in splits
  callback = function()
    -- Map <Esc> to close the window/buffer
    map("n", "<Esc>", "<cmd>close<cr>", { buffer = true, silent = true })
  end,
})
-- Map the <leader><leader> to `find_files`
map("n", "<leader><leader>", function()
  require("telescope.builtin").find_files()
end, { desc = "Telescope: Find Files" })

-- Map <leader>/ to find files in the home directory
map("n", "<leader>/", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.expand("~") })
end, { desc = "Telescope: Find Files root directory" })

-- Map <leader>; to live grep
map("n", "<leader>;", function()
  require("telescope.builtin").live_grep()
end, { desc = "Telescope: Live Grep" })
map("n", "<leader>'", function()
  require("telescope.builtin").live_grep({ cwd = vim.fn.expand("~") })
end, { desc = "Telescope: Live Grep (root directory)" })
-- Scroll up/down half a screen with Ctrl+Up / Ctrl+Down
map("n", "<C-Up>", "<C-u>", { noremap = true, silent = true })
map("n", "<C-Down>", "<C-d>", { noremap = true, silent = true })

-- (Optional) Also add to insert/visual mode if needed
map("i", "<C-Up>", "<C-o><C-u>", { noremap = true, silent = true })
map("i", "<C-Down>", "<C-o><C-d>", { noremap = true, silent = true })

map("v", "<C-Up>", "<C-u>", { noremap = true, silent = true })
map("v", "<C-Down>", "<C-d>", { noremap = true, silent = true })

-- Map Space + n to NoiceTelescope
map("n", "<Space>n", ":NoiceTelescope<CR>", { noremap = true, silent = true })

-- Map Ctrl+b to Telescope Buffers
map("n", "<C-b>", function()
  require("telescope.builtin").buffers()
end, { desc = "Telescope: Switch Buffers" })

map("n", "<space>tb", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true, desc = "Telescope: Buffers" })
map("n", "<space>bt", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true, desc = "Telescope: Buffers" })
map(
  "n",
  "<space>tf",
  "<cmd>Telescope find_files<CR>",
  { noremap = true, silent = true, desc = "Telescope: Find Files" }
)
map("n", "<space>tg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Telescope: Live Grep" })
map("n", "<space>th", "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true, desc = "Telescope: Help Tags" })
map("n", "<space>tm", "<cmd>Telescope marks<CR>", { noremap = true, silent = true, desc = "Telescope: Marks" })
map(
  "n",
  "<space>tr",
  "<cmd>Telescope oldfiles<CR>",
  { noremap = true, silent = true, desc = "Telescope: Recent Files" }
)
map(
  "n",
  "<space>tt",
  "<cmd>Telescope treesitter<CR>",
  { noremap = true, silent = true, desc = "Telescope: Treesitter" }
)
map("n", "<space>tc", "<cmd>Telescope frecency<CR>", { noremap = true, silent = true, desc = "Telescope: Frecency" })
map("n", "<leader>rm", [[:%s/\r//g<CR>]], { noremap = true, silent = true })
map("v", "<leader>rm", [[:s/\r//g<CR>]], { noremap = true, silent = true })
map("n", "<leader>ss", ":SessionSearch<CR>", { desc = "SessionSearch" })
map("n", "<space>zz", ":qa!<CR>", { desc = "Quit All" })
map("n", "<space>G", "<cmd>LazyGit<CR>", { noremap = true, silent = true, desc = "LazyGit" })
map("n", "ZQ", ":qa!<CR>")
map("n", "ZZ", ":wqa!<CR>")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

-- map("n", "<C-_>", function()
--   local buf_path = vim.api.nvim_buf_get_name(0)
--   local dir = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":p:h") or vim.loop.cwd()
--   require("toggleterm.terminal").Terminal:new({ direction = "float", dir = dir }):toggle()
-- end, { desc = "Toggle floating terminal in buffer dir" })

local main_term
map("n", "<leader>tl", function()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local dir = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":p:h") or vim.loop.cwd()
  if not main_term then
    main_term = require("toggleterm.terminal").Terminal:new({ direction = "float", dir = dir, name = "main_term" })
  end
  main_term:toggle()
end, { desc = "Toggle main floating terminal in buffer dir" })

map("i", "<C-y>", function()
  require("copilot.suggestion").accept()
end, { desc = "Copilot Accept" })

map("n", "<leader>yd", function()
  local dir = vim.fn.expand("%:p:h")
  vim.fn.setreg("+", dir)
  vim.notify("Copied directory to clipboard:\n" .. dir, vim.log.levels.INFO)
end, { desc = "Copy buffer directory to clipboard" })

map("n", "<leader>yb", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied file path to clipboard:\n" .. path, vim.log.levels.INFO)
end, { desc = "Copy buffer file path to clipboard" })

map("n", "<leader>yf", function()
  local filename = vim.fn.expand("%:t")
  vim.fn.setreg("+", filename)
  vim.notify("Copied file name to clipboard:\n" .. filename, vim.log.levels.INFO)
end, { desc = "Copy buffer file name to clipboard" })

vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

-- Diff operations
map("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "Diff View Open" })
map("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "Diff View Close" })

-- Clear quickfix list
map("n", "<leader>qc", "<cmd>call setqflist([])<CR>", { desc = "Clear quickfix list" })

-- Other useful quickfix mappings
map("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>qq", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
map("n", "<leader>qn", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
map("n", "<leader>qp", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })

-- Function to remove trailing whitespace from all active buffers
local function remove_trailing_whitespace()
  local buffers = vim.api.nvim_list_bufs()
  local count = 0
  local processed = 0

  for _, buf in ipairs(buffers) do
    -- Only process loaded, valid buffers with a filename
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_is_valid(buf) then
      local filename = vim.api.nvim_buf_get_name(buf)
      if filename ~= "" then
        -- Switch to the buffer
        vim.api.nvim_set_current_buf(buf)

        local before_content = vim.fn.getline(1, "$")
        vim.cmd("%s/\\s\\+$//e")
        local after_content = vim.fn.getline(1, "$")

        -- Check if content actually changed
        local changed = false
        if #before_content == #after_content then
          for i = 1, #before_content do
            if before_content[i] ~= after_content[i] then
              changed = true
              break
            end
          end
        else
          changed = true
        end

        if changed then
          count = count + 1
        end
        processed = processed + 1
      end
    end
  end
  print("Processed " .. processed .. " buffers, modified " .. count .. " buffers")
end

-- Create user command
vim.api.nvim_create_user_command("RemoveTrailingWhitespace", remove_trailing_whitespace, {})

-- Create hotkey
map("n", "<leader>tw", remove_trailing_whitespace, { desc = "Remove trailing whitespace from all active buffers" })
