local ui = require("ascii-ui")
local For = ui.directives.For
local TodoItem = require("ascii-todolist.components.TodoItem")
local Column = ui.layout.Column
local Paragraph = ui.components.Paragraph
local Button = ui.components.Button
local If = ui.directives.If

local function TodoList()
	local todos, setTodos = ui.hooks.useState({ "Todo 1" })

	return function()
		return Column(
			Paragraph({
				content = function()
					local count = #todos()
					return ("My Today Tasks! (%d/%d)"):format(0, count)
				end,
			}),
			--
			Button({
				label = "Add Todo",
				on_press = function()
					local new_todo = vim.fn.input("new todo: ")

					local _todos = todos()
					_todos[#_todos + 1] = new_todo
					setTodos(_todos)
				end,
			}),

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
			})
		)
	end
end

return ui.createComponent("TodoList", TodoList)
