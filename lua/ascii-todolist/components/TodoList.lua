local ui = require("ascii-ui")
local For = ui.components.For
local TodoItem = require("ascii-todolist.components.TodoItem")
local Column = ui.layout.Column
local Paragraph = ui.components.Paragraph
local Button = ui.components.Button
local If = ui.components.If

--- @alias Todo { id?: string, done: boolean, description: string }

--- @param initial_todos Todo[]
--- @return fun(): Todo[] todos
--- @return fun(new_todo: Todo) add_todo
--- @return fun(id: string)  toggle_todo
--- @return fun(): number done_count
local useTodos = function(initial_todos)
	local todos, dispatch = ui.hooks.useReducer(function(state, action)
		if action.type == "add" then
			local id = #state + 1
			local new_todo = {
				id = id,
				done = action.params.new_todo.done or false,
				description = action.params.new_todo.description,
			}
			return vim.list_extend(state, { new_todo })
		elseif action.type == "toggle" then
			local id = action.params.id

			return vim.iter(state)
				:map(function(todo)
					if todo.id == id then
						todo.done = not todo.done
						return todo
					else
						return todo
					end
				end)
				:totable()
		else
			return state
		end
	end, initial_todos)

	local add_todo = function(new_todo)
		dispatch({ type = "add", params = { new_todo = new_todo } })
	end

	local toggle_todo = function(id)
		dispatch({
			type = "toggle",
			params = { id = id },
		})
	end

	local done_count = function()
		return vim.iter(todos())
			:filter(function(todo)
				return todo.done
			end)
			:fold(0, function(acc, _)
				return acc + 1
			end)
	end

	return todos, add_todo, toggle_todo, done_count
end

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
