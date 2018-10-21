local t = {}

local INTEGER, PLUS, MINUS, EOF = "INTEGER", "PLUS", "MINUS", "EOF"

function Token(type, value)
	local token = {}
	token.type = type
	token.value = value
	return token
end

function advance()
	t.pos = t.pos + 1
	if t.pos > string.len(t.text) then
		t.current_char = nil
	else
		t.current_char = string.sub(t.text, t.pos, t.pos)
	end
end

function eat(type)
	if t.current_token.type == type then
		t.current_token = get_next_token()
	end
end

function term()
	local token = t.current_token
	eat(INTEGER)
	return tonumber(token.value)
end

function integer()
	local result = ''
	while t.current_char ~= nil and tonumber(t.current_char) do
		result = result .. t.current_char
		advance()
	end
	return tonumber(result)
end

function skip_space()
	while t.current_char ~= nil and t.current_char ~= ' ' do
		advance()
	end
end

function get_next_token()
	while t.current_char ~= nil do
		if t.current_char == ' ' then
			skip_space()
		end

		if tonumber(t.current_char) then
			return Token(INTEGER, integer())
		end

		if t.current_char == "+" then
			advance()
			return Token(PLUS, "+")
		elseif t.current_char == "-" then
			advance()
			return Token(MINUS, "-")
		end
	end

	return Token(EOF, nil)
end

function init(text)
	t.pos = 1
	t.text = text
	t.current_char = string.sub(text, t.pos, t.pos)
	t.current_token = nil
end

function expr()
	t.current_token = get_next_token()
	local result = term()
	while t.current_token.type == PLUS or t.current_token.type == MINUS do
		if t.current_token.type == PLUS then
			eat(t.current_token.type)
			local v2 = term()
			print("expr", result, v2, t.current_char)
			result = result + v2
		elseif t.current_token.type == MINUS then
			eat(t.current_token.type)
			local v2 = term()
			result = result - v2
		end
	end

	return result
end

while true do
	local text = io.read()
	if text == "quit" then
		break
	elseif text ~= "" then
		init(text)
		local result = expr()	
		print("result: ", result)
	end
end