local ui = require("ascii-ui")
local Button = ui.components.Button
local Row = ui.layout.Row

--- @alias TodoItemProps { content: string, done: boolean, toggle: function }

--- @param props TodoItemProps
local function TodoItem(props)
	return Row(
		--
		Button({
			label = function()
				return props.done and "[x]" or "[ ]"
			end,
			on_press = function()
				if props.toggle then
					props.toggle()
				end
			end,
		}),
		ui.components.Paragraph({ content = props.content })
	)
end

return ui.createComponent("TodoItem", TodoItem, { content = "string", done = "boolean", toggle = "function" })
