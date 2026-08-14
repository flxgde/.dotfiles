vim.flxg = { }

function vim.flxg.ngjump()
  local filepath = vim.fn.expand("%:p")
  local ext = vim.fn.expand("%:e")
  local basename = filepath:sub(1, #filepath - #ext - 1)

  if ext == "html" then
    vim.cmd("edit " .. basename .. ".ts")
  elseif ext == "ts" then
    local html_file = basename .. ".html"
    if vim.fn.filereadable(html_file) == 1 then
      vim.cmd("edit " .. html_file)
    else
      print("No corresponding HTML file found")
    end
  else
    print("Not an Angular component file")
  end
end

function vim.flxg.nggc()
  local name = vim.fn.input("Component name: ")
  if name ~= "" then
    vim.cmd("!ng g c " .. name)
  end
end

function vim.flxg.duplicate()
  -- Get the current file full path
  local filepath = vim.fn.expand('%:p')
  if filepath == '' then
    return
  end

  local newfile = vim.fn.input("Duplicate to: ", filepath)
  if newfile == '' or newfile == filepath then
    return
  end

	if vim.uv.fs_stat(newfile) then
		return
	end

  local cmd = string.format('cp %s %s', vim.fn.shellescape(filepath), vim.fn.shellescape(newfile))
  vim.fn.system(cmd)

  vim.cmd('edit ' .. vim.fn.fnameescape(newfile))
end

-- Expands the array/object/import-list/argument-list literal under the
-- cursor from a single line into one entry per line. Uses treesitter so it
-- works regardless of nesting or comma placement inside entries.
local multilinify_container_types = {
  array = true,
  object = true,
  named_imports = true,
  arguments = true,
}

function vim.flxg.multilinify()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    vim.notify("No treesitter node under cursor", vim.log.levels.WARN)
    return
  end

  while node and not multilinify_container_types[node:type()] do
    node = node:parent()
  end

  if not node then
    vim.notify("No array/object/import list found under cursor", vim.log.levels.WARN)
    return
  end

  local start_row, start_col, end_row, end_col = node:range()
  if start_row ~= end_row then
    vim.notify("Already multiline", vim.log.levels.INFO)
    return
  end

  local children = node:named_children()
  if #children == 0 then
    vim.notify("Nothing to expand", vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local full_text = vim.treesitter.get_node_text(node, bufnr)
  local open_char, close_char = full_text:sub(1, 1), full_text:sub(-1)

  local base_indent = (vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1] or ""):match("^%s*")
  local inner_indent = base_indent .. string.rep(" ", vim.fn.shiftwidth())

  local lines = { open_char }
  for _, child in ipairs(children) do
    table.insert(lines, inner_indent .. vim.treesitter.get_node_text(child, bufnr) .. ",")
  end
  table.insert(lines, base_indent .. close_char)

  vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, lines)
end

function vim.flxg.run_line()
  local lnum = vim.fn.line('.')
  local lines = {}
  while true do
    local line = vim.fn.getline(lnum)
    if line:sub(-1) == '\\' then
      table.insert(lines, line:sub(1, -2))
      lnum = lnum + 1
    else
      table.insert(lines, line)
      break
    end
  end
  local cmd = table.concat(lines, ' ')
  local output = vim.fn.systemlist(cmd)
  vim.cmd('new')
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end
