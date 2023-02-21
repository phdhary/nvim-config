vim.opt_local.numberwidth = 3
vim.opt_local.nu = false
vim.opt_local.rnu = false
pcall(vim.cmd.IndentBlanklineDisable)
UserUtils.apply_mapping_table {
	n = {
		["<Tab>"] = { "<Plug>fugitive:=", { buffer = true } },
		["<C-j>"] = { "<Plug>fugitive:)", { buffer = true } },
		["<C-k>"] = { "<Plug>fugitive:(", { buffer = true } },
    ["<C-v>"] = { "<Plug>fugitive:gO", { buffer = true } },
    ["<C-x>"] = { "<Plug>fugitive:o", { buffer = true } },
    ["<C-t>"] = { "<Plug>fugitive:O", { buffer = true } },
    q = { "<Plug>fugitive:gq", { buffer = true } },
    dw = { "<Plug>fugitive:dv|:wincmd J<CR>", { silent = true, buffer = true } },
	},
}
