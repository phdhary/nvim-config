Config = {
	colorscheme = "kanagawa",
	border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
	lualine_auto_theme = true,
	transparent = false,
}

require "user"

vim.cmd.colorscheme(Config.colorscheme)
