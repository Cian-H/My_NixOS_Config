return {
	groups = {
		{ "<leader>s", group = "[S]earch" },
		{ "<leader>c", group = "[C]ode" },
		{ "<leader>d", group = "[D]iagnostics" },
		{ "<leader>g", group = "[G]enerate" },
		{ "<leader>r", group = "[R]ename" },
		{ "<leader>w", group = "[W]orkspace" },
		{ "<leader>t", group = "[T]ree" },
		{ "<leader>o", group = "[O]verseer" },
		{ "<leader>h", group = "[H]arpoon" },
	},
	neotree = {
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
	telescope = function(telescope_builtin)
		return {
			{
				"<leader>sh",
				telescope_builtin.help_tags,
				desc = "[S]earch [H]elp",
				mode = "n",
			},
			{
				"<leader>sk",
				telescope_builtin.keymaps,
				desc = "[S]earch [K]eymaps",
				mode = "n",
			},
			{
				"<leader>sf",
				telescope_builtin.find_files,
				desc = "[S]earch [F]iles",
				mode = "n",
			},
			{
				"<leader>sb",
				telescope_builtin.find_files,
				desc = "[S]earch file [B]rowser",
				mode = "n",
			},
			{
				"<leader>ss",
				telescope_builtin.builtin,
				desc = "[S]earch [S]elect Telescope",
				mode = "n",
			},
			{
				"<leader>sw",
				telescope_builtin.grep_string,
				desc = "[S]earch current [W]ord",
				mode = "n",
			},
			{
				"<leader>sg",
				telescope_builtin.live_grep,
				desc = "[S]earch by [G]rep",
				mode = "n",
			},
			{
				"<leader>sd",
				telescope_builtin.diagnostics,
				desc = "[S]earch [D]iagnostics",
				mode = "n",
			},
			{
				"<leader>sr",
				telescope_builtin.resume,
				desc = "[S]earch [R]esume",
				mode = "n",
			},
			{
				"<leader>s.",
				telescope_builtin.oldfiles,
				desc = '[S]earch Recent Files ("." for repeat)',
				mode = "n",
			},
			{
				"<leader><leader>",
				telescope_builtin.buffers,
				desc = "[ ] Find existing buffers",
				mode = "n",
			},
			-- Slightly advanced example of overriding default behavior and theme
			{
				"<leader>/",
				function()
					-- You can pass additional configuration to telescope to change theme, layout, etc.
					telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end,
				desc = "[/] Fuzzily search in current buffer",
				mode = "n",
			},
			-- Also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			{
				"<leader>s/",
				function()
					telescope_builtin.live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end,
				desc = "[S]earch [/] in Open Files",
				mode = "n",
			},
			-- Shortcut for searching your neovim configuration files
			{
				"<leader>sn",
				function()
					telescope_builtin.find_files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "[S]earch [N]eovim files",
				mode = "n",
			},
		}
	end,
	precognition = {
		{
			"<leader>p",
			function()
				if require("precognition").toggle() then
					vim.notify("Precognition ON")
				else
					vim.notify("Precognition OFF")
				end
			end,
			desc = "[P]recognition",
			mode = "n",
		},
	},
	overseer = {
		{ "<leader>ob", vim.cmd.OverseerBuild, desc = "[O]verseer [B]uild", mode = "n" },
		{ "<leader>oc", vim.cmd.OverseerRunCmd, desc = "[O]verseer Run [C]ommand", mode = "n" },
		{ "<leader>or", vim.cmd.OverseerRun, desc = "[O]verseer [R]un", mode = "n" },
		{ "<leader>ot", vim.cmd.OverseerToggle, desc = "[O]verseer [T]oggle", mode = "n" },
	},
	neogen = {
		{ "<Leader>gd", ":lua require('neogen').generate()<CR>", desc = "[G]enerate [D]ocumentation", mode = "n" },
	},
	harpoon = {
		{
			"<leader>ha",
			function()
				require("harpoon"):list():add()
			end,
			desc = "[H]arpoon [A]dd file",
			mode = "n",
		},
		{
			"<leader>hq",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "[H]arpoon [Q]uick menu",
			mode = "n",
		},
		{
			"<C-h>",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "Harpoon file 1",
			mode = "n",
		},
		{
			"<C-j>",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "Harpoon file 2",
			mode = "n",
		},
		{
			"<C-k>",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "Harpoon file 3",
			mode = "n",
		},
		{
			"<C-l>",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "Harpoon file 4",
			mode = "n",
		},
	},
	oil = {
		{ "<leader>te", vim.cmd.Oil, desc = "[T]ree [E]dit", mode = "n" },
	},
	lazygit = {
		{ "<leader>l", "<cmd>LazyGit<cr>", desc = "[L]azyGit", mode = "n" },
	},
	multicursors = {
		{
			"<Leader>m",
			"<cmd>MCstart<cr>",
			desc = "[M]ulticursor",
			mode = { "v", "n" },
		},
	},
}