local ui = require("ascii-ui")
local For = require("ascii-ui.components.for")
local TodoItem = require("ascii-todolist.components.TodoItem")

--- @alias TodoListProps { todos: fun(): string[] }

--- @param props TodoListProps
local function TodoList(props)
	return For({
		items = props.todos,
		transform = function(item)
			return {
				content = item,
			}
		end,
		component = TodoItem,
	})
end

return ui.createComponent("TodoItem", TodoList)
