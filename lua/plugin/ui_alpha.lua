local spec = {
	"goolord/alpha-nvim",
	event = "VimEnter",
}

function spec.config()
	local dashboard = require "alpha.themes.dashboard"

	-- dashboard.section.header.val = {
	-- 	[[███    ██ ███████  ██████  ██    ██ ██ ███    ███]],
	-- 	[[████   ██ ██      ██    ██ ██    ██ ██ ████  ████]],
	-- 	[[██ ██  ██ █████   ██    ██ ██    ██ ██ ██ ████ ██]],
	-- 	[[██  ██ ██ ██      ██    ██  ██  ██  ██ ██  ██  ██]],
	-- 	[[██   ████ ███████  ██████    ████   ██ ██      ██]],
	-- }

	local version = vim.version()
	local nvim_version = version ~= nil and "NVIM v" .. version.major .. "." .. version.minor .. "." .. version.patch
		or ""

	dashboard.section.header.val = {
		"                  " .. nvim_version,
		[[]],
		[[ Nvim is open source and freely distributable]],
		[[            https://neovim.io/#chat]],
		[[]],
		[[type  :help nvim<Enter>       if you are new!]],
		[[type  :checkhealth<Enter>     to optimize Nvim]],
		[[type  :q<Enter>               to exit]],
		[[type  :help<Enter>            for help]],
	}
	dashboard.section.buttons.val = {
		dashboard.button("<leader> s l", "  Find session", "<cmd>SessionManager load_session<CR>"),
		dashboard.button("<leader> f f", "  Find files", "<cmd>Telescope fd<CR>"),
		dashboard.button("<leader> /", "  Live grep", "<cmd>Telescope live_grep<CR>"),
		dashboard.button("<leader> c n", "  Configuration", "<cmd>e $MYVIMRC|cd %:p:h<CR>"),
		dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
	}
	require("alpha").setup(dashboard.opts)
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimStarted",
		callback = function()
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			dashboard.section.footer.val = " Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
			pcall(vim.cmd.AlphaRedraw)
		end,
	})
end

return spec
