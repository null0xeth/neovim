--local config = require("config")

local spec = {
  -- {
  --   "altermo/iedit.nvim",
  --   event = "KindaLazy",
  --   config = function()
  --     require("iedit").setup()
  --   end,
  -- },
  {
    "google/executor.nvim",
    event = "KindaLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      -- your setup here
      require("executor").setup({
        -- View details of the task run in a split, rather than a popup window.
        -- Set this to `false` to use a popup.
        use_split = true,

        -- Configure the split. These are ignored if you are using a popup.
        split = {
          -- One of "top", "right", "bottom" or "left"
          position = "bottom",
          -- The number of columns to take up. This sets the split to 1/4 of the
          -- space. If you're using the split at the top or bottom, you could also
          -- use `vim.o.lines` to set this relative to the height of the window.
          size = math.floor(vim.o.lines * 1 / 4),
        },

        -- Configure the popup. These are ignored if you are using a split.
        popup = {
          -- Sets the width of the popup to 3/5ths of the screen's width.
          width = math.floor(vim.o.columns * 3 / 5),
          -- Sets the height to almost full height, allowing for some padding.
          height = vim.o.lines - 20,
          -- Border styles
          border = {
            padding = {
              top = 2,
              bottom = 2,
              left = 3,
              right = 3,
            },
            style = "rounded",
          },
        },
        -- Filter output from commands. See *filtering_output* below for more
        output_filter = function(command, lines)
          return lines
        end,

        notifications = {
          -- Show a popup notification when a task is started.
          task_started = true,
          -- Show a popup notification when a task is completed.
          task_completed = true,
          -- Border styles
          border = {
            padding = {
              top = 0,
              bottom = 0,
              left = 1,
              right = 1,
            },
            style = "rounded",
          },
        },
        statusline = {
          prefix = "Executor: ",
          icons = {
            in_progress = "…",
            failed = "✖ ",
            passed = "✓",
          },
        },
      })
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    keys = {
      { "<leader>R", "", desc = "+Rest" },
      { "<leader>Rs", "<cmd>lua require('kulala').run()<cr>", desc = "Send the request" },
      { "<leader>Rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body" },
      { "<leader>Rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "Jump to previous request" },
      { "<leader>Rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "Jump to next request" },
    },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "http", "graphql" },
    },
  },
  {
    "echasnovski/mini.hipatterns",
    recommended = true,
    desc = "Highlight colors in your code. Also includes Tailwind CSS support.",
    event = "LazyFile",
    opts = function()
      local hi = require("mini.hipatterns")
      return {
        -- custom LazyVim option to enable the tailwind integration
        tailwind = {
          enabled = true,
          ft = {
            "astro",
            "css",
            "heex",
            "html",
            "html-eex",
            "javascript",
            "javascriptreact",
            "rust",
            "svelte",
            "typescript",
            "typescriptreact",
            "vue",
          },
          -- full: the whole css class will be highlighted
          -- compact: only the color will be highlighted
          style = "full",
        },
        highlighters = {
          hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
          shorthand = {
            pattern = "()#%x%x%x()%f[^%x%w]",
            group = function(_, _, data)
              ---@type string
              local match = data.full_match
              local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
              local hex_color = "#" .. r .. r .. g .. g .. b .. b

              return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
            end,
            extmark_opts = { priority = 2000 },
          },
        },
      }
    end,
    config = function(_, opts)
      if type(opts.tailwind) == "table" and opts.tailwind.enabled then
        -- reset hl groups when colorscheme changes
        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            M.hl = {}
          end,
        })
        opts.highlighters.tailwind = {
          pattern = function()
            if not vim.tbl_contains(opts.tailwind.ft, vim.bo.filetype) then
              return
            end
            if opts.tailwind.style == "full" then
              return "%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]"
            elseif opts.tailwind.style == "compact" then
              return "%f[%w:-][%w:-]+%-()[a-z%-]+%-%d+()%f[^%w:-]"
            end
          end,
          group = function(_, _, m)
            ---@type string
            local match = m.full_match
            ---@type string, number
            local color, shade = match:match("[%w-]+%-([a-z%-]+)%-(%d+)")
            shade = tonumber(shade)
            local bg = vim.tbl_get(M.colors, color, shade)
            if bg then
              local hl = "MiniHipatternsTailwind" .. color .. shade
              if not M.hl[hl] then
                M.hl[hl] = true
                local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
                local fg = vim.tbl_get(M.colors, color, bg_shade)
                vim.api.nvim_set_hl(0, hl, { bg = "#" .. bg, fg = "#" .. fg })
              end
              return hl
            end
          end,
          extmark_opts = { priority = 2000 },
        }
      end
      require("mini.hipatterns").setup(opts)
    end,
  },
  {
    "gbprod/cutlass.nvim",
    event = "KindaLazy",
    config = function(_, opts)
      require("cutlass").setup({
        cut_key = "x",
        override_del = true,
        exclude = {},
        registers = {
          select = "s",
          delete = "d",
          change = "c",
        },
      })
    end,
  },
  {
    "numToStr/FTerm.nvim",
    event = "KindaLazy",
    keys = {
      {
        "<c-/>",
        function()
          require("FTerm").toggle()
        end,
      },
    },
    config = function()
      require("FTerm").setup({
        border = "double",
        dimensions = {
          height = 0.9,
          width = 0.9,
        },
      })
    end,
  },
  -- {
  --   "gbprod/substitute.nvim",
  --   opts = {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --     on_substitute = nil,
  --     yank_substituted_text = true,
  --     preserve_cursor_position = true,
  --     modifiers = nil,
  --     highlight_substituted_text = {
  --       enabled = true,
  --       timer = 500,
  --     },
  --     range = {
  --       prefix = "s",
  --       prompt_current_text = false,
  --       confirm = false,
  --       complete_word = false,
  --       subject = nil,
  --       range = nil,
  --       suffix = "",
  --       auto_apply = false,
  --       cursor_position = "end",
  --     },
  --     exchange = {
  --       motion = false,
  --       use_esc_to_cancel = true,
  --       preserve_cursor_position = false,
  --     },
  --   },
  -- },
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
      {
        "<leader>sr",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = " rip substitute",
      },
    },
    config = function()
      require("rip-substitute").setup({
        popupWin = {
          title = " rip-substitute",
          border = "single",
          matchCountHlGroup = "Keyword",
          noMatchHlGroup = "ErrorMsg",
          hideSearchReplaceLabels = false,
          ---@type "top"|"bottom"
          position = "bottom",
        },
        prefill = {
          ---@type "cursorWord"| false
          normal = "cursorWord",
          ---@type "selectionFirstLine"| false does not work with ex-command (see README).
          visual = "selectionFirstLine",
          startInReplaceLineIfPrefill = false,
        },
        keymaps = { -- normal & visual mode, if not stated otherwise
          abort = "q",
          confirm = "<CR>",
          insertModeConfirm = "<C-CR>",
          prevSubst = "<Up>",
          nextSubst = "<Down>",
          toggleFixedStrings = "<C-f>", -- ripgrep's `--fixed-strings`
          toggleIgnoreCase = "<C-c>", -- ripgrep's `--ignore-case`
          openAtRegex101 = "R",
        },
        incrementalPreview = {
          matchHlGroup = "IncSearch",
          rangeBackdrop = {
            enabled = true,
            blend = 50, -- between 0 and 100
          },
        },
        regexOptions = {
          startWithFixedStringsOn = false,
          startWithIgnoreCase = false,
          -- pcre2 enables lookarounds and backreferences, but performs slower
          pcre2 = true,
          -- disable if you use named capture groups (see README for details)
          autoBraceSimpleCaptureGroups = true,
        },
        editingBehavior = {
          -- When typing `()` in the `search` line, automatically adds `$n` to the
          -- `replace` line.
          autoCaptureGroups = false,
        },
        notificationOnSuccess = true,
      })
    end,
  },
  -- {
  --   "akinsho/toggleterm.nvim",
  --   cmd = { "ToggleTerm", "TermExec" },
  --   keys = {
  --     { [[<C-\>]] },
  --     { "<leader>vt", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal" },
  --   },
  --   opts = {
  --     --size = 25,
  --     size = function(term)
  --       if term.direction == "horizontal" then
  --         return vim.o.lines / 2
  --       elseif term.direction == "vertical" then
  --         return vim.o.columns / 2
  --       end
  --     end,

  --     hide_numbers = true, --true
  --     open_mapping = [[<C-\>]],
  --     shade_filetypes = {},
  --     shade_terminals = true, --false
  --     shading_factor = 1, -- 0.3
  --     start_in_insert = true,
  --     insert_mappings = true,
  --     persist_size = true,
  --     direction = "horizontal",
  --     close_on_exit = false,
  --     auto_scroll = false,
  --     autchdir = false,
  --     winbar = {
  --       enabled = false,
  --       name_formatter = function(term)
  --         return term.name
  --       end,
  --     },
  --   },
  -- },
  {
    "tzachar/highlight-undo.nvim",
    keys = { "u", "U" },
    opts = {
      duration = 250,
      undo = {
        lhs = "u",
        map = "silent undo",
        opts = { desc = "󰕌 Undo" },
      },
      redo = {
        lhs = "U",
        map = "silent redo",
        opts = { desc = "󰑎 Redo" },
      },
    },
  },
  -- search/replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sg",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.grug_far({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "chrisgrieser/nvim-origami",
    event = "KindaLazy",
    keys = {
      {
        "<leader>efl",
        function()
          require("origami").h()
        end,
        desc = "(Origami) Fold line",
      },
      {
        "<leader>efu",
        function()
          require("origami").l()
        end,
        desc = "(Origami) Unfold line",
      },
    },
    config = function()
      require("origami").setup({
        keepFoldsAcrossSessions = true,
        pauseFoldsOnSearch = true,
        setupFoldKeymaps = false,
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    keys = {
      { "gc", mode = { "n", "v" } },
      { "gcc", mode = { "n", "v" } },
      { "gbc", mode = { "n", "v" } },
    },
    config = function()
      require("Comment").setup({
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "KindaLazy",
    opts_extend = { "spec" },
    opts = function()
      local config = require("config")
      return {
        defaults = {},
        spec = config.keymap_categories,
      }
    end,

    -- {
    --   defaults = {},
    --   spec = config.keymap_categories,
    -- },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      --wk.register(opts.defaults)
    end,
  },
}

return spec
