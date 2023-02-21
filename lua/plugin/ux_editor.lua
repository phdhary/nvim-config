return {
	{ "vim-scripts/ReplaceWithRegister", event = "BufRead" },
	{
		"junegunn/vim-peekaboo",
		event = "BufRead",
		enabled = true,
		config = function()
			-- vim.g.peekaboo_compact = 1
			-- vim.g.peekaboo_window = "vert topleft 30new"
		end,
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
		opts = {
			enable_backwards = false,
		},
		dependencies = { "nvim-cmp", "nvim-treesitter" }, -- if a completion plugin is using tabs load it before
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
				"andymass/vim-matchup",
				config = function()
					vim.g.matchup_matchparen_offscreen = {}
				end,
			}, -- improve % match capability
		},
	},
	{
		"ggandor/leap.nvim",
		event = "BufRead",
    -- stylua: ignore
    config = function() require("leap").add_default_mappings() end,
		dependencies = {
			--[[ "ggandor/flit.nvim",
      opts = {
        keys = { f = "f", F = "F", t = "t", T = "T" },
        labeled_modes = "v",
        multiline = true,
      }, ]]
			--[[ {
				"ggandor/leap-spooky.nvim",
				opts = {
					paste_on_remote_yank = false,
					affixes = {
						remote = { window = "r", cross_window = "R" },
						magnetic = { window = "m", cross_window = "M" },
					},
				},
			}, ]]
		},
	},
	--[[ {
		"phaazon/hop.nvim",
		config = function()
			require("hop").setup({
        -- hint_position = require("hop.hint").HintPosition.END
      })
		end,
		keys = {
			{ "s", "<CMD>HopChar2AC<CR>" },
			{ "S", "<CMD>HopChar2BC<CR>" },
			{ "gs", "<CMD>HopChar2MW<CR>" },
		},
	}, ]]
	-- {
	-- 	"ziontee113/SelectEase",
	-- 	config = function()
	-- 		local select_ease = require "SelectEase"
	--
	-- 		-- example query
	-- 		local query = [[
	--            ;; query
	--            ((identifier) @cap)
	--            ("string_content" @cap)
	--            ((true) @cap)
	--            ((false) @cap)
	--        ]]
	--
	-- 		-- next / previous node that matches the query
	-- 		vim.keymap.set({ "n", "s", "i" }, "<C-A-p>", function()
	-- 			select_ease.select_node { query = query, direction = "previous" }
	-- 		end, {})
	-- 		vim.keymap.set({ "n", "s", "i" }, "<C-A-n>", function()
	-- 			select_ease.select_node { query = query, direction = "next" }
	-- 		end, {})
	--
	-- 		-- "vertical drill jump"
	-- 		vim.keymap.set({ "n", "s", "i" }, "<C-A-k>", function()
	-- 			select_ease.select_node {
	-- 				query = query,
	-- 				direction = "previous",
	-- 				vertical_drill_jump = true,
	-- 			}
	-- 		end, {})
	-- 		vim.keymap.set({ "n", "s", "i" }, "<C-A-j>", function()
	-- 			select_ease.select_node {
	-- 				query = query,
	-- 				direction = "next",
	-- 				vertical_drill_jump = true,
	-- 			}
	-- 		end, {})
	--
	-- 		-- jump to targets only on current line
	-- 		vim.keymap.set({ "n", "s", "i" }, "<C-A-h>", function()
	-- 			select_ease.select_node {
	-- 				query = query,
	-- 				direction = "previous",
	-- 				current_line_only = true,
	-- 			}
	-- 		end, {})
	-- 		vim.keymap.set({ "n", "s", "i" }, "<C-A-l>", function()
	-- 			select_ease.select_node {
	-- 				query = query,
	-- 				direction = "next",
	-- 				current_line_only = true,
	-- 			}
	-- 		end, {})
	-- 	end,
	-- },
}
