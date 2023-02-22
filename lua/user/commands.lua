---@diagnostic disable: param-type-mismatch
local user_commands = {
	ReloadConfig = {
		command = function()
			for name, _ in pairs(package.loaded) do
				if name:match "^user" and not name:match "^user.lazy" then
					package.loaded[name] = nil
				end
			end
			dofile(vim.env.MYVIMRC)
		end,
		opts = {
			desc = "reload neovim config",
		},
	},
	FugitiveWindowOnly = {
		command = function()
			local current_tab_detail = UserUtils.get_current_tab_detail()
			for winid, tbl in pairs(current_tab_detail) do
				if tbl.ft == "fugitive" then
					vim.api.nvim_set_current_win(winid)
					vim.cmd "wincmd o"
				end
			end
		end,
		opts = { desc = "close fugitive diff" },
	},
	QuickfixToggle = {
		command = function()
			local current_tab_detail = UserUtils.get_current_tab_detail()
			for _, tbl in pairs(current_tab_detail) do
        -- stylua: ignore
				if tbl.ft == "qf" then vim.cmd.cclose() return end
			end
			vim.cmd.copen()
		end,
		opts = { desc = "toggle quickfix" },
	},
}

for command_name, prop in pairs(user_commands) do
	vim.api.nvim_create_user_command(command_name, prop.command, prop.opts)
end
