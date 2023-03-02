vim.opt.cmdheight = 1 -- the height below statusline
vim.opt.laststatus = 3 -- statusline
vim.opt.showtabline = 0 -- tab on top
vim.opt.cursorline = true -- horizontal cursor line
vim.opt.termguicolors = true
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.numberwidth = 2
vim.opt.showmode = true -- display mode in bottom below statusline
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 5
vim.opt.title = false
vim.opt.ruler = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.linebreak = true

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus" -- set global clipboard
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.timeoutlen = 400
vim.opt.wrap = false
vim.opt.breakindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 200

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

if vim.g.neovide == true then
	vim.opt.guifont = "JetBrainsMono Nerd Font:h15"
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_transparency = 0.97
	-- vim.g.neovide_floating_blur_amount_x = 2.0
	-- vim.g.neovide_floating_blur_amount_y = 2.0
	vim.g.neovide_cursor_vfx_mode = "pixiedust"
	-- vim.g.neovide_cursor_trail_size = 0.1
end

vim.opt.shortmess:append "F"
vim.opt.fillchars:append {
	eob = " ",
	foldopen = "",
	foldclose = "",
	fold = " ",
	diff = not vim.g.neovide and "╱" or "-",
}

vim.opt.guicursor = {
	"n-v-c:block",
	"i-ci-ve:ver25",
	"r-cr:hor20",
	"o:hor50",
	"a:blinkwait700-blinkoff400-blinkon250",
	"sm:block-blinkwait175-blinkoff150-blinkon175",
}
