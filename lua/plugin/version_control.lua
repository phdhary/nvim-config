return {
	{
		"tpope/vim-fugitive",
		event = "VeryLazy",
		config = function()
			vim.g.fugitive_summary_format = "(%an)\t%s"
		end,
		keys = {
			{ "<leader>gg", "<CMD>tab G<CR>" },
			-- { "<leader>gh", "<CMD>tab split|0Gclog|wincmd j<CR>" },
			{ "<leader>glq", "<CMD>tabnew|Gclog<CR>" },
			{ "<leader>glo", "<CMD>G log --oneline --decorate<CR>" },
			{ "<leader>glg", "<CMD>tab G log --oneline --decorate --all --graph<CR>" },
			{ "<leader>grl", "<CMD>G reflog<CR>" },
			-- {"<leader>gsl" ,  "<CMD>tabnew|Gclog -g stash<CR>" ,},
			{ "<leader>gb", "<CMD>G blame --date=human<CR>" },
			{ "<leader>dq", vim.cmd.FugitiveWindowOnly },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 300,
				ignore_whitespace = true,
			},
			current_line_blame_formatter = "      <author>, <author_time:%R> • <summary>",
			current_line_blame_formatter_nc = "      You, <author_time:%R> • <author>",
			preview_config = { border = Config.border },
		},
	},
	{
		"sindrets/diffview.nvim",
		event = "BufRead",
		keys = {
			{ "<leader>gh", "<CMD>DiffviewFileHistory %<CR>" },
			{ "<leader>gld", vim.cmd.DiffviewFileHistory },
			{ "<leader>dv", vim.cmd.DiffviewOpen },
		},
		config = function()
			local git = UserUtils.hydra.git()
			require("diffview").setup {
				enhanced_diff_hl = true,
				show_help_hints = false,
				file_panel = { listing_style = "list" },
				commit_log_panel = {
					win_config = function()
						local lines = vim.fn.getbufvar(0, "&lines")
						local height = vim.fn.float2nr(lines * 0.6)
						local cols = vim.fn.getbufvar(0, "&columns")
						return { type = "float", border = Config.border, height = height, width = cols }
					end,
				},
				keymaps = {
					view = { { "n", "q", require("diffview.actions").close, { desc = "close diffview" } } },
					file_panel = {
						{ "n", "q", require("diffview.actions").close, { desc = "close diffview" } },
					},
					file_history_panel = {
						{ "n", "q", require("diffview.actions").close, { desc = "close diffview" } },
					},
				},
				view = {
					merge_tool = {
						layout = "diff3_mixed",
						disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
						winbar_info = true, -- See |diffview-config-view.x.winbar_info|
					},
				},
				hooks = {
					view_enter = function(view)
						if view.panel.bufname == "DiffviewFileHistoryPanel" then
							local min_height = 3
							local max_height = 10
							local lines = vim.fn.line "$"
							local height = vim.fn.max { vim.fn.min { lines + 3, max_height }, min_height }
							vim.api.nvim_win_set_height(0, height)
							return
						end
						git:activate()
					end,
					view_leave = function()
						git.layer:exit()
						git:exit()
					end,
				},
			}
		end,
	},
}
