return {
	--[[ {
		"nvim-orgmode/orgmode",
		event = "BufRead",
		config = function()
			require("orgmode").setup {
				org_agenda_files = { "~/Documents/org/*" },
				org_default_notes_file = "~/Documents/org/refile.org",
			}
			require("orgmode").setup_ts_grammar()
			vim.opt.conceallevel = 2
			vim.opt.concealcursor = "nc"
		end,
		dependencies = {
			{ "akinsho/org-bullets.nvim", config = true },
		},
	}, ]]
	{
		"vimwiki/vimwiki",
		event = "BufRead",
		init = function()
			vim.g.vimwiki_global_ext = 0
			vim.g.vimwiki_list = {
				{
					path = os.getenv "HOME" .. "/Documents/vimwiki/",
					syntax = "markdown",
					ext = ".md",
				},
			}
			vim.api.nvim_create_augroup("CustomVimWiki", {})
			vim.api.nvim_create_autocmd("FileType", {
				group = "CustomVimWiki",
				pattern = "vimwiki",
				callback = function()
					vim.bo.ft = "markdown.vimwiki"
				end,
			})
		end,
	},
	--[[ {
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		enabled = false,
		event = "VeryLazy",
    dependencies = {"nvim-treesitter"}
		opts = {
			load = {
				["core.defaults"] = {}, -- Loads default behaviour
				["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
				["core.norg.completion"] = {
					config = {
						engine = "nvim-cmp",
					},
				},
				["core.export"] = {},
				["core.integrations.treesitter"] = {
					config = {
						configure_parsers = true,
						install_parsers = true,
					},
				},
				["core.export.markdown"] = {},
				["core.norg.dirman"] = { -- Manages Neorg workspaces
					config = {
						workspaces = {
							myorg = "~/Documents/org",
						},
					},
				},
			},
		},
		dependencies = { { "nvim-lua/plenary.nvim" } },
	}, ]]
}
