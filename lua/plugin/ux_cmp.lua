local spec = {
	"hrsh7th/nvim-cmp",
	event = "BufRead",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-path",
		"lukas-reineke/cmp-under-comparator",
		"rafamadriz/friendly-snippets",
		"saadparwaiz1/cmp_luasnip",
		{ "L3MON4D3/LuaSnip", version = "v1.*" },
		"onsails/lspkind.nvim",
		-- "orgmode",
	},
}

function spec.config()
	local luasnip = require "luasnip"
	local cmp = require "cmp"
	local lspkind = require "lspkind"
	require("luasnip.loaders.from_vscode").lazy_load()

	require "user.snippets"
	vim.api.nvim_create_user_command("ReloadSnippets", function()
		luasnip.cleanup()
		require("luasnip.loaders.from_vscode").lazy_load()
		UserUtils.reload_package_with_name "user.snippets"
	end, { desc = "reload user snippets" })

	-- NOTE: makes `tabout` not working correctly
	-- local function has_words_before()
	--     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	--     return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
	-- end

	local function next_item(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		elseif luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		-- elseif has_words_before() then
		--     cmp.complete()
		else
			fallback()
		end
	end

	local function prev_item(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end

	local opts = { "i", "s" }

	local function tailwind_colors(entry, vim_item)
		if vim_item.kind == "Color" and entry.completion_item.documentation then
			local _, _, r, g, b = string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
			if r then
				local color = string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
				local group = "Tw_" .. color
				if vim.fn.hlID(group) < 1 then
					vim.api.nvim_set_hl(0, group, { fg = "#" .. color })
				end
				-- vim_item.kind = "⬤"
				vim_item.kind = "󱓻"
				vim_item.kind_hl_group = group
				return vim_item
			end
		end
		vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
		return vim_item
	end

	local types = require "cmp.types"
	local function deprioritize_snippet(entry1, entry2)
		if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then
			return false
		end
		if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then
			return true
		end
	end

	cmp.setup {
		sorting = {
			comparators = {
				deprioritize_snippet,
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				require("cmp-under-comparator").under,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},
		formatting = {
			format = lspkind.cmp_format {
				mode = "symbol_text", -- show only symbol annotations
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
				preset = "codicons",
				before = tailwind_colors,
			},
		},
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		window = {
			documentation = cmp.config.window.bordered {
				border = Config.border,
				winhighlight = "FloatBorder:FloatBorder",
			},
		},
		performance = {
			trigger_debounce_time = 500,
			throttle = 550,
			fetching_timeout = 80,
		},
		-- completion = {
		-- 	keyword_length = 6,
		-- },
		-- experimental = { ghost_text = true },
		mapping = cmp.mapping.preset.insert {
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			-- ["<Tab>"] = cmp.mapping.confirm { select = true },
			["<C-j>"] = cmp.mapping(next_item, opts),
			["<C-k>"] = cmp.mapping(prev_item, opts),
			["<Tab>"] = cmp.mapping(next_item, opts),
			["<S-Tab>"] = cmp.mapping(prev_item, opts),
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" }, -- For luasnip users.
			{ name = "nvim_lsp_signature_help" },
			{ name = "nvim_lua" },
			-- { name = "orgmode" },
			-- { name = "neorg" },
		}, {
			{ name = "buffer" },
		}),
	}

	-- Set configuration for specific filetype.
	-- cmp.setup.filetype("gitcommit", {
	-- 	sources = cmp.config.sources({
	-- 		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	--      -- { name = "conventionalcommits"}
	-- 	}, {
	-- 		{ name = "buffer" },
	-- 	}),
	-- })

	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})
	cmp.setup.cmdline(":", {
		view = {
			entries = { name = "custom", selection_order = "near_cursor" },
		},
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})
end

return spec
