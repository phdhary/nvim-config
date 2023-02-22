return {
	{ "vim-scripts/ReplaceWithRegister", event = "BufRead" },
	{
		"junegunn/vim-peekaboo",
		event = "BufRead",
	},
	{
		"junegunn/vim-easy-align",
		event = "BufRead",
		config = function()
			UserUtils.apply_mapping_table {
				[{ "n", "v" }] = { ga = { "<Plug>(EasyAlign)" } },
			}
		end,
	},
	{ "windwp/nvim-autopairs", event = "BufRead", config = true },
	{ "nacro90/numb.nvim", event = "BufRead", config = true },
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "BufRead",
		config = true,
	},
	{
		"abecodes/tabout.nvim",
		event = "BufRead",
		opts = { enable_backwards = false },
		dependencies = { "nvim-cmp", "nvim-treesitter" },
	},
	{
		"windwp/nvim-spectre",
		keys = {
			{ "<leader>ss", vim.cmd.Spectre },
			{ "<leader>sw", "<CMD>lua require('spectre').open_visual({select_word=true})<CR>" },
			{ "<leader>sp", "<CMD>Spectre %<CR>" },
		},
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		version = "v0.7.*",
		event = "BufRead",
		config = function()
			require("Comment").setup {
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			}
		end,
		dependencies = {
			"nvim-ts-context-commentstring", -- correcting tsx & jsx comment
			{
				"andymass/vim-matchup", -- improve % match capability
				config = function()
					vim.g.matchup_matchparen_offscreen = {}
				end,
			},
		},
	},
	{
		"ggandor/leap.nvim",
		event = "BufRead",
    -- stylua: ignore
    config = function() require("leap").add_default_mappings() end,
	},
}
