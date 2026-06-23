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
