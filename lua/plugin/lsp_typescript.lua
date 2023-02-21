local spec = {
	"jose-elias-alvarez/typescript.nvim",
	lazy = true,
	dependencies = "nvim-lspconfig",
	ft = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	opts = {
		disable_commands = false, -- prevent the plugin from creating Vim commands
		debug = false, -- enable debug logging for commands
		go_to_source_definition = {
			fallback = true, -- fall back to standard LSP definition on failure
		},
		server = { -- pass options to lspconfig's setup method
			on_attach = function(client, _)
				require("user.lsp_utils"):setup_lsp_essential()
				client.server_capabilities.document_formatting = false
			end,
		},
	},
}

--[[ function spec.config()
	require("typescript").setup {
		disable_commands = false, -- prevent the plugin from creating Vim commands
		debug = false, -- enable debug logging for commands
		go_to_source_definition = {
			fallback = true, -- fall back to standard LSP definition on failure
		},
		server = { -- pass options to lspconfig's setup method
			on_attach = function(client,_)
				require("user.lsp_utils"):setup_lsp_essential()
        client.server_capabilities.document_formatting = false
			end,
		},
	}
end ]]

return spec
