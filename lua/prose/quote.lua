local M = {}

--- Read the tags from the file.
--- @return string|nil
local function get_tags()
	local dir = vim.fs.dirname(debug.getinfo(1, "S").source:sub(2))
	local filename = vim.fs.joinpath(dir, "tags.txt")
	local file = io.open(filename, "r")

	if not file then
		print("Error: Could not open " .. filename)
		return nil
	end

	local words = {}

	for line in file:lines() do
		line = vim.trim(line)
		if line ~= "" then
			table.insert(words, line)
		end
	end

	file:close()

	local pattern = "(" .. table.concat(words, "|") .. ")"
	return pattern
end

local function choose_from_numbered_menu(options)
	if #options == 0 then
		return nil
	end

	if #options == 1 then
		return options[1]
	end

	local chunks = {
		{ "Select quotation:\n", "Normal" },
	}

	for i, option in ipairs(options) do
		table.insert(chunks, { i .. ". " .. option .. "\n", "Normal" })
	end

	table.insert(chunks, { "Type a number: ", "Question" })

	vim.api.nvim_echo(chunks, false, {})

	local key = vim.fn.getcharstr()
	local choice = tonumber(key)

	vim.cmd("redraw")

	if choice and options[choice] then
		return options[choice]
	end

	return nil
end

--- Applies regex patterns to the given line.
--- @param line string
--- @param tags string
--- @return string[]
local function do_the_regex_bro(line, tags)
	-- "You should know by now," she said, "that regex is dog water."
	local pattern_one = [[\v(.{-}[,?!])\s+(\w+\s+]] .. tags .. [[[\.,]|]] .. tags .. [[\s+\w+[\.,])\s+(.*)]]
	-- He sighed and said, "I know, Jane. I know."
	local pattern_two = [[\v(.{-}(]] .. tags .. [[),)\s+(.*)]]
	-- "Then why do you insist on using it?" she asked.
	local pattern_three = [[\v(.{-}[,?!])\s+(\w+\s+]] .. tags .. [[|]] .. tags .. [[\s+\w+)]]
	-- "I don't."
	local pattern_four = '"' .. line .. '"'

	local options = {}

	if vim.fn.match(line, pattern_one) ~= -1 then
		options[1] = vim.fn.substitute(line, pattern_one, [["\1" \2 "\5"]], "g")
	elseif vim.fn.match(line, pattern_two) ~= -1 then
		options[1] = vim.fn.substitute(line, pattern_two, [[\1 "\4"]], "g")
	elseif vim.fn.match(line, pattern_three) ~= -1 then
		options[1] = vim.fn.substitute(line, pattern_three, [["\1" \2]], "g")
	else
		options[1] = pattern_four
	end

	return options
end

--- Adds quotation marks to line.
function M:add_quotations()
	local tags = get_tags()
	if tags == nil then
		return
	end -- Not ideal, but w/e.

	local pattern = [[\v]] .. [[(\w+\s+]] .. tags .. [[)|(]] .. tags .. [[\s+\w)]]
	local line = vim.api.nvim_get_current_line()

	local choices = do_the_regex_bro(line, tags)
	local choice = choose_from_numbered_menu(choices)

	if choice then
		vim.api.nvim_set_current_line(choice)
	end
end

--- Adds quotation marks to selected lines.
--[[
function M:add_quotes_to_selection()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)

	local start_pos = vim.api.nvim_buf_get_mark(0, "<")
	local end_pos = vim.api.nvim_buf_get_mark(0, ">")
	local start_row = start_pos[1] - 1
	local end_row = end_pos[1]

	local tags = get_tags()
	if tags == nil then
		return
	end

	local pattern = [[\v]]
-- .. [[(\w+\s+]] .. tags .. [[)|(]] .. tags .. [[\s+\w)]]

--[[	
	local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
	if #lines == 0 then
		return
	end

	for i, line in ipairs(lines) do
		if vim.fn.match(line, pattern) ~= -1 then
			lines[i] = do_the_regex_bro(line, tags)
		elseif string.match(line, "^%s*$") then
		else
			lines[i] = '"' .. line .. '"'
		end
	end

	vim.api.nvim_buf_set_lines(0, start_row, end_row, false, lines)
end
--]]

return M
