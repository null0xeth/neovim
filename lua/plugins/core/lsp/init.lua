local spec = {
  {
    'williamboman/mason.nvim',
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {},
    },
    config = function(_, opts)
      local lspcontroller = require("framework.controller.lspcontroller"):new()
      lspcontroller:setup_mason(opts)
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'williamboman/mason.nvim',
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {},
      auto_install = true,
      handlers = {},
    },
    opts_extend = { "ensure_installed", "handlers" },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      'williamboman/mason.nvim',
      "nvimtools/none-ls.nvim",
    },
    opts = {
      automatic_installation = true,
      ensure_installed = {},
      handlers = {},
      methods = {
        diagnostics = true,
        code_actions = true,
        formatting = true,
        completion = true,
        hover = true,
      },
    },
    opts_extend = { "ensure_installed", "handlers" },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason-lspconfig.nvim" },
      { "jay-babu/mason-null-ls.nvim" },
    },
    opts = {
      servers = {},
      setup = {},
      format = {},
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "KindaLazy",
    dependencies = {
      { "smjonas/inc-rename.nvim" },
      { "VonHeikemen/lsp-zero.nvim" },
    },
    opts = {
      servers = {},
      setup = {},
      format = {},
      capabilities = {
        worksapces = {
          dirChangeWatchedFiles = {
            dynamicRegistration = false,
          },
        },
      }
    },

    config = function(plugin, opts)
      local lspcontroller = require("framework.controller.lspcontroller"):new()
      lspcontroller:setup_lsp_servers(plugin, opts)
      -- local lspconfig = require('lspconfig')
      -- for server, config in pairs(opts.servers) do
      --   config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
      --   lspconfig[server].setup(config)
      -- end
    end,
  },
  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      -- your options here
      aggressive_mode = false,
      excluded_lsp_clients = {
        "null-ls",
        "jdtls",
        "marksman",
      },
      grace_period = (60 * 15),
      wakeup_delay = 3000,
      notifications = false,
      retries = 3,
      timeout = 1000,
    },
  },
  {
    "stevearc/conform.nvim",
    event = "BufReadPre",
    cmd = { "ConformInfo" },
    opts_extend = { "formatters_by_ft", "formatters" },
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
        async = false,
        quiet = true,
      },
      format_after_save = {
        lsp_format = "fallback",
      },
    },
  },
  -- {
  --   "mhartington/formatter.nvim",
  --   enabled = false,
  --   event = "BufReadPre",
  --   config = function()
  --     local cachecontroller = require("framework.controller.cachecontroller"):new()
  --     local formatters = cachecontroller:query("formatters")
  --     require("formatter").setup(formatters)
  --   end,
  -- },
  {
    "zeioth/none-ls-autoload.nvim",
    event = "BufEnter",
    dependencies = {
      "williamboman/mason.nvim",
      "zeioth/none-ls-external-sources.nvim", -- To install a external sources library.
    },
    opts_extend = { "external_sources" },
    opts = {
      external_sources = {
        -- diagnostics
        -- "none-ls-external-sources.diagnostics.cpplint",
        --"none-ls-external-sources.diagnostics.eslint_d",
        "none-ls-external-sources.diagnostics.luacheck",
        "none-ls-external-sources.diagnostics.yamllint",
        -- formatting
        "none-ls-external-sources.formatting.beautysh",
        "none-ls-external-sources.formatting.easy-coding-standard",
        --"none-ls-external-sources.formatting.eslint_d",
        "none-ls-external-sources.formatting.jq",
        -- "none-ls-external-sources.formatting.latexindent",
        -- "none-ls-external-sources.formatting.standardrb",
        "none-ls-external-sources.formatting.yq",

        -- code actions
        -- "none-ls-external-sources.code_actions.eslint",
        -- "none-ls-external-sources.code_actions.eslint_d",
        "none-ls-external-sources.code_actions.shellcheck",
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    event = "KindaLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "gbprod/none-ls-shellcheck.nvim",
    },
    opts_extend = { "sources" },
    opts = function(_, opts)
      local nls = require("null-ls")
      local shellcheck = require("none-ls-shellcheck")
      opts.root_dir = opts.root_dir
          or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.actionlint, -- gh actions
        shellcheck.diagnostics,
        shellcheck.code_actions,
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      linters_by_ft = {
        html = { "tidy" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft
    end,
  },
}
return spec
