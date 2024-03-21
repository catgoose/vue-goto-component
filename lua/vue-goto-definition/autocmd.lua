local config = require("vue-goto-definition.config")
local list = require("vue-goto-definition.list")

local M = {}

local lsp_definition = vim.lsp.buf.definition

function M.setup()
	local group = vim.api.nvim_create_augroup("VueGotoDefinition", { clear = true })
	local opts = config.get_opts()
	vim.api.nvim_create_autocmd({ "FileType" }, {
		pattern = opts.filetypes,
		group = group,
		callback = function()
			local on_list = {
				on_list = function(_list)
					list.process(_list, opts)
				end,
			}
			---@diagnostic disable-next-line: duplicate-set-field
			vim.lsp.buf.definition = function(opts)
				opts = opts or {}
				opts = vim.tbl_extend("keep", opts, on_list)
				lsp_definition(opts)
			end
		end,
	})
end

return M
