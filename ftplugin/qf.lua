vim.opt_local.relativenumber = false
vim.cmd "wincmd J"

local min_height = 3
local max_height = 10
local lines = vim.fn.line "$"
local height = vim.fn.max { vim.fn.min { lines, max_height }, min_height }
vim.api.nvim_win_set_height(0, height)

local function return_to_qf()
	for winid, tbl in pairs(UserUtils.get_current_tab_detail()) do
    -- stylua: ignore
    if tbl.ft == "qf" then vim.api.nvim_set_current_win(winid) end
	end
end

local opts = { silent = true, buffer = true }
UserUtils.apply_mapping_table {
	n = {
		["<C-j>"] = { "<CMD>cnext|wincmd j<CR>", opts },
		["<C-k>"] = { "<CMD>cprev|wincmd j<CR>", opts },
		["<CR>"] = { "<CR><CMD>cclose<CR>", opts },
		q = { "<CMD>cclose<CR>", opts },
		o = { "<CR>", opts },
    -- stylua: ignore
    gg = { function() vim.cmd "cfirst" return_to_qf() end, opts },
    -- stylua: ignore
    G = { function() vim.cmd "clast" return_to_qf() end, opts },
    -- stylua: ignore
    ["<Tab>"] = { function() vim.cmd "normal o" return_to_qf() end, opts },
	},
}
