local spec = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "luadoc",
        "luap",
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    cmd = "LazyDev",
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
        { path = "neo-tree.nvim", mods = { "neo-tree" } },
        { path = "nui.nvim", mods = { "nui" } },
        { path = "nvim-ufo", mods = { "ufo" } },
      },
    },
  },
  -- Manage libuv types with lazy. Plugin will never be loaded
  { "Bilal2453/luvit-meta", lazy = true },

  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft, { lua = { "stylua" } })
      opts.formatters = {
        stylua = {
          --command = "/etc/profiles/per-user/null0x/bin/stylua",
          command = "stylua",
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- move dis to other langs
      opts.linters_by_ft["lua"] = { "luacheck" }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    opts = {
      servers = {
        lua_ls = { --function()
          settings = {
            Lua = {
              misc = {
                -- parameters = { "--loglevel=trace" },
              },
              -- hover = { expandAlias = false },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
            },
          },
        },
        --end,
      },
      setup = {
        lua_ls = function(_, opts)
          local lspcontroller = require("framework.controller.lspcontroller"):new()
          lspcontroller:setup_lsp_servers(_, opts)
        end,
      },
    },
  },
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = { "nvim-neotest/neotest-plenary" },
  --   opts = function(_, opts)
  --     opts.adapters = vim.list_extend(opts.adapters, { require("neotest-plenary") })
  --   end,
  -- },
  -- {
  --   "mfussenegger/nvim-dap",
  --   dependencies = {
  --     {
  --       "jbyuki/one-small-step-for-vimkind",
  --       config = function()
  --         vim.schedule_wrap(function()
  --           local dapcontroller = require("framework.controller.dapcontroller"):new()
  --           dapcontroller:get_lua_dap()
  --         end)()
  --       end,
  --     },
  --   },
  -- },
}

return spec
