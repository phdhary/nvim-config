local spec = {
	"nvim-treesitter/nvim-treesitter",
	event = "BufRead",
	build = function()
		local ts_update = require("nvim-treesitter.install").update {
			with_sync = true,
		}
		ts_update()
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects", -- add more textobject
		"JoosepAlviste/nvim-ts-context-commentstring", -- correcting tsx & jsx comment
		"windwp/nvim-ts-autotag",
		{
			"nvim-treesitter/nvim-treesitter-context", -- provide context for nested code
			opts = {
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
				trim_scope = "outer",
				min_window_height = 15, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
			},
		},
	},
}

function spec.config()
	local ensure_installed = require("user.lsp_utils").ensure_installed.treesitter
	require("nvim-treesitter.configs").setup {
		ensure_installed = ensure_installed,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { "org" },
		},
		context_commentstring = {
			enable = true,
			enable_autocmd = false,
		},
		matchup = {
			enable = true, -- mandatory, false will disable the whole extension
			-- disable = { "c", "ruby" }, -- optional, list of language that will be disabled
			disable_virtual_text = true,
		},
		autotag = { enable = true },
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = {
						query = "@class.inner",
						desc = "Select inner part of a class region",
					},
				},
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
				include_surrounding_whitespace = true,
			},
		},
	}
end

return spec
