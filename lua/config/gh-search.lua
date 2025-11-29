-- GitHub code search with interactive picker
local M = {}

-- Search GitHub code and open permalink in browser
function M.search_code()
  vim.ui.input({ prompt = "🔍 GitHub Code Search: " }, function(query)
    if not query or query == "" then
      return
    end

    -- Run gh search code command
    local cmd = string.format(
      'gh search code "%s" --owner mediwareinc --limit 100 --json repository,path,url',
      query
    )

    vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if not data then
          return
        end
        local json_str = table.concat(data, "\n")
        if json_str == "" then
          vim.notify("No results found", vim.log.levels.WARN)
          return
        end

        local ok, results = pcall(vim.fn.json_decode, json_str)
        if not ok or not results or #results == 0 then
          vim.notify("No results found", vim.log.levels.WARN)
          return
        end

        -- Format results for Telescope
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        pickers
          .new({
            layout_strategy = "horizontal",
            layout_config = {
              width = 0.95,
              height = 0.95,
              preview_width = 0.5,
            },
          }, {
            prompt_title = "GitHub Code Search Results",
            finder = finders.new_table({
              results = results,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = entry.repository.nameWithOwner .. " → " .. entry.path,
                  ordinal = entry.repository.nameWithOwner .. " " .. entry.path,
                  url = entry.url,
                }
              end,
            }),
            sorter = conf.generic_sorter({}),
            previewer = require("telescope.previewers").new_buffer_previewer({
              title = "Info",
              define_preview = function(self, entry)
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
                  "Repository: " .. entry.value.repository.nameWithOwner,
                  "Path: " .. entry.value.path,
                  "",
                  "URL: " .. entry.value.url,
                })
              end,
            }),
            attach_mappings = function(prompt_bufnr, map)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local browser = os.getenv("BROWSER")
                  or '/mnt/c/Program\\ Files\\ \\(x86\\)/Microsoft/Edge/Application/msedge.exe'
                local open_cmd = string.format('%s "%s"', browser, selection.url)
                vim.fn.jobstart(open_cmd, { detach = true })
                vim.notify("Opening: " .. selection.url, vim.log.levels.INFO)
              end)
              return true
            end,
          })
          :find()
      end,
      on_stderr = function(_, data)
        if data and #data > 0 then
          vim.notify("Error: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
        end
      end,
    })
  end)
end

-- Browse GitHub repo in browser
function M.browse_repo()
  vim.ui.input({ prompt = "📦 Repository (OWNER/REPO): " }, function(repo)
    if not repo or repo == "" then
      return
    end

    local cmd = string.format('gh browse -R %s', repo)

    vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        local url = table.concat(data, "")
        if url ~= "" then
          vim.notify("Opening: " .. repo, vim.log.levels.INFO)
        end
      end,
    })
  end)
end

return M
