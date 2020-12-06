local M = {}

function M.use_default_mappings()
  local nnoremap = function(key, cmd)
    vim.api.nvim_set_keymap('n', key, cmd, {noremap = true, silent = true})
  end

  nnoremap('<leader>pp', [[:lua require('flow').switch_project()<CR>]])
  nnoremap('<leader>pc', [[:lua require('flow').clone_project()<CR>]])
end

function M.switch_project(trigger)
  local query = vim.fn.input('Query: ')

  vim.fn.jobstart('flow search --project ' .. query, {
    on_stdout = function(_, data, _)
      vim.api.nvim_command('cd ' .. data[1])
      if trigger then
        trigger(data[1])
      else
        vim.api.nvim_command('edit ' .. data[1])
      end
    end
  })
end

function M.clone_project(trigger)
  local query = vim.fn.input('Project: ')

  vim.fn.jobstart('flow clone ' .. query, {
    on_stdout = function(_, data, _)
      vim.api.nvim_command('cd ' .. data[#data - 1])
      if trigger then
        trigger(data[#data - 1])
      else
        vim.api.nvim_command('edit ' .. data[#data - 1])
      end
    end
  })
end

return M
