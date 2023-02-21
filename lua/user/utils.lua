---@diagnostic disable: param-type-mismatch
UserUtils = {
	fugitive = {},
	kitty = {},
	hydra = {},
	mason_packages_path = vim.fn.stdpath "data" .. "/mason/packages",
}

---@param mappings table
function UserUtils.apply_mapping_table(mappings)
	for mode, mode_table in pairs(mappings) do
		for keybind, mapping_info in pairs(mode_table) do
			local options = { noremap = true }
			options = mapping_info[2] and vim.tbl_extend("force", options, mapping_info[2])
			vim.keymap.set(mode, keybind, mapping_info[1], options)
		end
	end
end

---@param autos table
function UserUtils.apply_autocmds(autos)
	for augroup_name, autocmd_events in pairs(autos) do
		vim.api.nvim_create_augroup(augroup_name, { clear = true })
		for events, opts in pairs(autocmd_events) do
			opts.group = augroup_name
			vim.api.nvim_create_autocmd(events, opts)
		end
	end
end

function UserUtils.get_current_tab_detail()
	local winlist = vim.api.nvim_tabpage_list_wins(0)
	local result = {}
	for _, winid in pairs(winlist) do
		local bufid = vim.api.nvim_win_get_buf(winid)
		result[winid] = { bufid = bufid, ft = vim.fn.getbufvar(bufid, "&filetype") }
	end
	return result
end

function UserUtils.reload_package_with_name(package_name)
	for module_name, _ in pairs(package.loaded) do
		if string.find(module_name, "^" .. package_name) then
			package.loaded[module_name] = nil
			require(module_name)
		end
	end
end

-- stylua: ignore
function UserUtils.kitty.run_kitty_cmd(kitty_theme_name)
  local file = io.open(os.getenv "HOME" .. "/.config/kitty/kitty.conf", "r")
  if file == nil then return end
  for line in file:lines() do if line == "# " .. kitty_theme_name then return end end
  vim.cmd(("silent exec '!kitty +kitten themes --cache-age -1 --reload-in all %s'"):format(kitty_theme_name))
end

-- stylua: ignore
function UserUtils.kitty:apply_by_bg(kitties)
  local bg = vim.o.bg
  if bg == "dark" then self.run_kitty_cmd(kitties.kitty_dark_theme)
  elseif bg == "light" then self.run_kitty_cmd(kitties.kitty_light_theme)
  end
end

function UserUtils.kitty:auto()
	local colors_name = vim.g.colors_name
	for colorscheme_name, kitties in pairs(self.map_colorscheme_with_kitty) do
		if colors_name == colorscheme_name then
			pcall(self.apply_by_bg, self, kitties)
			return
		end
		if colors_name:match ".*fly" or colors_name:match ".*fox" then
			pcall(self.run_kitty_cmd, colors_name)
		end
	end
end

UserUtils.kitty.map_colorscheme_with_kitty = {
	-- catppuccin = { kitty_dark_theme = "Catppuccin-Mocha", kitty_light_theme = "Catppuccin-Latte" },
	-- tokyonight = { kitty_dark_theme = "Tokyo Night Moon", kitty_light_theme = "Tokyo Night Day" },
	ayu = { kitty_dark_theme = "Ayu Mirage", kitty_light_theme = "Ayu Light" },
	["rose-pine"] = { kitty_dark_theme = "Rosé Pine", kitty_light_theme = "Rosé Pine Dawn" },
	kanagawa = { kitty_dark_theme = "Kanagawa", kitty_light_theme = "Kanagawa_light" },
	vscode = { kitty_dark_theme = "Vscode-dark", kitty_light_theme = "Vscode-light" },
	rosebones = { kitty_dark_theme = "Rosé Pine", kitty_light_theme = "Rosé Pine Dawn" },
	tokyobones = { kitty_dark_theme = "Tokyo Night Moon", kitty_light_theme = "Tokyo Night Day" },
	vimbones = { kitty_dark_theme = "", kitty_light_theme = "vimbones" },
	duckbones = { kitty_dark_theme = "duckbones", kitty_light_theme = "" },
	kanagawabones = { kitty_dark_theme = "kanagawabones", kitty_light_theme = "" },
	nordbones = { kitty_dark_theme = "Nord", kitty_light_theme = "" },
	forestbones = { kitty_dark_theme = "Everforest Dark Hard", kitty_light_theme = "Everforest Light Medium" },
	zenburned = { kitty_dark_theme = "zenburned", kitty_light_theme = "" },
}

