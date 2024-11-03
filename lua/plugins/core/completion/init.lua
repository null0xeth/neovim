local vim = vim
local fn = vim.fn
local api = vim.api

local spec = {
{
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  cmd = "CopilotChat",
  opts = function()
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)
    return {
      auto_insert_mode = true,
      show_help = true,
      question_header = "  " .. user .. " ",
      answer_header = "  Copilot ",
      window = {
        width = 0.4,
      },
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,
    }
  end,
  keys = {
    { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    {
      "<leader>aa",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>ax",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Clear (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>aq",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input)
        end
      end,
      desc = "Quick Chat (CopilotChat)",
      mode = { "n", "v" },
    },
    -- Show help actions with telescope
    { "<leader>ad", M.pick("help"), desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
    -- Show prompts actions with telescope
    { "<leader>ap", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
  },
  config = function(_, opts)
    local chat = require("CopilotChat")
    require("CopilotChat.integrations.cmp").setup()

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
      end,
    })

    chat.setup(opts)
  end,
},
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
    event = "KindaLazy", -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    -- use a release tag to download pre-built binaries
    version = "v0.5.1",
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    --build = "nix run .#build-plugin",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      fuzzy = {
        prebuilt_binaries = {
          download = true,
          force_version = "v0.5.0",
        },
      },
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = "default" },

      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",

      -- experimental auto-brackets support
      accept = { auto_brackets = { enabled = true } },

      trigger = { signature_help = { enabled = true } },
      windows = {
        autocomplete = {
          draw = "reversed",
          winblend = vim.o.pumblend,
        },
        documentation = {
          auto_show = true,
        },
        ghost_text = {
          enabled = false,
        },
      },
      keymap = {
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_in_snippet() then
              return cmp.accept()
            elseif require("copilot.suggestion").is_visible() then
              LazyVim.create_undo()
              require("copilot.suggestion").accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
      },
      sources = {
        completion = {
          -- add lazydev to your completion providers
          enabled_providers = { "lazydev" },
        },
        providers = {
          lsp = {
            -- dont show LuaLS require statements when lazydev has items
            fallback_for = { "lazydev", "lsp", "path", "snippets", "buffer" },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
          },
        },
      },
    },
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

return spec
