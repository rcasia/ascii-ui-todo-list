local ui = require("ascii-ui")
local TodoList = require("ascii-todolist.components.TodoList")

local M = {}

M.open = function()
	local App = function()
		return TodoList()
	end
	ui.mount(App())
end

setmetatable(M, {
	__call = function(_, opts)
		opts = opts or {}
		return M
	end,
})

-- TODO: remove this
M.open()

return M
