return { -- UI components and other visual elements are declared here
	{ -- Theme
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()

			-- Document existing key chains
			require("which-key").register({
				["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[D]iagnostics", _ = "which_key_ignore" },
				["<leader>g"] = { name = "[G]enerate", _ = "which_key_ignore" },
				["<leader>h"] = { name = "[H]arpoon", _ = "which_key_ignore" },
				["<leader>o"] = { name = "[O]verseer", _ = "which_key_ignore" },
				["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
				["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
				["<leader>t"] = { name = "[T]ree", _ = "which_key_ignore" },
				["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
			})
		end,
	},
	{ -- A file explorer, because i'm not used to the vim workflow yet
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			vim.keymap.set("n", "<leader>tt", function()
				vim.api.nvim_command("Neotree toggle")
			end, { desc = "[T]ree [T]oggle" })
			vim.keymap.set("n", "<leader>ts", function()
				vim.api.nvim_command("Neotree show")
			end, { desc = "[T]ree [S]how" })
			vim.keymap.set("n", "<leader>tc", function()
				vim.api.nvim_command("Neotree close")
			end, { desc = "[T]ree [C]lose" })
			vim.keymap.set("n", "<leader>tf", function()
				vim.api.nvim_command("Neotree focus")
			end, { desc = "[T]ree [F]ocus" })
			vim.keymap.set("n", "<leader>tf", function()
				vim.api.nvim_command("Neotree filesystem")
			end, { desc = "[T]ree [F]ilesystem" })
			vim.keymap.set("n", "<leader>tg", function()
				vim.api.nvim_command("Neotree git_status")
			end, { desc = "[T]ree [G]it Status" })
			vim.keymap.set("n", "<leader>tb", function()
				vim.api.nvim_command("Neotree buffers")
			end, { desc = "[T]ree [B]uffers" })
		end,
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				extensions = {
					"fugitive",
					"fzf",
					"lazy",
					"mason",
					"neo-tree",
					"oil",
					"overseer",
					"quickfix",
				},
			})
		end,
	},
}
