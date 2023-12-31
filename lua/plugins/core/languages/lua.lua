local spec = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "lua",
        "luadoc",
        "luap",
      })
    end,
  },
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
          --return {
          --cmd = { "/etc/profiles/per-user/null0x/bin/lua-language-server" },
          settings = {
            Lua = {
              -- runtime = {
              --   version = "LuaJIT",
              --   path = {
              --     "lua/?.lua",
              --     "lua/?/init.lua",
              --   },
              -- },
              -- intelliSense = {
              --   traceLocalSet = true,
              -- },
              -- workspace = {
              --   checkThirdParty = true,
              --   library = {
              --     -- [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              --     -- [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
              --     vim.fn.expand("$VIMRUNTIME"),
              --     "${3rd}/luassert/library",
              --     "${3rd}/luv/library",
              --   },
              -- },
              completion = {
                workspaceWord = true,
                callSnippet = "Replace",
                keywordSnippet = "Replace",
                showWord = "Disable",
                postfix = ".",
                displayContext = false,
              },
              diagnostics = {
                globals = { "vim" }, -- is new
                virtual_text = { prefix = "icons" },
                disable = {
                  "need-check-nil",
                  "duplicate-set-field",
                  "incomplete-signature-doc",
                  "trailing-space",
                  "no-unknown",
                  "param-type-mismatch",
                  "undefined-field",
                },
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
              telemetry = { enable = false },
              hover = {
                expandAlias = false,
              },
              hint = {
                enable = false, -- enable = false
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
              window = {
                progressBar = true,
                statusBar = false,
              },
            },
          },
          handlers = {
            -- always go to the first definition
            ["textDocument/definition"] = function(err, result, ...)
              if vim.tbl_islist(result) or type(result) == "table" then
                result = result[1]
              end
              vim.lsp.handlers["textDocument/definition"](err, result, ...)
            end,
          },
        },
        --end,
      },
      setup = {
        lua_ls = function(_, opts)
          vim.schedule_wrap(function()
            local lspcontroller = require("framework.controller.lspcontroller"):new()
            lspcontroller:setup_lsp_servers(_, opts)
          end)()
        end,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-neotest/neotest-plenary" },
    opts = function(_, opts)
      opts.adapters = vim.list_extend(opts.adapters, { require("neotest-plenary") })
    end,
  },
  {
    "mfussenegger/nvim-dap",
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
