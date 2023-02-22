local spec = {
	"nvim-lualine/lualine.nvim",
	event = "BufRead",
}

local opts = {
	options = {
		theme = "auto",
		component_separators = "",
		section_separators = "",
		globalstatus = true,
		disabled_filetypes = { statusline = { "lazy", "alpha" } },
		refresh = { statusline = 10, tabline = 10, winbar = 10 },
	},
	sections = {},
	extensions = { "man" },
}

local function is_more_than_minimal_width()
	return vim.o.columns > 50
end

opts.sections.lualine_a = {}
opts.sections.lualine_b = {}
opts.sections.lualine_c = {
	{ "branch", icon = "", cond = is_more_than_minimal_width },
	{
		"filename",
		path = 1,
		newfile_status = true,
		symbols = {
			modified = "%#lualine_c_normal#" .. "⏺ ",
			readonly = "%#lualine_c_diagnostics_error_normal#" .. " ",
			unnamed = " [No Name] ",
			newfile = "%#lualine_c_diagnostics_info_normal#" .. "[New] ",
		},
	},
	{ "b:gitsigns_status" },
	{ "diagnostics", symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" } },
}
opts.sections.lualine_x = {
	{
		function()
			local lsp_on = "%#lualine_c_diagnostics_info_normal#" .. " " .. "%#lualine_c_normal#"
			local lsp_off = ""
			-- local lsp_off = "%#lualine_x_normal#" .. ""
			local buf_ft, clients = vim.api.nvim_buf_get_option(0, "filetype"), vim.lsp.get_active_clients()
			local client_table = {}
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and client.name ~= "null-ls" then
					table.insert(client_table, client.name)
				end
			end
			-- local nls_sources = require("null-ls.sources").get_available(vim.bo.filetype)
			-- local nls_count = 0
			-- for _, _ in ipairs(nls_sources) do nls_count = nls_count + 1 end
			-- if nls_count > 0 then table.insert(client_table, "null-ls(" .. nls_count .. ")") end
			return (next(clients) == nil or #client_table == 0) and lsp_off
				or lsp_on .. table.concat(client_table, "·")
		end,
		cond = function()
			return vim.o.columns > 100
		end,
	},
}
opts.sections.lualine_z = {}

opts.extensions.telescope = {
	filetypes = { "TelescopePrompt" },
	sections = {
		lualine_c = { {
			function()
				return "Telescope"
			end,
		} },
		lualine_x = {},
	},
}

opts.extensions.neotree = {
	filetypes = { "neo-tree" },
	sections = {
		lualine_c = {
			function()
				return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
			end,
		},
		lualine_x = {},
	},
}

local function is_loclist()
	return vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
end

opts.extensions.quickfix = {
	init = function()
		vim.g.qf_disable_statusline = true
	end,
	filetypes = { "qf" },
	sections = {
		lualine_c = {
			{
				function()
					return is_loclist() and "[Location List]" or "[Quickfix List]"
				end,
			},
			{
				function()
					return is_loclist() and vim.fn.getloclist(0, { title = 0 }).title
						or vim.fn.getqflist({ title = 0 }).title
				end,
			},
		},
		lualine_x = {},
	},
}

opts.extensions.fugitive = {
	filetypes = { "fugitive" },
	sections = {
		lualine_c = {
			{
				function()
					return " " .. vim.fn.FugitiveHead()
				end,
			},
		},
		lualine_x = {},
	},
}

local function add_common_component(part)
	local tabs = {
		"tabs",
		cond = function()
			return #vim.api.nvim_list_tabpages() > 1
		end,
	}
	part.sections.lualine_y = { tabs }
	table.insert(part.sections.lualine_x, { "location", cond = is_more_than_minimal_width })
	table.insert(part.sections.lualine_x, { "progress", cond = is_more_than_minimal_width })
end

add_common_component(opts)
add_common_component(opts.extensions.fugitive)
add_common_component(opts.extensions.neotree)
add_common_component(opts.extensions.telescope)
add_common_component(opts.extensions.quickfix)

function spec.config()
	opts.options.theme = (not Config.lualine_auto_theme and Config.colorscheme) or "auto"
	require("lualine").setup(opts)
end

return spec
