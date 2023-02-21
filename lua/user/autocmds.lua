local autos = {
	BasicStuff = {},
	AlphaStuff = {},
	MyExperimentalAutos = {},
}

autos.BasicStuff.TermOpen = {
	callback = function()
		vim.opt_local.nu = false
		vim.opt_local.rnu = false
		vim.cmd "startinsert!"
	end,
	desc = "terminal things",
}

autos.BasicStuff.TextYankPost = {
  -- stylua: ignore
  callback = function() vim.highlight.on_yank() end,
	desc = "highlight on copy",
}

autos.BasicStuff.FileType = {
	pattern = "checkhealth,git,help,spectre_panel,dap-float",
	callback = function()
		vim.keymap.set("n", "q", "ZQ", { buffer = true })
	end,
	desc = "Common Exit",
}

AutoSaveFlag = false
autos.BasicStuff.CursorHold = {
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
}

autos.BasicStuff.ColorScheme = {
	callback = function()
		UserUtils.kitty:auto()
		-- nvim-tree hl to neo-tree
		vim.cmd [[
    highlight! link NeoTreeDirectoryIcon NvimTreeFolderIcon
    highlight! link NeoTreeDirectoryName NvimTreeFolderName
    highlight! link NeoTreeSymbolicLinkTarget NvimTreeSymlink
    highlight! link NeoTreeRootName NvimTreeRootFolder
    highlight! link NeoTreeDirectoryName NvimTreeOpenedFolderName
    highlight! link NeoTreeFileNameOpened NvimTreeOpenedFile
    highlight! link LspInfoBorder FloatBorder
    highlight! link NullLsInfoBorder FloatBorder
    highlight! link HarpoonBorder FloatBorder
    highlight! link HydraHint NormalFloat
    highlight! link HydraBorder FloatBorder
    highlight! HydraRed guifg=#ff5733
    highlight! HydraBlue guifg=#5ebcf6
    highlight! HydraAmaranth guifg=#ff1757
    highlight! HydraTeal guifg=#00a1a1
    highlight! HydraPink guifg=#ff55de
    ]]
		local colors = vim.g.colors_name
		if colors:match ".*bones" or colors == "zenwritten" or colors == "zenburned" then
			vim.cmd [[
      highlight! Number gui=NONE 
      highlight! Constant gui=NONE
      highlight! String gui=NONE
      highlight! Function gui=bold
      highlight! link NormalFloat Normal
      ]]
		end
	end,
	desc = "Kitty theme follow vim colorscheme or bg",
}

autos.AlphaStuff.User = {
	pattern = "AlphaReady",
	callback = function()
		vim.opt.cmdheight = 0
		vim.opt.laststatus = 0
	end,
	desc = "Disable Statusline in Alpha",
}

autos.AlphaStuff.BufUnload = {
	pattern = "<buffer>",
	callback = function()
		vim.opt.cmdheight = 1
		vim.opt.laststatus = 3
	end,
	desc = "Enable Statusline",
}

autos.MyExperimentalAutos.FileType = {
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
}

autos.MyExperimentalAutos.BufEnter = {
	pattern = "*.arb",
	callback = function()
		if vim.bo.filetype ~= "json" then
			vim.bo.filetype = "json"
		end
	end,
}

UserUtils.apply_autocmds(autos)
