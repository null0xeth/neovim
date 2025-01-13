return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "kcl",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["kcl"] = { "kcl" },
      },
    },
  },
  {
    "kcl-lang/kcl.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    ft = "kcl",
    setup = function()
      vim.filetype.add({
        name = "kcl",
        alias = {
          "kcl",
        },
        extension = {
          k = "kcl",
        },
        pattern = {
          ["^%w*%.k$"] = "kcl", -- Replace "your_filetype" with the desired filetype
        },
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kcl = {},
      },
      setup = {
        kcl = function(_, opts)
          vim.schedule_wrap(function()
            local lspcontroller = require("framework.controller.lspcontroller"):new()
            lspcontroller:setup_lsp_servers(_, opts)
          end)()
        end,
      },
    },
  },
}
