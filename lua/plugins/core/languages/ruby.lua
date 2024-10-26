local spepc = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "ruby",
      },
    },
  },
  {
    "tpope/vim-rake",
    ft = "ruby",
    config = true,
  },
  {
    "tpope/vim-bundler",
    ft = "ruby",
    config = true,
  },
  {
    "tpope/vim-rails",
    ft = "ruby",
    config = true,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ruby = { formatter },
        eruby = { "erb-format" },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "erb-formatter", "erb-lint" } },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    opts = {
      servers = {
        ruby_lsp = { --function()
          init_options = {
            formatter = "auto",
            experimentalFeaturesEnabled = true,
            enabledFeatures = {
              codeActions = true,
              codeLens = true,
              completion = true,
              definition = true,
              diagnostics = true,
              documentHighlights = true,
              documentLink = true,
              documentSymbols = true,
              foldingRanges = true,
              formatting = true,
              hover = true,
              inlayHint = true,
              onTypeFormatting = true,
              selectionRanges = true,
              semanticHighlighting = true,
              signatureHelp = true,
              typeHierarchy = true,
              workspaceSymbol = true,
            },
          },
        },
        --end,
      },
      setup = {
        ruby_lsp = function(_, opts)
          local lspcontroller = require("framework.controller.lspcontroller"):new()
          lspcontroller:setup_lsp_servers(_, opts)
        end,
      },
    },
  },
}

return spec
