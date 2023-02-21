local spec = {
	"mfussenegger/nvim-dap",
	event = "BufRead",
	dependencies = {
		"nvim-dap-ui",
		"nvim-telescope/telescope-dap.nvim",
		"telescope.nvim",
		-- { "jay-babu/mason-nvim-dap.nvim", dependencies = "mason" },
	},
}

function spec.config()
	require "plugin.dap.firefox"
	require "plugin.dap.chrome"
	require "plugin.dap.php"
	require "plugin.dap.node"
	require("telescope").load_extension "dap"

	-- setup mason_nvim_dap
	-- local mason_nvim_dap = require "mason-nvim-dap"
	-- mason_nvim_dap.setup {
	-- 	automatic_setup = true,
	-- }
	-- mason_nvim_dap.setup_handlers()
end

return spec
