local dap = require "dap"
local base = UserUtils.mason_packages_path

dap.adapters.chrome = {
	type = "executable",
	command = "node",
	args = { base .. "/chrome-debug-adapter/out/src/chromeDebug.js" },
}

dap.configurations.javascriptreact = { -- change this to javascript if needed
	{
		name = "javascriptreact",
		type = "chrome",
		request = "attach",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		port = 9222,
		webRoot = "${workspaceFolder}",
	},
}

-- dap.configurations.typescript = {
--     {
--         name = "typescript",
--         type = "chrome",
--         request = "attach",
--         program = "${file}",
--         cwd = vim.fn.getcwd(),
--         sourceMaps = true,
--         protocol = "inspector",
--         port = 9222,
--         webRoot = "${workspaceFolder}",
--     },
-- }

dap.configurations.typescriptreact = { -- change to typescript if needed
	{
		name = "typescriptreact",
		type = "chrome",
		request = "attach",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		port = 9222,
		webRoot = "${workspaceFolder}",
	},
}
