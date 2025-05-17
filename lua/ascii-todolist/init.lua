local ui = require("ascii-ui")
local Paragraph = ui.components.Paragraph
local For = require("ascii-ui.components.for")
local If = require("ascii-ui.components.if")
local Button = ui.components.Button
local TodoItem = require("ascii-todolist.components.TodoItem")

local M = {}

M.todos = {}

M.open = function()
	local App = function()
		local todos, setTodos = ui.hooks.useState(M.todos)

		return ui.layout(
			--
			If({
				condition = function()
					return #todos() > 0
				end,
				child = For({
					items = todos,
					transform = function(item)
						return {
							content = item,
						}
					end,
					component = TodoItem,
				}),
				fallback = Paragraph({
					content = "No todos available",
				}),
			}),
			Button({
				label = "Add Todo",
				on_press = function()
					local new_todo = vim.fn.input("new todo: ")
					M.todos[#M.todos + 1] = new_todo

					setTodos(M.todos)
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
