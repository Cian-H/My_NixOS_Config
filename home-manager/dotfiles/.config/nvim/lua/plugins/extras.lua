return { -- Non programming quality of life utilities go here
	{ -- Definitely need to add a plugin for quickly making notes in obsidian
		"epwalsh/obsidian.nvim",
		version = "*",
		cmd = "Obsidian",
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "Documents/Work_Notes/**.md",
			"BufNewFile " .. vim.fn.expand("~") .. "Documents/Work_Notes/**.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			workspaces = {
				{
					name = "work",
					path = "~/Documents/Work_Notes/",
				},
			},
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},
		},
	},
	{ -- A cheatsheet will always be useful until im a bit more familiar with vim
		"sudormrfbin/cheatsheet.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
		},
	},
}
