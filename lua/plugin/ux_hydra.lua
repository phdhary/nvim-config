local spec = {
	"anuvyklack/hydra.nvim",
	event = "BufRead",
	dependencies = "mrjones2014/smart-splits.nvim",
}

function spec.config()
	local Hydra = require "hydra"
	local config = { hint = false, timeout = true }
	local cmd = require("hydra.keymap-util").cmd

	Hydra {
    -- stylua: ignore
    config = vim.tbl_extend("force", config, { on_exit = function() pcall(vim.cmd.IndentBlanklineRefresh) end }),
		mode = "n",
		body = "z",
		heads = {
			{ "h", "5zh", { desc = "←" } },
			{ "l", "5zl", { desc = "→" } },
			{ "H", "zH", { desc = "half screen ←" } },
			{ "L", "zL", { desc = "half screen →" } },
		},
	}

	Hydra {
		config = config,
		mode = "n",
		body = "<C-w>",
		heads = {
			{ "<", "2<C-w><", { desc = "width +" } },
			{ ">", "2<C-W>>", { desc = "width -" } },
			{ "_", "2<C-w>-", { desc = "height -" } },
			{ "+", "2<C-W>+", { desc = "height +" } },
			{ "H", "<C-w>H", { desc = "move ←" } },
			{ "J", "<C-w>J", { desc = "move ↓" } },
			{ "K", "<C-w>K", { desc = "move ↑" } },
			{ "L", "<C-w>L", { desc = "move →" } },
			{ "s", "<C-w>s", { desc = "split horizontal" } },
			{ "v", "<C-w>v", { desc = "split vertical" } },
			{ "x", "<C-w>x", { desc = "rotate" } },
			{ "r", "<C-w>r", { desc = "rotate" } },
			{ "R", "<C-w>R", { desc = "rotate" } },
			{ "j", require("smart-splits").resize_down, { desc = "resize ↓" } },
			{ "k", require("smart-splits").resize_up, { desc = "resize ↑" } },
      -- stylua: ignore
      { "h", function() require("smart-splits").resize_left(8) end, { desc = "resize ←" } },
      -- stylua: ignore
      { "l", function() require("smart-splits").resize_right(8) end, { desc = "resize →" } },
		},
	}

	local dap = require "dap"
	Hydra {
		name = "debug mode",
		hint = [[
         
 _c_ _p_ _K_ _J_ _H_ _L_ _R_ _x_

toggle _r_epl
toggle _u_i
_t_oggle breakpoint
clear breakpoin_T_s
_gh_over
_<Up>_ w/o step
_<Down>_ w/o step

_o_pen commands
_<C-e>_exit]],
		config = {
			invoke_on_body = true,
			color = "pink",
			hint = { show_name = false, type = "window", position = "middle-right", border = Config.border },
		},
		mode = "n",
		body = "<leader>db",
		heads = {
			{ "c", dap.continue },
			{ "p", dap.pause },
			{ "K", dap.step_back },
			{ "J", dap.step_over },
			{ "H", dap.step_out },
			{ "L", dap.step_into },
      -- stylua: ignore
			{ "R", function() pcall(dap.restart) end },
			{ "x", dap.terminate },
			{ "r", dap.repl.toggle },
			{ "t", dap.toggle_breakpoint },
			{ "T", dap.clear_breakpoints },
			{ "o", cmd "Telescope dap commands", { exit = true } },
			{ "<C-e>", nil, { exit = true, nowait = true } },
			{ "gh", require("dap.ui.widgets").hover },
			{ "<Up>", dap.up },
			{ "<Down>", dap.down },
			{ "u", require("dapui").toggle },
		},
	}

	UserUtils.hydra.git(true)
end

return spec
