local ui = require("ascii-ui")
local Paragraph = ui.components.Paragraph
local For = require("ascii-ui.components.for")
local If = require("ascii-ui.components.if")
local Button = ui.components.Button

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
					component = Paragraph,
				}),
				fallback = Paragraph({
					content = "No todos available",
				}),
			}),
			Button({
				label = "Add Todo",
				on_press = function()
					M.todos[#M.todos + 1] = "Todo " .. #M.todos + 1

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
