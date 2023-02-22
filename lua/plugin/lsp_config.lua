local spec = {
	"neovim/nvim-lspconfig",
	event = "BufRead",
	dependencies = {
		"b0o/schemastore.nvim",
		{
			"williamboman/mason.nvim",
			name = "mason",
			opts = {
				ui = {
					width = 1,
					height = 1,
					border = "none",
					keymaps = { toggle_package_expand = "<Tab>" },
				},
			},
		},
		{
			"williamboman/mason-lspconfig.nvim",
			name = "mason-lspconfig",
			opts = { ensure_installed = require("user.lsp_utils").ensure_installed.lsp },
			dependencies = "mason",
		},
		{
			"folke/neodev.nvim",
			opts = {
				library = {
					enabled = true,
					runtime = true, --true
					types = true,
					plugins = false, -- enable this to make lua lsp load plugins
					-- plugins = { "neovim-session-manager" },
				},
			},
		},
	},
}

function spec.config()
	local lspconfig = require "lspconfig"
	local lsp_utils = require "user.lsp_utils"

	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	---@diagnostic disable-next-line: unused-local
	local on_attach = function(client, bufnr)
		lsp_utils:setup_lsp_essential()
	end

	require("lspconfig.ui.windows").default_options.border = Config.border

	for _, lsp in ipairs(lsp_utils.ensure_installed.lsp) do
		local opts = { capabilities = capabilities, on_attach = on_attach }
		if lsp == "lua_ls" then
			opts.settings = {
				Lua = {
					completion = { callSnippet = "Replace" },
					format = { enable = false },
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			}
		elseif lsp == "jsonls" then
			opts.settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			}
		elseif lsp == "cssls" then
			opts.settings = {
				css = {
					lint = {
						unknownAtRules = "ignore",
					},
				},
			}
		elseif lsp == "tailwindcss" then
			opts.filetypes = {
				"aspnetcorerazor",
				"astro",
				"astro-markdown",
				"blade",
				"django-html",
				"htmldjango",
				"edge",
				"eelixir",
				"elixir",
				"ejs",
				"erb",
				"eruby",
				"gohtml",
				"haml",
				"handlebars",
				"hbs",
				"html",
				"html-eex",
				"heex",
				"jade",
				"leaf",
				"liquid",
				-- "markdown",
				"mdx",
				"mustache",
				"njk",
				"nunjucks",
				"php",
				"razor",
				"slim",
				"twig",
				"css",
				"less",
				"postcss",
				"sass",
				"scss",
				"stylus",
				"sugarss",
				"javascript",
				"javascriptreact",
				"reason",
				"rescript",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
			}
			opts.root_dir = function(fname)
				local root_pattern =
					lspconfig.util.root_pattern("tailwind.config.cjs", "tailwind.config.js", "postcss.config.js")
				return root_pattern(fname)
			end
		end
		lspconfig[lsp].setup(opts)
	end
end

return spec
