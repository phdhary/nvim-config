return {
	"ThePrimeagen/refactoring.nvim",
	ft = {
		"typescript",
		"typescriptreact",
		"javascript",
		"javascriptreact",
		"lua",
		"c",
		"cpp",
		"go",
		"python",
		"java",
		"php",
		"ruby",
	},
	opts = {
		prompt_func_return_type = {
			go = false,
			java = false,

			cpp = false,
			c = false,
			h = false,
			hpp = false,
			cxx = false,
		},
		prompt_func_param_type = {
			go = false,
			java = false,

			cpp = false,
			c = false,
			h = false,
			hpp = false,
			cxx = false,
		},
		printf_statements = {},
		print_var_statements = {},
	},
}
