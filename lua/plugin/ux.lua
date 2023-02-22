-- stylua: ignore
local harpoon_keys = {
  { "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end },
  { "<leader>a", function() require("harpoon.mark").add_file() end },
}

for i = 1, 9 do
  -- stylua: ignore
	table.insert(harpoon_keys, {
    "<leader>".. i, function() require("harpoon.ui").nav_file(i) end,
	})
end

return {
	{
		"folke/todo-comments.nvim",
		keys = { { "<leader>st", "<CMD>TodoTelescope<CR>" } },
		config = true,
	},
	{
		"echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = { { "<leader>x", function() require("mini.bufremove").delete(0, false) end }, },
	},
	{
		"Shatur/neovim-session-manager",
		lazy = false,
		keys = {
			{ "<leader>sl", "<CMD>SessionManager load_session<CR>" },
			{ "<leader>sd", "<CMD>SessionManager delete_session<CR>" },
		},
		config = function()
			local home_path = os.getenv "HOME"
			local config_path = vim.fn.stdpath "config"
			require("session_manager").setup {
				-- Possible values: Disabled, CurrentDir, LastSession
				autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir,
				autosave_ignore_dirs = {
					"/",
					config_path .. "/*",
					config_path .. "/*/*",
					config_path .. "/*/*/*",
					home_path,
					home_path .. "/Documents",
					home_path .. "/Documents/*",
					home_path .. "/Downloads",
					home_path .. "/Downloads/*",
					home_path .. "/.local/bin",
				},
			}
		end,
	},
	{
		"ThePrimeagen/harpoon",
		keys = harpoon_keys,
		config = function()
			require("harpoon").setup {
				menu = {
					borderchars = {
						Config.border[2],
						Config.border[4],
						Config.border[6],
						Config.border[8],
						Config.border[1],
						Config.border[3],
						Config.border[5],
						Config.border[7],
					},
				},
			}
		end,
	},
	{
		"ethanholz/nvim-lastplace",
		opts = {
			lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
			lastplace_ignore_filetype = {
				"fugitive",
				"gitcommit",
				"gitrebase",
				"svn",
				"hgcommit",
				"fugitive",
				"DiffviewFiles",
				"DiffviewFileHistory",
			},
			lastplace_open_folds = true,
		},
	},
}
