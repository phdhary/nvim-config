local spec = {
	"jose-elias-alvarez/null-ls.nvim",
	event = "BufRead",
	dependencies = {
		"jay-babu/mason-null-ls.nvim",
	},
}

function spec.config()
	local nls = require "null-ls"
	local b = nls.builtins
	local formatting = b.formatting
	local code_actions = b.code_actions
	local diagnostics = b.diagnostics
	-- local hover= b.hover
	-- local completion= b.completion

	local root_has_file = function(files)
		return function(utils)
			return utils.root_has_file(files)
		end
	end

	local prettier_root_files = { ".prettierrc", ".prettierrc.js", ".prettierrc.json" }
	local stylua_root_files = { "stylua.toml", ".stylua.toml" }

	local opts = {
		prettier = { condition = root_has_file(prettier_root_files) },
		stylua = { condition = root_has_file(stylua_root_files) },
		refactoring = {
			runtime_condition = function(_)
				local mode = vim.fn.mode()
				return mode == "V" or mode == "v"
			end,
		},
		gitsigns = {
			runtime_condition = function()
				return vim.wo.diff
			end,
		},
	}

	local sources = {
		formatting.stylua, -- .with(opts.stylua),
		formatting.prettierd, -- .with(opts.prettier),
		formatting.beautysh,
		formatting.shellharden,
		formatting.gofmt,
		formatting.rustfmt,
		formatting.fixjson,
		formatting.black,
		-- formatting.rustywind, -- if no prettier-tailwind present
		-- formatting.eslint_d,
		-- code_actions.eslint,
		code_actions.refactoring.with(opts.refactoring),
		-- code_actions.gitsigns.with(opts.gitsigns),
		code_actions.shellcheck,
		-- diagnostics.eslint,
		-- diagnostics.eslint_d,
		diagnostics.editorconfig_checker,
		require "typescript.extensions.null-ls.code-actions",
	}

	nls.setup {
		sources = sources,
		debug = false,
		border = Config.border,
	}

	require("mason-null-ls").setup {
		ensure_installed = nil,
		automatic_installation = true,
		automatic_setup = false,
	}
end

return spec
