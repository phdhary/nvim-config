return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = {
			enabled = true, -- Set to false to disable the vim.ui.input implementation
			default_prompt = "Input:", -- Default prompt string
			prompt_align = "left", -- Can be 'left', 'right', or 'center'
			insert_only = false, -- When true, <Esc> will close the modal
			border = Config.border,
			win_options = {
				winblend = 0, -- Window transparency (0-100)
				wrap = false, -- Disable line wrapping
			},
			get_config = function(opts)
				return { min_width = string.len(opts.prompt) + 4 }
			end,
		},
		select = {
			enabled = true, -- Set to false to disable the vim.ui.select implementation
			backend = { "builtin", "telescope", "fzf", "nui" }, -- Priority list of preferred vim.select implementations
			builtin = {
				anchor = "NW",
				border = Config.border,
				relative = "editor", -- 'editor' and 'win' will default to being centered
				win_options = {
					winblend = 0, -- Window transparency (0-100)
				},
			},
			get_config = function(opts)
				if opts.kind == "codeaction" then
					return {
						backend = { "telescope" },
						telescope = require("telescope.themes").get_dropdown {},
						builtin = {
							anchor = "SW",
							border = Config.border,
							relative = "cursor",
							min_width = 0.2,
							min_height = 0,
						},
					}
				elseif opts.prompt:match ".*Session" or opts.kind == "mason.ui.language-filter" then
					local opt = {}
					if opts.prompt:match "^Delete" then
						opt = { initial_mode = "normal" }
					end
					return {
						backend = { "telescope" },
						telescope = require("telescope.themes").get_dropdown(opt),
					}
				end
			end,
		},
	},
}
