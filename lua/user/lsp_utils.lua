local M = {}

---@param extra_mappings table|nil
function M:setup_lsp_essential(extra_mappings)
	local mappings = {
		n = {
			["<leader>ra"] = { vim.lsp.buf.rename },
			K = { vim.lsp.buf.hover },
			["[d"] = { vim.diagnostic.goto_prev },
			["]d"] = { vim.diagnostic.goto_next },
			gD = { vim.lsp.buf.declaration },
			gR = { "<CMD>Telescope lsp_references<CR>" },
			gi = { "<CMD>Telescope lsp_implementations<CR>" },
			gd = { "<CMD>Telescope lsp_definitions<CR>" },
			["<leader>D"] = { "<CMD>Telescope lsp_type_definitions<CR>" },
			["<leader>pr"] = { "<CMD>Telescope diagnostics<CR>" },

			-- DAP
			["<F5>"] = { vim.cmd.DapContinue },
			["<F10>"] = { vim.cmd.DapStepOver },
			["<F11>"] = { vim.cmd.DapStepInto },
			["<F12>"] = { vim.cmd.DapStepOut },
			["<leader>bp"] = { vim.cmd.DapToggleBreakpoint },
			["<leader>dr"] = { vim.cmd.DapToggleRepl },
		},

		[{ "n", "v" }] = {
			["<leader>ca"] = { vim.lsp.buf.code_action },
			["<leader>fm"] = { vim.lsp.buf.format },
		},
	}

	if extra_mappings ~= nil then
		for mode, mode_table in pairs(extra_mappings) do
			for keymap, mapping_info in pairs(mode_table) do
				mappings[mode][keymap] = mapping_info
			end
		end
	end

	UserUtils.apply_mapping_table(mappings)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = Config.border })
	vim.diagnostic.config { float = { border = Config.border }, virtual_text = true }
end

M.ensure_installed = {
	lsp = {
		"astro",
		"bashls",
		"cssls",
		"emmet_ls",
		"gopls",
		"dockerls",
		"html",
		"intelephense",
		"jsonls",
		"marksman",
		"pyright",
		"texlab",
		"lua_ls",
		"svelte",
		"tailwindcss",
		"taplo",
		-- "rust_analyzer", -- handled by rust-tools
		-- "tsserver", -- handled by typescript plugin
		"vimls",
		"vuels",
		"yamlls",
	},
	treesitter = {
		"astro",
		"bash",
		"css",
		"dart",
		"dockerfile",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"go",
		"help",
		"html",
		"javascript",
		"jsdoc",
		"json",
		"jsonc",
		"lua",
		"markdown",
		"markdown_inline",
		"mermaid",
		"org",
		"php",
		"phpdoc",
		"python",
		"regex",
		"rust",
		"svelte",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vue",
		"yaml",
	},
}

return M
