local spec = {
	"nvim-telescope/telescope.nvim",
	version = "0.1.0",
	event = "VeryLazy",
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
	},
}

spec.keys = {
	{ "<C-p>", "<CMD>Telescope git_files<CR>" },
	{ "<leader>ff", "<CMD>Telescope fd<CR>" },
	{ "<leader>fw", "<CMD>Telescope grep_string<CR>" },
	{ "<leader>fo", "<CMD>Telescope oldfiles<CR>" },
	{ "<leader>fr", "<CMD>Telescope registers<CR>" },
	{ "<leader>/", "<CMD>Telescope live_grep<CR>" },
	{ "<leader>:", "<CMD>Telescope command_history<CR>" },
	{ "<leader>sc", "<CMD>Telescope colorscheme<CR>" },
	{ "<leader>sh", "<CMD>Telescope help_tags<CR>" },
	{ "<leader>sb", "<CMD>Telescope buffers<CR>" },
	{ "<leader>sk", "<CMD>Telescope keymaps<CR>" },
	{ "<leader>gsl", "<CMD>Telescope git_stash<CR>" },
	{ "<leader>qh", "<CMD>Telescope quickfixhistory<CR>" },
}

local function layout_flex(another_settings)
	local layout_settings = {
		layout_strategy = "flex",
		layout_config = { horizontal = { preview_width = 0.5 } },
	}
	return vim.tbl_extend("force", layout_settings, another_settings or {})
end

local opts = {
	defaults = {
		selection_caret = " ",
		prompt_prefix = " ",
		mappings = {
			i = {
				["<C-o>"] = "select_default",
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",
			},
			n = {
				o = "select_default",
				q = "close",
			},
		},
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--trim",
		},
	},
	pickers = {
		colorscheme = { theme = "dropdown" },
		command_history = { theme = "ivy", layout_config = { height = 0.3 } },
		live_grep = layout_flex(),
		help_tags = layout_flex(),
		man_pages = layout_flex(),
		builtin = layout_flex(),
		fd = layout_flex(),
		lsp_references = layout_flex { initial_mode = "normal" },
		lsp_implementations = layout_flex { initial_mode = "normal" },
		lsp_definitions = layout_flex { initial_mode = "normal" },
		lsp_type_definitions = layout_flex { initial_mode = "normal" },
		diagnostics = layout_flex { initial_mode = "normal" },
		git_files = layout_flex { show_untracked = true },
		grep_string = layout_flex { initial_mode = "normal" },
		git_status = layout_flex { initial_mode = "normal" },
		git_stash = layout_flex { initial_mode = "normal" },
		git_branches = layout_flex { initial_mode = "normal" },
		git_commits = layout_flex { initial_mode = "normal" },
	},
}

opts.extensions = {
	fzf = {
		fuzzy = true, -- false will only do exact matching
		override_generic_sorter = true, -- override the generic sorter
		override_file_sorter = true, -- override the file sorter
		case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		-- the default case_mode is "smart_case"
	},
}

function spec.config()
	local telescope = require "telescope"
	local actions = require "telescope.actions"

	opts.pickers.buffers = layout_flex {
		initial_mode = "normal",
		mappings = { n = { ["dd"] = actions.delete_buffer } },
	}

	telescope.setup(opts)
	telescope.load_extension "fzf"
end

return spec
