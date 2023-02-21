return {
	{ "fladson/vim-kitty", ft = "kitty" },
	{ "vigoux/notifier.nvim", event = "VeryLazy", config = true },
	{
		"mbbill/undotree",
		keys = { { "<leader>u", vim.cmd.UndotreeToggle } },
		config = function()
			vim.g.undotree_DiffAutoOpen = 0
			vim.g.undotree_SetFocusWhenToggle = 1
			vim.g.undotree_ShortIndicators = 1
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufRead",
		opts = {
			user_default_options = {
				-- virtualtext {fore|back}ground
				mode = "background",
				tailwind = true, -- Enable tailwind colors
				virtualtext = "■",
			},
		},
	},
  -- stylua: ignore
  {
    "iamcco/markdown-preview.nvim", -- view markdown files in browser
    version = "*",
    keys = { { "<leader>mp", vim.cmd.MarkdownPreviewToggle } },
    ft =  "markdown",
    build = function() vim.fn["mkdp#util#install"]() end,
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
  },
	{
		"lukas-reineke/indent-blankline.nvim",
		version = "v2.*",
		event = "BufRead",
		keys = { { "<leader>ib", vim.cmd.IndentBlanklineToggle } },
		opts = {
			enabled = true,
			use_treesitter = true,
			show_current_context = true,
			char = "┆",
			-- context_char = "┆",
			-- show_current_context_start = true,
		},
	},
	{
		"b0o/incline.nvim",
		event = "BufRead",
		opts = {
			hide = { cursorline = true, focused_win = false, only_win = true },
			window = { padding = 0, margin = { horizontal = 0, vertical = 1 } },
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":~:.") -- :t
				if filename:match "^fugitive" then
					filename = UserUtils.fugitive.hide_long_path(filename)
				end
				local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
				local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "bold"
				local modified_symbol = vim.api.nvim_buf_get_option(props.buf, "modified") and " ⏺" or ""
				local comment_hl = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID "Comment"), "fg#")
				return props.focused
						and {
							{ ft_icon, guifg = ft_color },
							{ " " },
							{ filename, gui = modified },
							{ modified_symbol },
						}
					or {
						{ ft_icon, guifg = comment_hl },
						{ " " },
						{ filename, guifg = comment_hl },
						{ modified_symbol },
					}
			end,
		},
	},
	-- {
	-- 	"folke/noice.nvim",
	--    enabled= false,
	-- 	config = function()
	-- 		 vim.lsp.handlers["$/progress"] = function(_, result, ctx)
	-- 		 	local value = result.value
	-- 		 	if not value.kind then
	-- 		 		return
	-- 		 	end
	-- 		 	local client_id = ctx.client_id
	-- 		 	local name = vim.lsp.get_client_by_id(client_id).name
	-- 		 	if name == "null-ls" then
	-- 		 		return
	-- 		 	end
	--
	-- 		 	vim.notify(value.message, "info", {
	-- 		 		title = value.title,
	-- 		 	})
	-- 		 end
	-- 		require("noice").setup {
	-- 			lsp = {
	-- 				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
	-- 				override = {
	-- 					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
	-- 					["vim.lsp.util.stylize_markdown"] = true,
	-- 					["cmp.entry.get_documentation"] = true,
	-- 				},
	-- 				progress = { enabled = true },
	-- 			},
	-- 			views = {
	-- 				cmdline_popup = {
	-- 					border = { style = "single", padding = { 0, 0 } },
	-- 					filter_options = {},
	-- 					win_options = {
	-- 						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
	-- 					},
	-- 				},
	-- 			},
	-- 			presets = {
	-- 				bottom_search = false, -- use a classic bottom cmdline for search
	-- 				command_palette = false, -- position the cmdline and popupmenu together
	-- 				long_message_to_split = true, -- long messages will be sent to a split
	-- 				inc_rename = false, -- enables an input dialog for inc-rename.nvim
	-- 				lsp_doc_border = false, -- add a border to hover docs and signature help
	-- 			},
	-- 		}
	-- 	end,
	-- },
}
