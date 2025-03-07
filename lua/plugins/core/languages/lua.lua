local spec = {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
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
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  { "Bilal2453/luvit-meta", lazy = true },
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
        lua_ls = {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME
                }
              }
            })
          end,
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                checkThirdParty = 'Disable',
                ignoreDir = { '.git' },
              },
              telemetry = {
                enable = false,
              },
              hint = {
                enable = true,
              },
            },
          },
          disableFormatting = true,
        }, --function()
      },
      setup = {
        lua_ls = function(_, opts)
          local lspcontroller = require("framework.controller.lspcontroller"):new()
          lspcontroller:setup_lsp_servers(_, opts)
        end,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    enabled = false,
    dependencies = { "nvim-neotest/neotest-plenary" },
    opts = function(_, opts)
      opts.adapters = vim.list_extend(opts.adapters, { require("neotest-plenary") })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    enabled = false,
    dependencies = {
      {
        "jbyuki/one-small-step-for-vimkind",
        config = function()
          vim.schedule_wrap(function()
            local dapcontroller = require("framework.controller.dapcontroller"):new()
            dapcontroller:get_lua_dap()
          end)()
        end,
      },
    },
  },
}

return spec
