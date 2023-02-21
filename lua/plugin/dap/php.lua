local dap = require "dap"
local base = UserUtils.mason_packages_path

dap.adapters.php = {
	type = "executable",
	command = "node",
	args = { base .. "/php-debug-adapter/extension/out/phpDebug.js" },
}

dap.configurations.php = {
	{
		name = "Listen for Xdebug",
		type = "php",
		request = "launch",
		port = 9000,
	},
}
