return {
	{
		"loctvl842/monokai-pro.nvim",
		config = function()
			local hp = require "monokai-pro.color_helper"
			require("monokai-pro").setup {
				override = function(c)
					return {
						FloatBorder = { bg = c.base.black, fg = c.base.dimmed5 },
						DiffAdd = { fg = "NONE" },
						DiffChange = { fg = "NONE" },
						DiffDelete = { fg = "NONE" },
						DiffText = {
							bg = hp.blend(c.base.white, 0.05, c.diffEditor.modifiedLineBackground),
							fg = "NONE",
						},
					}
				end,
			}
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		opts = {
			transparent = Config.transparent,
			italic_comments = true,
		},
	},
	{
		"mcchrish/zenbones.nvim",
		config = function()
			vim.g.bones_compat = 1
			UserUtils.kitty.simple_name "zenbones"
			UserUtils.kitty.simple_name "neobones"
			UserUtils.kitty.simple_name "seoulbones"
			UserUtils.kitty.simple_name "zenwritten"
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		-- lazy = true,
		opts = {
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = { bold = true },
			keywordStyle = { bold = true },
			statementStyle = {},
			typeStyle = {},
			variablebuiltinStyle = { italic = true },
			specialReturn = true, -- special highlight for the return keyword
			specialException = true, -- special highlight for exception handling keywords
			transparent = Config.transparent, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			globalStatus = false, -- adjust window separators highlight for laststatus=3
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = {},
			overrides = {},
			theme = "default", -- Load "default" theme or the experimental "light" theme
		},
	},
	{
		"Shatur/neovim-ayu",
    -- lazy = true,
    -- stylua: ignore
    config = function() require("ayu").setup { mirage = true } end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		branch = "canary",
		-- lazy = true,
		config = function()
			local opts = {
				--- @usage 'main' | 'moon'
				dark_variant = "main",
				dim_nc_background = false,
				disable_background = Config.transparent,
				disable_float_background = not Config.use_different_float_background,
				highlight_groups = {
					["@variable"] = { italic = false },
					-- ["@function"] = { bold = true },
					["@function.builtin"] = { bold = true },
					["@function.macro"] = { bold = true },
					["@parameter"] = { italic = false, fg = "iris" },
					-- ["@property"] = { italic = false, fg = "rose" },
				},
			}
			if Config.border == "solid" and Config.use_different_float_background then
				opts.highlight_groups.FloatBorder = { bg = "surface" }
			end
			require("rose-pine").setup(opts)
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		-- lazy = true,
		opts = {
			options = {
				-- Compiled file's destination location
				compile_path = vim.fn.stdpath "cache" .. "/nightfox",
				compile_file_suffix = "_compiled", -- Compiled file suffix
				transparent = Config.transparent, -- Disable setting background
				terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
				dim_inactive = false, -- Non focused panes set to alternative background
				module_default = true, -- Default enable value for modules
				modules = {
					neotree = { enable = false },
				},
				styles = { -- Style to be applied to different syntax groups
					comments = "italic", -- Value is any valid attr-list value `:help attr-list`
					conditionals = "bold",
					constants = "NONE",
					functions = "bold",
					keywords = "bold",
					numbers = "NONE",
					operators = "bold",
					strings = "NONE",
					types = "NONE",
					variables = "NONE",
				},
				inverse = { -- Inverse highlight for different types
					match_paren = false,
					visual = false,
					search = false,
				},
			},
		},
	},
	{
		"bluz71/vim-nightfly-colors",
		-- lazy = true,
		config = function()
			vim.g.nightflyWinSeparator = 2
			vim.g.nightflyNormalFloat = not Config.use_different_float_background
			vim.g.nightflyTransparent = Config.transparent
			vim.g.nightflyVirtualTextColor = false
		end,
	},
	{
		"bluz71/vim-moonfly-colors",
		-- lazy = true,
		config = function()
			vim.g.moonflyWinSeparator = 2
			vim.g.moonflyNormalFloat = not Config.use_different_float_background
			vim.g.moonflyTransparent = Config.transparent
			vim.g.moonflyVirtualTextColor = false
		end,
	},
}
