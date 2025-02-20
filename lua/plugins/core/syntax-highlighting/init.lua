local spec = {
  { -- virtual text context at the end of a scope
    "haringsrob/nvim_context_vt",
    event = "KindaLazy",
    dependencies = "nvim-treesitter/nvim-treesitter",

    opts = {
      prefix = " 󱞷",
      highlight = "NonText",
      min_rows = 12,
      disable_ft = { "markdown", "yaml", "css" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    event = "KindaLazy",
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    lazy = vim.fn.argc(-1) == 0,
    dependencies = {
      { "JoosepAlviste/nvim-ts-context-commentstring" },
      { "metiulekm/nvim-treesitter-endwise" },
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
    },
    --cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      sync_install = false,
      auto_install = true,
      ensure_installed = {
        "bash",
        "comment",
        "diff",
        "html",
        "markdown",
        "markdown_inline",
        "printf",
        "org",
        "query",
        "regex",
        "latex",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = false,
        },
      },
      matchup = {
        enable = true,
        include_match_words = true,
        enable_quotes = true,
        -- disable_virtual_text = false,
        -- disable = { "rust" },
      },
    },
    config = function(_, opts)
      local codingcontroller = require("framework.controller.codingcontroller"):new()
      codingcontroller:setup_treeshitter(opts)

      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      parser_config.kcl = {
        install_info = {
          url = "~/g/development/kcl/treesitter",      -- local path or git repo
          files = { "src/parser.c", "src/scanner.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
          -- optional entries:
          branch = "main",                             -- default branch in case of git repo if different from master
          generate_requires_npm = true,                -- if stand-alone parser without npm dependencies
          requires_generate_from_grammar = false,      -- if folder contains pre-generated src/parser.c
        },
        filetype = "kcl",                              -- if filetype does not match the parser name
      }
    end,
  },
  {
    "ckolkey/ts-node-action",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter" },
    -- stylua: ignore
    keys = {
      { "<leader>Sn", function() require("ts-node-action").node_action() end, desc = "TS Node Action" },
    },
  },
  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "<leader>Sj", "<cmd>TSJToggle<cr>", desc = "Toggle TS Split/Join" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    config = function()
      vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
          underline = true,
          virtual_text = {
            spacing = 5,
            severity_limit = 'Warning',
          },
          update_in_insert = true,
        }
      )

      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false
        },
      })
    end
  },
}
return spec
