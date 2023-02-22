return {
	"akinsho/flutter-tools.nvim",
	ft = "dart",
	opts = {
		fvm = true, -- false if no fvm
		ui = { border = Config.border, notification_style = "native" },
		debugger = {
			enabled = true,
			run_via_dap = true,
			exception_breakpoints = {},
			-- register_configurations = function(_)
			-- 	require("dap").configurations.dart = {}
			-- 	require("dap.ext.vscode").load_launchjs()
			-- end,
		},
		widget_guides = { enabled = true },
		lsp = {
			color = {
				enabled = true,
				background = true,
				virtual_text = false,
			},
			settings = {
				showTodos = false,
				renameFilesWithClasses = "prompt",
				updateImportsOnRename = true,
				completeFunctionCalls = true,
				lineLength = 100,
			},
			on_attach = function(_, _)
				local mappings = {
					n = {
						["<leader>flc"] = { "<cmd>Telescope flutter commands<CR>" },
						["<leader>flv"] = { "<cmd>Telescope flutter fvm<CR>" },
					},
				}
				require("user.lsp_utils"):setup_lsp_essential(mappings)
			end,
		},
	},
}
