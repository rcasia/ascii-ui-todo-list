local ui = require("ascii-ui")
local For = ui.components.For
local TodoItem = require("ascii-todolist.components.TodoItem")
local Column = ui.layout.Column
local Paragraph = ui.components.Paragraph
local Button = ui.components.Button
local If = ui.components.If
local useTodos = require("ascii-todolist.components.useTodos")

--- @alias Todo { id?: string, done: boolean, description: string }


local function TodoList()
	local todo_list = {
		{ id = 1, done = true, description = "Todo 1" },
	}
	local todos, add_todo, toggle_todo, done_count = useTodos(todo_list)

	return function()
		return Column(
			Paragraph({
				content = ("My Today Tasks! (%d/%d)"):format(done_count(), #todos()),
			}),
			--
			Button({
				label = "Add Todo",
				on_press = function()
					local new_todo = vim.fn.input("new todo: ")

					add_todo({
						done = false,
						description = new_todo,
					})
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
							content = item.description,
							done = item.done or false,
							toggle = function()
								toggle_todo(item.id)
							end,
						}
					end,
					component = TodoItem,
				}),
			})
		)
	end
end

return ui.createComponent("TodoList", TodoList)
