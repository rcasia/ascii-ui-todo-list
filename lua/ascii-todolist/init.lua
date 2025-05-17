local ui = require("ascii-ui")
local If = require("ascii-ui.components.if")
local Button = ui.components.Button
local TodoList = require("ascii-todolist.components.TodoList")

local M = {}

M.open = function()
	local App = function()
		local todos, setTodos = ui.hooks.useState({ "Todo 1" })

		return ui.layout(
			--
			If({
				condition = function()
					return #todos() > 0
				end,
				child = TodoList({ todos = todos }),
			}),
			Button({
				label = "Add Todo",
				on_press = function()
					local new_todo = vim.fn.input("new todo: ")

					local _todos = todos()
					_todos[#_todos + 1] = new_todo
					setTodos(_todos)
				end,
			})
		)
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
