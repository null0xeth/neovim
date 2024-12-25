local spec = {
  {
    "Catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    --event = "VimEnter",
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      default_integrations = true,
      transparent_background = true,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      styles = {                 -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = { "bold" },
        functions = { "bold" },
        keywords = { "bold" },
        strings = { "italic" },
        variables = {},
        numbers = { "bold" },
        booleans = { "bold" },
        properties = { "italic" },
        types = { "bold" },
        operators = { "bold" },
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
      },
      integrations = {
        aerial = false,
        alpha = true,

        barbecue = {
          dim_dirname = true,
          bold_basename = true,
          dim_context = true,
          alt_background = false,
        },

        colorful_winsep = {
          enabled = false,
          color = "red",
        },

        diffview = true,
        dropbar = false,
        feline = false,
        fidget = true,
        fzf = true,
        gitsigns = true,
        grug_far = true,
        harpoon = true,
        headlines = false,
        hop = false,
        indent_blankline = {
          enabled = true,
          scope_color = "flamingo",
          colored_indent_levels = false,
        },
        leap = false,
        lightspeed = false,
        lir = {
          enabled = false,
          git_status = false,
        },
        lsp_saga = false,
        markdown = true,
        mason = true,
        mini = {
          enabled = true,
          indentscope_color = "lavender",
        },
        neotree = true,
        neogit = false,
        neotest = false,
        noice = true,
        notifier = false,
        cmp = true,
        blink_cmp = true,
        dap = false,
        dap_ui = false,

        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          -- underlines = {
          --   errors = { "undercurl" },
          --   hints = { "undercurl" },
          --   warnings = { "undercurl" },
          --   information = { "undercurl" },
          -- },
          inlay_hints = {
            background = true,
          },
        },
        navic = {
          enabled = false,
          custom_bg = "NONE", -- custom_bg = "NONE"
        },
        notify = true,
        semantic_tokens = true,
        nvim_surround = true,
        nvimtree = false,
        treesitter_context = true,
        treesitter = true,
        ufo = true,
        window_picker = true,
        octo = false,
        overseer = false,
        pounce = false,
        rainbow_delimiters = false,
        render_markdown = false,
        symbols_outline = false, --symbols-outline.nvim <- install dis
        telekasten = false,
        telescope = { enabled = true },
        lsp_trouble = true,
        dadbod_ui = false,
        illuminate = {
          enabled = true,
          lsp = true,
        },
        sandwich = false,
        vim_sneak = false,
        vimwiki = false,
        which_key = true,
      },
    },

    config = function(_, opts)
      --vim.schedule_wrap(function()
      require("catppuccin").setup(opts)
      vim.opt.termguicolors = true
      vim.cmd.colorscheme("catppuccin")
      --end)()
    end,
  },
}

return spec
