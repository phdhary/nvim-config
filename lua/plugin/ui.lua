return {
	{ "fladson/vim-kitty", ft = "kitty" },
	{
		"vigoux/notifier.nvim",
		event = "VeryLazy",
		config = function()
			require("notifier").setup()
			local vim_notify = vim.notify
			---@diagnostic disable-next-line: duplicate-set-field
			vim.notify = function(msg, level, opts)
				if msg == "No information available" then
					return
				end
				return vim_notify(msg, level, opts)
			end
		end,
	},
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
		ft = "markdown",
		build = function() vim.fn["mkdp#util#install"]() end,
		init = function() vim.g.mkdp_filetypes = { "markdown" } end,
		config = function()
			vim.cmd [[ 
      function OpenMarkdownPreview (url)
        execute "silent ! firefox --new-window " . a:url
      endfunction
      let g:mkdp_browserfunc = 'OpenMarkdownPreview']]
		end,
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
			window = {
				padding = 0,
				margin = { horizontal = 0, vertical = 1 },
				zindex = 2,
			},
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":~:.") -- :t
				if filename:match "^fugitive" then
					filename = UserUtils.hide_long_path(filename)
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
}
