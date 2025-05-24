local ui = require("ascii-ui")

--- @alias TodoItemProps { content: string }

--- @param props TodoItemProps
local function TodoItem(props)
	return ui.components.Paragraph({ content = props.content })
end

return ui.createComponent("TodoItem", TodoItem, { content = "string" })
