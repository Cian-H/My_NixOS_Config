local configs = require("lspconfig/configs")
local util = require("lspconfig/util")

configs.nushell_lsp = {
	default_config = {
		cmd = {
			"nu",
			"--lsp",
		},
		filetypes = { "nu" },
		root_dir = util.find_git_ancestor,
		single_file_support = true,
	},
}
