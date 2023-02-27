local isZoomed = false
local mappings = {
	n = {
		["<C-u>"] = { "<C-u>zz" },
		["<C-d>"] = { "<C-d>zz" },
		J = { "mzJ`z" },
		n = { "nzzzv", { silent = true } },
		N = { "Nzzzv", { silent = true } },
		["<C-w>m"] = {
			function()
				if isZoomed then
					vim.cmd "vertical wincmd =|horizontal wincmd ="
					isZoomed = false
				else
					vim.cmd "resize|vertical resize"
					isZoomed = true
				end
			end,
		},
		["<leader>l"] = { vim.cmd.Lazy },
		["yoa"] = {
			function()
				AutoSaveFlag = not AutoSaveFlag
				vim.notify("auto save " .. (AutoSaveFlag and "on" or "off"))
			end,
		},
		["<Esc>"] = {
			function()
				if vim.api.nvim_win_get_config(0).relative ~= "" then
					vim.api.nvim_win_close(0, true)
				else
					vim.cmd.nohlsearch()
				end
			end,
		},
		["<C-c>"] = { ":%y+<CR>" },
		["<leader>wa"] = { vim.cmd.wa },
		["<leader>bn"] = { vim.cmd.enew },
		["<leader>qa"] = { "<CMD>quitall!<CR>" },
		["<leader>cn"] = { "<CMD>e $MYVIMRC | cd %:p:h<CR>" },
		["<leader>bca"] = { "<CMD>%bd|e#<CR>" },
		["<leader>qf"] = { vim.cmd.QuickfixToggle },
		Q = { "<nop>" },
		[",e"] = { ":e **/*<C-z><S-Tab>", },
	},
	[{ "i", "n" }] = {
		["<C-s>"] = { vim.cmd.update },
	},
	v = {
		J = { ":m '>+1<CR>gv=gv", { silent = true } },
		K = { ":m '<-2<CR>gv=gv", { silent = true } },
		["<"] = { "<gv" },
		[">"] = { ">gv" },
	},
	t = {
		["<C-e>"] = { [[<C-\><C-n>]] },
	},
	i = {
		["<Tab>"] = { "<Right>" },
		["<S-Tab>"] = { "<Left>" },
	},
}

UserUtils.apply_mapping_table(mappings)
