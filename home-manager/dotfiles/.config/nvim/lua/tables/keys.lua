return {
	neotree = {
		{ "<leader>t", desc = "[T]ree", _ = "which_key_ignore" },
		{
			"<leader>tt",
			function()
				vim.api.nvim_command("Neotree toggle")
			end,
			desc = "[T]ree [T]oggle",
			mode = "n",
		},
		{
			"<leader>ts",
			function()
				vim.api.nvim_command("Neotree show")
			end,
			desc = "[T]ree [S]how",
			mode = "n",
		},
		{
			"<leader>tc",
			function()
				vim.api.nvim_command("Neotree close")
			end,
			desc = "[T]ree [C]lose",
			mode = "n",
		},
		{
			"<leader>tf",
			function()
				vim.api.nvim_command("Neotree focus")
			end,
			desc = "[T]ree [F]ocus",
			mode = "n",
		},
		{
			"<leader>tg",
			function()
				vim.api.nvim_command("Neotree git_status")
			end,
			desc = "[T]ree [G]it Status",
			mode = "n",
		},
		{
			"<leader>tb",
			function()
				vim.api.nvim_command("Neotree buffers")
			end,
			desc = "[T]ree [B]uffers",
			mode = "n",
		},
	},
}
