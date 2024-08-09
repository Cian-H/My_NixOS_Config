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
				["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
			})
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			local icons = require("tables.icons")
			require("nvim-web-devicons").setup({
				color_icons = true,
				override_by_extension = {
					["scl"] = icons.Scallop,
					["prolog"] = icons.Prolog,
					["pro"] = icons.Prolog,
					["lisp"] = icons.Lisp,
					["lsp"] = icons.Lisp,
					["asd"] = icons.Lisp,
					["f"] = icons.Fortran,
					["f77"] = icons.Fortran,
					["f90"] = icons.Fortran,
					["f18"] = icons.Fortran,
					["adb"] = icons.Ada,
					["ads"] = icons.Ada,
				},
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
		},
		config = function()
			local wk = require("which-key")
			local keys = require("tables.keys").neotree
			wk.add(keys)
		end,
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"mhinz/vim-signify",
		config = function()
			-- defer config for 5ms. Old vim plugins can be janky in neovim
			vim.defer_fn(function()
				vim.g.signify_sign_show_count = 0
				vim.g.signify_sign_add = "┃"
				vim.g.signify_sign_change = "┃"
				vim.g.signify_sign_delete = "_"
				vim.g.signify_sign_delete_first_line = "‾"
				vim.g.signify_sign_change_delete = "~"
				vim.cmd.highlight({ "SignifySignAdd", "guifg=#449dab" })
				vim.cmd.highlight({ "SignifySignChange", "guifg=#6183bb" })
				vim.cmd.highlight({ "SignifySignDelete", "guifg=#914c54" })
				vim.cmd.highlight({ "link", "SignifySignDeleteFirstLine", "SignifySignDelete" })
				vim.cmd.highlight({ "link", "SignifySignChangeDelete", "SignifySignChange" })
			end, 5)
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local hl_color = require("tokyonight").load({ style = "night" }).orange
			vim.cmd.highlight({ "LualineHarpoonActive", "guifg=" .. hl_color })

			require("lualine").setup({
				options = {
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_c = {
						{
							"harpoon2",
							icon = "󰛢",
							indicators = { "H", "J", "K", "L" },
							active_indicators = {
								"%#LualineHarpoonActive#H%*",
								"%#LualineHarpoonActive#J%*",
								"%#LualineHarpoonActive#K%*",
								"%#LualineHarpoonActive#L%*",
							},
							_separator = "∙",
							no_harpoon = "Harpoon not loaded",
						},
						"filename",
					},
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
	{
		"letieu/harpoon-lualine",
		dependencies = {
			{
				"ThePrimeagen/harpoon",
				branch = "harpoon2",
			},
		},
	},
	{
		"tris203/precognition.nvim",
		event = "VimEnter",
		config = function()
			local function toggle()
				if require("precognition").toggle() then
					vim.notify("Precognition ON")
				else
					vim.notify("Precognition OFF")
				end
			end

			vim.keymap.set("n", "<leader>p", toggle, { desc = "[P]recognition" })
		end,
	},
}
