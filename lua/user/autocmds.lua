local autocmd = vim.api.nvim_create_autocmd
local group = "General"
vim.api.nvim_create_augroup(group, { clear = false })

autocmd("TermOpen", {
	group = group,
	callback = function()
		vim.opt_local.nu = false
		vim.opt_local.rnu = false
		vim.cmd "startinsert!"
	end,
	desc = "terminal things",
})

autocmd("TextYankPost", {
	group = group,
  -- stylua: ignore
  callback = function() vim.highlight.on_yank() end,
	desc = "highlight on copy",
})

autocmd("FileType", {
	group = group,
	pattern = "checkhealth,git,help,spectre_panel,dap-float",
	callback = function()
		vim.keymap.set("n", "q", "ZQ", { buffer = true })
	end,
	desc = "Common Exit",
})

AutoSaveFlag = false
autocmd("CursorHold", {
	group = group,
	pattern = "*.*",
	callback = function()
    -- stylua: ignore
    if not AutoSaveFlag then return end
		local filename = vim.fn.expand "%"
		if
			vim.bo.modifiable -- is modifiable
			and not (filename ~= "" and vim.bo.buftype == "" and vim.fn.filereadable(filename) == 0) -- not a new file
			and not (filename == "") -- not an unnamed file
			and not vim.bo.readonly -- not readonly
		then
			vim.cmd.update()
		end
	end,
	desc = "autosaver",
})

autocmd("ColorScheme", {
	group = group,
	callback = function()
		UserUtils.kitty:auto()
		local set_hl = vim.api.nvim_set_hl
		-- nvim-tree hl to neo-tree
		set_hl(0, "NeoTreeDirectoryIcon", { link = "NvimTreeFolderIcon" })
		set_hl(0, "NeoTreeDirectoryIcon", { link = "NvimTreeFolderIcon" })
		set_hl(0, "NeoTreeDirectoryName", { link = "NvimTreeFolderName" })
		set_hl(0, "NeoTreeSymbolicLinkTarget", { link = "NvimTreeSymlink" })
		set_hl(0, "NeoTreeRootName", { link = "NvimTreeRootFolder" })
		set_hl(0, "NeoTreeDirectoryName", { link = "NvimTreeOpenedFolderName" })
		set_hl(0, "NeoTreeFileNameOpened", { link = "NvimTreeOpenedFile" })
		-- float border
		set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
		set_hl(0, "NullLsInfoBorder", { link = "FloatBorder" })
		set_hl(0, "HarpoonBorder", { link = "FloatBorder" })
		-- hydra
		set_hl(0, "HydraHint", { link = "NormalFloat" })
		set_hl(0, "HydraBorder", { link = "FloatBorder" })
		set_hl(0, "HydraRed", { fg = "#ff5733" })
		set_hl(0, "HydraBlue", { fg = "#5ebcf6" })
		set_hl(0, "HydraAmaranth", { fg = "#ff1757" })
		set_hl(0, "HydraTeal", { fg = "#00a1a1" })
		set_hl(0, "HydraPink", { fg = "#ff55de" })

		local colors = vim.g.colors_name
		if colors:match ".*bones" or colors == "zenwritten" or colors == "zenburned" or colors == "vscode" then
			set_hl(0, "Function", { bold = true })
			set_hl(0, "Number", {})
			set_hl(0, "Constant", {})
			set_hl(0, "String", {})
			set_hl(0, "NormalFloat", { link = "Normal" })
		end
	end,
	desc = "Auto kitty theme and adjust highlight",
})

autocmd("User", {
	group = group,
	pattern = "AlphaReady",
	callback = function()
		vim.opt.cmdheight = 0
		vim.opt.laststatus = 0
	end,
	desc = "Disable Statusline in Alpha",
})

autocmd("BufUnload", {
	group = group,
	pattern = "<buffer>",
	callback = function()
		vim.opt.cmdheight = 1
		vim.opt.laststatus = 3
	end,
	desc = "Enable Statusline",
})

autocmd("FileType", {
	group = group,
	pattern = "fugitive,git",
	callback = function(ctx)
		if vim.bo.ft == "fugitive" then
			vim.keymap.set("n", "D", function()
				local info = UserUtils.fugitive:get_info_under_cursor()
				if info then
					if #info.paths > 0 then
						vim.cmd(("DiffviewOpen --selected-file=%s"):format(vim.fn.fnameescape(info.paths[1])))
					elseif info.commit ~= "" then
						vim.cmd(("DiffviewOpen %s^!"):format(info.commit))
					end
				end
			end, { buffer = ctx.buf, desc = "diffview" })
		elseif vim.bo.ft == "git" then
			vim.keymap.set("n", "D", function()
				local cursor_word = vim.fn.expand "<cWORD>"
				vim.cmd(("DiffviewOpen %s^!"):format(cursor_word))
			end, { buffer = ctx.buf, desc = "diffview" })
		end
	end,
	desc = "fugitive: open Diffview for the item under the cursor",
})

autocmd("BufEnter", {
	group = group,
	pattern = "*.arb",
	callback = function()
		if vim.bo.filetype ~= "json" then
			vim.bo.filetype = "json"
		end
	end,
	desc = "turn .arb to json ft",
})
