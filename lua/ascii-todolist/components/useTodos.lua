local ui = require("ascii-ui")
local useReducer = ui.hooks.useReducer

--- @param initial_todos Todo[]
--- @return fun(): Todo[] todos
--- @return fun(new_todo: Todo) add_todo
--- @return fun(id: string)  toggle_todo
--- @return fun(): number done_count
local useTodos = function(initial_todos)
	local todos, dispatch = useReducer(function(state, action)
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

return useTodos
