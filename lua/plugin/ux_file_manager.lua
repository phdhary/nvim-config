vim.g.neo_tree_remove_legacy_commands = true

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v2.x",
	keys = {
		{ "<leader>e", "<CMD>Neotree reveal toggle<CR>" },
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"s1n7ax/nvim-window-picker",
			version = "v1.*",
			config = function()
				require("window-picker").setup {
					autoselect_one = true,
					include_current = false,
          fg_color = "white",
          other_win_hl_color = "black",
					filter_rules = {
						bo = {
							filetype = { "neo-tree", "neo-tree-popup", "notify" },
							buftype = { "terminal", "quickfix" },
						},
					},
				}
			end,
		},
	},
	opts = {
		hide_root_node = true,
		use_popups_for_input = false, -- If false, inputs will use vim.ui.input() instead of custom floats.
		default_component_configs = {
			modified = { symbol = " " },
			name = { use_git_status_colors = false },
			indent = {
				with_expanders = true,
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			git_status = {
				symbols = {
					-- Change type
					added = "A",
					deleted = "D",
					modified = "",
					renamed = "R",
					-- Status type
					untracked = "U",
					ignored = "I",
					unstaged = "M",
					staged = "M",
					conflict = "",
				},
			},
		},
		filesystem = {
			filtered_items = { visible = true },
			hijack_netrw_behavior = "disabled", -- open_default open_current disabled
		},
		window = {
			position = "left", -- current,float,right,left
			auto_expand_width = true,
			width = 0,
			mappings = {
				["<Tab>"] = function(state)
					local node = state.tree:get_node()
					if require("neo-tree.utils").is_expandable(node) then
						state.commands["toggle_node"](state)
					else
						state.commands["open"](state)
						vim.cmd "Neotree focus"
					end
				end,
				["o"] = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					-- Linux: open file in default application
					vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
				end,
				["i"] = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					vim.api.nvim_input(": " .. path .. "<Home>")
				end,
				["<Space>"] = "none",
				["s"] = "none",
				["S"] = "none",
				["H"] = "none",
				["<C-h>"] = "toggle_hidden",
				["<C-x>"] = "open_split",
				["<C-v>"] = "open_vsplit",
				["<C-t>"] = "open_tabnew",
			},
		},
	},
}
