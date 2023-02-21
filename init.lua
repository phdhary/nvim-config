Config = {
	colorscheme = "zenwritten",
	-- border = "solid",
	border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" },
	lualine_auto_theme = true,
	transparent = false,
	use_different_float_background = false,
}

require "user"

vim.cmd.colorscheme(Config.colorscheme)
