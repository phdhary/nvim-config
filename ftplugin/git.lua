pcall(vim.cmd.IndentBlanklineDisable)
UserUtils.apply_mapping_table {
	n = {
		["<C-v>"] = { "<Plug>fugitive:gO", { buffer = true } },
		["<C-x>"] = { "<Plug>fugitive:o", { buffer = true } },
		["<C-t>"] = { "<Plug>fugitive:O", { buffer = true } },
	},
}