function UserUtils.kitty.simple_name(name)
	UserUtils.kitty.map_colorscheme_with_kitty[name] =
		{ kitty_dark_theme = name .. "_dark", kitty_light_theme = name .. "_light" }
end

function UserUtils.fugitive.hide_long_path(fugitive_path)
	local hidefugitive = fugitive_path:sub(12)
	local hidehome = vim.fn.fnamemodify(hidefugitive, ":~")
	return hidehome
end

function UserUtils.fugitive.get_sid(file)
	file = file or "autoload/fugitive.vim"
	local script_entry = vim.api.nvim_exec("filter #vim-fugitive/" .. file .. "# scriptnames", true)
	local trimmed = string.gsub(script_entry, "^%s*(.-)%s*$", "%1")
	return tonumber(trimmed:match "^(%d+)")
end

function UserUtils.fugitive:get_info_under_cursor()
  -- stylua: ignore
  if vim.bo.ft ~= "fugitive" then return end
	return self.get_sid() and vim.call(("<SNR>%d_StageInfo"):format(self.get_sid()), vim.api.nvim_win_get_cursor(0)[1])
end

function UserUtils.hydra.git(invoke_on_body)
	local Hydra = require "hydra"
	-- local cmd = require("hydra.keymap-util").cmd
	local gitsigns = require "gitsigns"
	local opts = {
		name = "git mode",
		hint = [[_J_:next-hunk  _K_:prev-hunk  _S_tage-buffer  _s_tage-hunk  _u_ndo-stage  _p_review  toggle-_d_eleted  _b_lame  _B_lame-full  _r_eset-hunk  _<C-e>_exit]],
		config = {
			color = "pink",
			hint = {
				type = "cmdline",
				show_name = false,
			},
      -- stylua: ignore
      on_key = function() vim.wait(50) end,
			-- on_enter = function()
			-- vim.cmd "mkview"
			-- end,
			on_exit = function()
				-- vim.cmd "loadview"
				-- gitsigns.toggle_linehl(false)
				gitsigns.toggle_deleted(false)
			end,
		},
		mode = { "n", "x" },
		heads = {
			{
				"J",
				function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gitsigns.next_hunk()
					end)
					return "<Ignore>"
				end,
				{ expr = true, desc = "↑ hunk" },
			},
			{
				"K",
				function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gitsigns.prev_hunk()
					end)
					return "<Ignore>"
				end,
				{ expr = true, desc = "↓ hunk" },
			},
			{
				"s",
				function()
					local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
					if mode == "V" then -- visual-line mode
						local esc = vim.api.nvim_replace_termcodes(":", true, true, true)
						vim.api.nvim_feedkeys(esc, "x", false) -- exit visual mode
						vim.cmd "'<,'>Gitsigns stage_hunk"
					else
						vim.cmd "Gitsigns stage_hunk"
					end
				end,
				{ desc = "stage hunk" },
			},
			{ "u", gitsigns.undo_stage_hunk, { desc = "undo last stage" } },
			{ "S", gitsigns.stage_buffer, { desc = "stage buffer" } },
			{ "p", gitsigns.preview_hunk, { desc = " " } },
			{ "d", gitsigns.toggle_deleted, { nowait = true, desc = "toggle deleted" } },
			{ "b", gitsigns.blame_line, { desc = "blame" } },
      -- stylua: ignore
      { "B", function() gitsigns.blame_line { full = true } end, { desc = "blame show" } },
      { "r", gitsigns.reset_hunk, { desc = "reset hunk" } },
			-- { "g", cmd "G", { exit = true, nowait = true, desc = "󰊢 " } },
			-- { "c", cmd "G commit", { exit = true, nowait = true, desc = " " } },
			{ "<C-e>", nil, { exit = true, nowait = true, desc = " " } },
		},
	}

	if invoke_on_body then
		opts.body = "<leader>gm"
		opts.config.invoke_on_body = true
		opts.config.on_enter = function()
			gitsigns.toggle_linehl(true)
		end
		opts.config.on_exit = function()
			gitsigns.toggle_linehl(false)
			gitsigns.toggle_deleted(false)
		end
	end

	return Hydra(opts)
end
