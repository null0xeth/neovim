return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft, {
        ["_"] = { "trim_whitespace" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- move dis to other langs
      opts.linters_by_ft["sh"] = { "shellcheck" }
    end,
  },
  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },
  {
    "chrisgrieser/nvim-justice",
    ft = "just",
    config = function()
      require("justice").setup()
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "hyprlang", "git_config", "just" },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.hadolint,   -- dockerfile
        nls.builtins.diagnostics.actionlint, --github actions
        nls.builtins.diagnostics.checkmake,  --check makefiles
        nls.builtins.diagnostics.gitlint,    --git
        nls.builtins.diagnostics.zsh,        --zsh

        -- move
        nls.builtins.formatting.packer,    --hcp packer
        --nls.builtins.formatting.prettierd, --prettierd
        nls.builtins.formatting.pg_format, --pgsql
        nls.builtins.formatting.shfmt,     --bash
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      -- make sure mason installs the server
      servers = {
        dockerls = {
          cmd = {
            "docker-langserver",
            "--stdio",
          },
          settings = {},
        },
        bashls = {},
        hyprls = {},
        docker_compose_language_service = {},
        gitlab_ci_ls = {},
        jinja_lsp = {},
      },
      setup = {
        dockerls = function(_, opts)
          local lspcontroller = require("framework.controller.lspController"):new()
          lspcontroller:setup_lsp_servers(_, opts.dockerls)
        end,
        hyprls = function(_, opts)
          vim.filetype.add({
            --extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
            pattern = {
              [".*/hyprland%.conf$"] = "hyprlang"
              -- [".*/waybar/config"] = "jsonc",
              -- [".*/mako/config"] = "dosini",
              -- [".*/kitty/.+%.conf"] = "bash",
              -- [".*/hypr/.+%.conf"] = "hyprlang",
              -- [".*hyprland.conf"] = "hyprlang",
              -- ["%.env%.[%w_.-]+"] = "sh",
            },
          })
          local lspcontroller = require("framework.controller.lspController"):new()
          lspcontroller:setup_lsp_servers(_, opts.hyprls)
        end,
        jinja_lsp = function(_, opts)
          local lspcontroller = require("framework.controller.lspController"):new()
          lspcontroller:setup_lsp_servers(_, opts.jinja_lsp)
        end,
        docker_compose_language_service = function(_, opts)
          local lspcontroller = require("framework.controller.lspController"):new()
          lspcontroller:setup_lsp_servers(_, opts.docker_compose_language_service)
        end,
        gitlab_ci_ls = function(_, opts)
          local lspcontroller = require("framework.controller.lspController"):new()
          lspcontroller:setup_lsp_servers(_, opts.gitlab_ci_ls)
        end,

        bashls = function(_, opts)
          local lspcontroller = require("framework.controller.lspController"):new()
          lspcontroller:setup_lsp_servers(_, opts.bashls)
        end,
      },
    },
  },
}
