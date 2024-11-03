local b = vim.b

local spec = {
  { -- fixes scrolloff at end of file
    "Aasim-A/scrollEOF.nvim",
    event = "CursorMoved",
    opts = true,
  },
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    config = function()
      local theme_colors = require("catppuccin.palettes").get_palette("macchiato")
      require("tiny-devicons-auto-colors").setup({
        colors = theme_colors,
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "KindaLazy",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      local autocmdcontroller = require("framework.controller.autocmdcontroller"):new()
      autocmdcontroller:add_autocmd({
        event = "FileType",
        pattern = {
          "alpha",
          "dashboard",
          "fzf",
          "help",
          "lazy",
          "lazyterm",
          "mason",
          "neo-tree",
          "notify",
          "toggleterm",
          "Trouble",
          "trouble",
        },
        command_or_callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    tag = "v3.8.2",
    event = "KindaLazy",
    config = function()
      require("ibl").setup({
        scope = {
          enabled = false,
        },
      })
      --      {
      --   indent = {
      --     char = "",
      --     tab_char = "",
      --   },
      --   scope = { show_start = false, show_end = false },
      --   exclude = {
      --     buftypes = { "terminal", "nofile", "telescope" },
      --     filetypes = {
      --       "alpha",
      --       "Float",
      --       "help",
      --       "markdown",
      --       "dapui_scopes",
      --       "dapui_stacks",
      --       "dapui_watches",
      --       "dapui_breakpoints",
      --       "dapui_hover",
      --       "dap-repl",
      --       "edgy",
      --       "term",
      --       "fugitive",
      --       "fugitiveblame",
      --       "neo-tree",
      --       "neotest-summary",
      --       "Outline",
      --       "lsp-installer",
      --       "mason",
      --       "aerial",
      --       "netrw",
      --       "vimwiki",
      --       "dashboard",
      --       "Trouble",
      --       "trouble",
      --       "lazy",
      --       "notify",
      --       "toggleterm",
      --       "lspinfo",
      --       "checkhealth",
      --       "TelescopePrompt",
      --       "TelescopeResults",
      --     },
      --   },
      -- })
    end,
  },
  {
    "andymass/vim-matchup",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = "KindaLazy",
    keys = {
      { "m", "<Plug>(matchup-%)", desc = "Goto Matching Bracket" },
    },
    init = function()
      -- vim.g.matchup_enabled = true
      -- vim.g.matchup_surround_enabled = 0
      -- vim.g.matchup_transmute_enabled = 0
      -- vim.g.matchup_matchparen_deferred = 1
      -- vim.g.matchup_matchparen_hi_surround_always = 1
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "KindaLazy",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
    {
      "neovim/nvim-lspconfig",
      opts = { document_highlight = { enabled = false } },
    },
    -- opts = {
    --   providers = {
    --     "lsp",
    --     "treesitter",
    --     "regex",
    --   },
    --   delay = 100,
    --   large_file_cutoff = 2000,
    --   large_file_overrides = {
    --     providers = { "lsp" },
    --   },
    --   filetypes_denylist = {
    --     "",
    --     "help",
    --     "markdown",
    --     "dapui_scopes",
    --     "dapui_stacks",
    --     "dapui_watches",
    --     "dapui_breakpoints",
    --     "dapui_hover",
    --     "dap-repl",
    --     "edgy",
    --     "term",
    --     "fugitive",
    --     "fugitiveblame",
    --     "neo-tree",
    --     "neotest-summary",
    --     "Outline",
    --     "lsp-installer",
    --     "mason",
    --     "aerial",
    --     "netrw",
    --     "vimwiki",
    --     "dashboard",
    --     "Trouble",
    --     "trouble",
    --     "lazy",
    --     "notify",
    --     "toggleterm",
    --     "lspinfo",
    --     "checkhealth",
    --     "TelescopePrompt",
    --     "TelescopeResults",
    --   },
    -- },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
  {
    "echasnovski/mini.icons",
    event = "KindaLazy",
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "m-demare/hlargs.nvim",
    event = "KindaLazy",
    opts = {
      color = "#ef9062",
      use_colorpalette = false,
      disable = function(_, bufnr)
        if b.semantic_tokens then
          return true
        end
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        for _, c in pairs(clients) do
          local caps = c.server_capabilities
          if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            b.semantic_tokens = true
            return b.semantic_tokens
          end
        end
      end,
    },
  },
}

return spec
