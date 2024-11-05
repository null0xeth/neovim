local M = {}
M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
	if vim.api.nvim_get_mode().mode == "i" then
		vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
	end
end

local icons = {
	-- if you change or add symbol here
	-- replace corresponding line in readme
	Text = "󰉿",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰜢",
	Variable = "󰀫",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "󰑭",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "󰈇",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "󰙅",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "",
}

return {
	-- {
	--   "L3MON4D3/LuaSnip",
	--   build = "make install_jsregexp",
	--   dependencies = {
	--     {
	--       "rafamadriz/friendly-snippets",
	--       config = function()
	--         require("luasnip.loaders.from_vscode").lazy_load()
	--       end,
	--     },
	--     {
	--       "honza/vim-snippets",
	--       config = function()
	--         require("luasnip.loaders.from_snipmate").lazy_load()
	--         require("luasnip").filetype_extend("all", { "_" })
	--       end,
	--     },
	--   },
	--   opts = {
	--     history = true,
	--     delete_check_events = "TextChanged",
	--   },
	--   keys = {
	--     {
	--       "<C-j>",
	--       function()
	--         return require("luasnip").jumpable() and require("luasnip").jump_next() or "<C-j>"
	--       end,
	--       expr = true,
	--       remap = true,
	--       silent = true,
	--       mode = "i",
	--     },
	--     {
	--       "<C-j>",
	--       function()
	--         require("luasnip").jump(1)
	--       end,
	--       mode = "s",
	--     },
	--     {
	--       "<C-k>",
	--       function()
	--         require("luasnip").jump(-1)
	--       end,
	--       mode = {
	--         "i",
	--         "s",
	--       },
	--     },
	--   },
	--   -- TODO: revisit this config
	--   config = function(_, opts)
	--     require("luasnip").setup(opts)
	--
	--     local snippets_folder = fn.stdpath("config") .. "/lua/plugins/core/completion/snippets/"
	--     require("luasnip.loaders.from_lua").lazy_load({ paths = snippets_folder })
	--
	--     api.nvim_create_user_command("LuaSnipEdit", function()
	--       require("luasnip.loaders.from_lua").edit_snippet_files()
	--     end, {})
	--   end,
	-- },
	-- {
	--   "danymat/neogen",
	--   enabled = false,
	--   cmd = { "Neogen" },
	--   opts = {
	--     snippet_engine = "luasnip",
	--     enabled = true,
	--     languages = {
	--       lua = {
	--         template = {
	--           annotation_convention = "ldoc",
	--         },
	--       },
	--       python = {
	--         template = {
	--           annotation_convention = "google_docstrings",
	--         },
	--       },
	--       rust = {
	--         template = {
	--           annotation_convention = "rustdoc",
	--         },
	--       },
	--       javascript = {
	--         template = {
	--           annotation_convention = "jsdoc",
	--         },
	--       },
	--       typescript = {
	--         template = {
	--           annotation_convention = "tsdoc",
	--         },
	--       },
	--       typescriptreact = {
	--         template = {
	--           annotation_convention = "tsdoc",
	--         },
	--       },
	--     },
	--   },
	--   --stylua: ignore
	--   keys = {
	--     { "<leader>laa", function() require("neogen").generate() end,                  desc = "Annotation (Neogen)", },
	--     { "<leader>lac", function() require("neogen").generate { type = "class" } end, desc = "Class (Neogen)", },
	--     { "<leader>laf", function() require("neogen").generate { type = "func" } end,  desc = "Function (Neogen)", },
	--     { "<leader>lat", function() require("neogen").generate { type = "type" } end,  desc = "Type (Neogen)", },
	--   },
	-- },
	--
	-- {
	--   "hrsh7th/nvim-cmp",
	--   version = false,
	--   --"iguanacucumber/magazine.nvim", -- Temporary fork. Also remove in copilot-cmp.lua and nvim-lspconfig.lua
	--   --name = "nvim-cmp", -- Needed for fork
	--   event = "InsertEnter",
	--   dependencies = {
	--     "onsails/lspkind.nvim",
	--     "hrsh7th/cmp-nvim-lsp",
	--     "hrsh7th/cmp-buffer",
	--     "hrsh7th/cmp-path",
	--     "saadparwaiz1/cmp_luasnip",
	--     "hrsh7th/cmp-cmdline",
	--     "dmitmel/cmp-cmdline-history",
	--     "hrsh7th/cmp-nvim-lua",
	--     "petertriho/cmp-git",
	--     "hrsh7th/cmp-nvim-lsp-signature-help",
	--     "SergioRibera/cmp-dotenv",
	--   },
	--   config = function()
	--     local completion_controller = require("framework.controller.completioncontroller"):new()
	--     completion_controller:initialize_cmp()
	--   end,
	-- },
	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",
		build = "cargo build --release",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			accept = { auto_brackets = { enabled = true } },
			sources = {
				completion = {
					enabled_providers = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
				},
				providers = {
					-- lsp = {
					-- 	module = "blink.cmp.sources.lsp",
					-- 	name = "LSP",
					-- },
					lsp = { fallback_for = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
					snippets = {
						-- module = "blink.cmp.sources.snippets",
						-- name = "Snippets",
						score_offset = -3,
						keyword_length = 1, -- not supported yet
					},
					path = {
						-- module = "blink.cmp.sources.path",
						-- name = "Path",
						opts = { get_cwd = vim.uv.cwd },
					},
					buffer = {
						-- module = "blink.cmp.sources.buffer",
						-- name = "Buffer",
						max_items = 4,
						min_keyword_length = 4,
						score_offset = -3,
						fallback_for = {}, -- PENDING https://github.com/Saghen/blink.cmp/issues/122
					},
				},
			},
			highlight = {
				use_nvim_cmp_as_default = false,
			},
			nerd_font_variant = "mono",
			windows = {
				documentation = {
					winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
					--winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
					-- min_width = 15,
					-- max_width = 50,
					-- max_height = 15,
					border = "rounded",
					auto_show = true,
					--auto_show_delay_ms = 200,
				},
				autocomplete = {
					-- min_width = 30,
					-- max_height = 10,
					winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:Search',
					--winhighlight =
					--'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
					--winblend = vim.o.pumblend,
					border = "rounded",
					draw = "reversed",
				},
			},
			kind_icons = icons,
			keymap = {
				["<C-s>"] = { "show" },
				["<C-h>"] = { "hide" },
				["<C-CR>"] = { "select_and_accept", "fallback" },
				["<Tab>"] = {
					function(cmp)
						if cmp.is_in_snippet() then
							return cmp.accept()
						elseif require("copilot.suggestion").is_visible() then
							M.create_undo()
							require("copilot.suggestion").accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next" },
				["<C-p>"] = { "select_prev" },
				["<PageDown>"] = { "scroll_documentation_down" },
				["<PageUp>"] = { "scroll_documentation_up" },
			},
		},
		config = function(_, opts)
			require("blink.cmp").setup(opts)
		end,
	},

	-- LSP servers and clients communicate what features they support through "capabilities".
	--  By default, Neovim support a subset of the LSP specification.
	--  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
	--  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
	--
	-- This can vary by config, but in-general for nvim-lspconfig:

	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
		end,
	},
	--   {
	--     "windwp/nvim-autopairs",
	--     dependencies = {
	--       "hrsh7th/nvim-cmp",
	--     },
	--     event = "InsertEnter",
	--     config = function()
	--       local autopairs = require("nvim-autopairs")
	--
	--       autopairs.setup({
	--         enable_check_bracket_line = false,
	--       })
	--
	--       local cmp = require("cmp")
	--       local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	--       local ts_utils = require("nvim-treesitter.ts_utils")
	--
	--       local ts_node_func_parens_disabled = {
	--         -- ecma
	--         named_imports = true,
	--         export_clause = true,
	--         -- rust
	--         use_declaration = true,
	--       }
	--
	--       local default_handler = cmp_autopairs.filetypes["*"]["("].handler
	--       cmp_autopairs.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
	--         local node_type = ts_utils.get_node_at_cursor():type()
	--         if ts_node_func_parens_disabled[node_type] then
	--           if item.data then
	--             item.data.funcParensDisabled = true
	--           else
	--             char = ""
	--           end
	--         end
	--         default_handler(char, item, bufnr, rules, commit_character)
	--       end
	--
	--       cmp.event:on(
	--         "confirm_done",
	--         cmp_autopairs.on_confirm_done({
	--           filetypes = {
	--             sh = false,
	--           },
	--         })
	--       )
	--     end,
	--   },
	-- }
}
