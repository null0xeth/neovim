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
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  -- Manage libuv types with lazy. Plugin will never be loaded
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
        lua_ls = { --function()
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
                maxPreload = 1000,
                preloadFileSize = 500,
                ignoreSubmodules = true,
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                },
              },
              telemetry = {
                enable = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
                workspaceWord = false,
                showWord = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              -- misc = {
              --   -- parameters = { "--loglevel=trace" },
              -- },
              -- -- hover = { expandAlias = false },
              type = {
                castNumberToInteger = true,
              },
              hint = {
                enable = false,
                setType = false,
                paramType = false,
                paramName = "Disable",

                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              runtime = {
                version = "LuaJIT",
                pathStrict = true,
                -- Garbage collection settings for better performance
                gc = {
                  incremental = true,
                  generational = true
                }
              },
              diagnostics = {
                libraryFiles = "Disable",
                ignoredFiles = "Disable",
                disable = {
                  "incomplete-signature-doc",
                  "trailing-space",
                  "missing-parameter",
                  "no-unknown",
                },
                workspaceDelay = 3500,
                workspaceRate = 100,
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
