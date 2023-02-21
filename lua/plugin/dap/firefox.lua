local dap = require "dap"
local base = UserUtils.mason_packages_path

dap.adapters.firefox = {
	type = "executable",
	command = "node",
	args = {
		base .. "/firefox-debug-adapter/dist/adapter.bundle.js",
	},
}

dap.configurations.typescript = {
	{
		name = "Debug with Firefox",
		type = "firefox",
		request = "launch",
		reAttach = true,
		url = "http://localhost:3000",
		webRoot = "${workspaceFolder}",
		firefoxExecutable = "/usr/bin/firefox",
	},
}
