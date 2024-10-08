return {
	"neovim/nvim-lspconfig",
	opts = {
		-- make sure mason installs the server
		servers = {
			---@type lspconfig.options.tsserver
			vtsls = {
				keys = {
					{
						"<leader>co",
						function()
							vim.lsp.buf.code_action({
								apply = true,
								context = {
									only = { "source.organizeImports.ts" },
									diagnostics = {},
								},
							})
						end,
						desc = "Organize Imports",
					},
					{
						"<leader>cR",
						function()
							vim.lsp.buf.code_action({
								apply = true,
								context = {
									only = { "source.removeUnused.ts" },
									diagnostics = {},
								},
							})
						end,
						desc = "Remove Unused Imports",
					},
				},
				---@diagnostic disable-next-line: missing-fields
				settings = {
					completions = {
						completeFunctionCalls = true,
					},
				},
			},
		},
	},
}
