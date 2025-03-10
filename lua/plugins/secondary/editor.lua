--local config = require("config")
local M = {}

---@type table<string,true>
M.hl = {}

M.colors = {
  slate = {
    [50] = "f8fafc",
    [100] = "f1f5f9",
    [200] = "e2e8f0",
    [300] = "cbd5e1",
    [400] = "94a3b8",
    [500] = "64748b",
    [600] = "475569",
    [700] = "334155",
    [800] = "1e293b",
    [900] = "0f172a",
    [950] = "020617",
  },

  gray = {
    [50] = "f9fafb",
    [100] = "f3f4f6",
    [200] = "e5e7eb",
    [300] = "d1d5db",
    [400] = "9ca3af",
    [500] = "6b7280",
    [600] = "4b5563",
    [700] = "374151",
    [800] = "1f2937",
    [900] = "111827",
    [950] = "030712",
  },

  zinc = {
    [50] = "fafafa",
    [100] = "f4f4f5",
    [200] = "e4e4e7",
    [300] = "d4d4d8",
    [400] = "a1a1aa",
    [500] = "71717a",
    [600] = "52525b",
    [700] = "3f3f46",
    [800] = "27272a",
    [900] = "18181b",
    [950] = "09090B",
  },

  neutral = {
    [50] = "fafafa",
    [100] = "f5f5f5",
    [200] = "e5e5e5",
    [300] = "d4d4d4",
    [400] = "a3a3a3",
    [500] = "737373",
    [600] = "525252",
    [700] = "404040",
    [800] = "262626",
    [900] = "171717",
    [950] = "0a0a0a",
  },

  stone = {
    [50] = "fafaf9",
    [100] = "f5f5f4",
    [200] = "e7e5e4",
    [300] = "d6d3d1",
    [400] = "a8a29e",
    [500] = "78716c",
    [600] = "57534e",
    [700] = "44403c",
    [800] = "292524",
    [900] = "1c1917",
    [950] = "0a0a0a",
  },

  red = {
    [50] = "fef2f2",
    [100] = "fee2e2",
    [200] = "fecaca",
    [300] = "fca5a5",
    [400] = "f87171",
    [500] = "ef4444",
    [600] = "dc2626",
    [700] = "b91c1c",
    [800] = "991b1b",
    [900] = "7f1d1d",
    [950] = "450a0a",
  },

  orange = {
    [50] = "fff7ed",
    [100] = "ffedd5",
    [200] = "fed7aa",
    [300] = "fdba74",
    [400] = "fb923c",
    [500] = "f97316",
    [600] = "ea580c",
    [700] = "c2410c",
    [800] = "9a3412",
    [900] = "7c2d12",
    [950] = "431407",
  },

  amber = {
    [50] = "fffbeb",
    [100] = "fef3c7",
    [200] = "fde68a",
    [300] = "fcd34d",
    [400] = "fbbf24",
    [500] = "f59e0b",
    [600] = "d97706",
    [700] = "b45309",
    [800] = "92400e",
    [900] = "78350f",
    [950] = "451a03",
  },

  yellow = {
    [50] = "fefce8",
    [100] = "fef9c3",
    [200] = "fef08a",
    [300] = "fde047",
    [400] = "facc15",
    [500] = "eab308",
    [600] = "ca8a04",
    [700] = "a16207",
    [800] = "854d0e",
    [900] = "713f12",
    [950] = "422006",
  },

  lime = {
    [50] = "f7fee7",
    [100] = "ecfccb",
    [200] = "d9f99d",
    [300] = "bef264",
    [400] = "a3e635",
    [500] = "84cc16",
    [600] = "65a30d",
    [700] = "4d7c0f",
    [800] = "3f6212",
    [900] = "365314",
    [950] = "1a2e05",
  },

  green = {
    [50] = "f0fdf4",
    [100] = "dcfce7",
    [200] = "bbf7d0",
    [300] = "86efac",
    [400] = "4ade80",
    [500] = "22c55e",
    [600] = "16a34a",
    [700] = "15803d",
    [800] = "166534",
    [900] = "14532d",
    [950] = "052e16",
  },

  emerald = {
    [50] = "ecfdf5",
    [100] = "d1fae5",
    [200] = "a7f3d0",
    [300] = "6ee7b7",
    [400] = "34d399",
    [500] = "10b981",
    [600] = "059669",
    [700] = "047857",
    [800] = "065f46",
    [900] = "064e3b",
    [950] = "022c22",
  },

  teal = {
    [50] = "f0fdfa",
    [100] = "ccfbf1",
    [200] = "99f6e4",
    [300] = "5eead4",
    [400] = "2dd4bf",
    [500] = "14b8a6",
    [600] = "0d9488",
    [700] = "0f766e",
    [800] = "115e59",
    [900] = "134e4a",
    [950] = "042f2e",
  },

  cyan = {
    [50] = "ecfeff",
    [100] = "cffafe",
    [200] = "a5f3fc",
    [300] = "67e8f9",
    [400] = "22d3ee",
    [500] = "06b6d4",
    [600] = "0891b2",
    [700] = "0e7490",
    [800] = "155e75",
    [900] = "164e63",
    [950] = "083344",
  },

  sky = {
    [50] = "f0f9ff",
    [100] = "e0f2fe",
    [200] = "bae6fd",
    [300] = "7dd3fc",
    [400] = "38bdf8",
    [500] = "0ea5e9",
    [600] = "0284c7",
    [700] = "0369a1",
    [800] = "075985",
    [900] = "0c4a6e",
    [950] = "082f49",
  },

  blue = {
    [50] = "eff6ff",
    [100] = "dbeafe",
    [200] = "bfdbfe",
    [300] = "93c5fd",
    [400] = "60a5fa",
    [500] = "3b82f6",
    [600] = "2563eb",
    [700] = "1d4ed8",
    [800] = "1e40af",
    [900] = "1e3a8a",
    [950] = "172554",
  },

  indigo = {
    [50] = "eef2ff",
    [100] = "e0e7ff",
    [200] = "c7d2fe",
    [300] = "a5b4fc",
    [400] = "818cf8",
    [500] = "6366f1",
    [600] = "4f46e5",
    [700] = "4338ca",
    [800] = "3730a3",
    [900] = "312e81",
    [950] = "1e1b4b",
  },

  violet = {
    [50] = "f5f3ff",
    [100] = "ede9fe",
    [200] = "ddd6fe",
    [300] = "c4b5fd",
    [400] = "a78bfa",
    [500] = "8b5cf6",
    [600] = "7c3aed",
    [700] = "6d28d9",
    [800] = "5b21b6",
    [900] = "4c1d95",
    [950] = "2e1065",
  },

  purple = {
    [50] = "faf5ff",
    [100] = "f3e8ff",
    [200] = "e9d5ff",
    [300] = "d8b4fe",
    [400] = "c084fc",
    [500] = "a855f7",
    [600] = "9333ea",
    [700] = "7e22ce",
    [800] = "6b21a8",
    [900] = "581c87",
    [950] = "3b0764",
  },

  fuchsia = {
    [50] = "fdf4ff",
    [100] = "fae8ff",
    [200] = "f5d0fe",
    [300] = "f0abfc",
    [400] = "e879f9",
    [500] = "d946ef",
    [600] = "c026d3",
    [700] = "a21caf",
    [800] = "86198f",
    [900] = "701a75",
    [950] = "4a044e",
  },

  pink = {
    [50] = "fdf2f8",
    [100] = "fce7f3",
    [200] = "fbcfe8",
    [300] = "f9a8d4",
    [400] = "f472b6",
    [500] = "ec4899",
    [600] = "db2777",
    [700] = "be185d",
    [800] = "9d174d",
    [900] = "831843",
    [950] = "500724",
  },

  rose = {
    [50] = "fff1f2",
    [100] = "ffe4e6",
    [200] = "fecdd3",
    [300] = "fda4af",
    [400] = "fb7185",
    [500] = "f43f5e",
    [600] = "e11d48",
    [700] = "be123c",
    [800] = "9f1239",
    [900] = "881337",
    [950] = "4c0519",
  },
}
local spec = {
  -- {
  --   "altermo/iedit.nvim",
  --   event = "KindaLazy",
  --   config = function()
  --     require("iedit").setup()
  --   end,
  -- },
  -- {
  --   "isak102/ghostty.nvim",
  --   event = "KindaLazy",
  --   config = function()
  --     require("ghostty").setup()
  --   end,
  -- },
  {
    "ramilito/kubectl.nvim",
    opts = {},
    cmd = { 'Kubectl', 'Kubectx', 'Kubens' },
    keys = {
      { '<leader>k', '<cmd>lua require("kubectl").toggle()<cr>' },
      { '<C-k>',     '<Plug>(kubectl.kill)',                    ft = 'k8s_*' },
      { '7',         '<Plug>(kubectl.view_nodes)',              ft = 'k8s_*' },
      { '8',         '<Plug>(kubectl.view_overview)',           ft = 'k8s_*' },
      { '<C-t>',     '<Plug>(kubectl.view_top)',                ft = 'k8s_*' },
    },
    config = function()
      require("kubectl").setup({
        auto_refresh = {
          enabled = true,
          interval = 200, -- milliseconds
        },
        diff = {
          bin = "kubediff", -- or any other binary
        },
        namespace = "All",
        namespace_fallback = {}, -- If you have limited access you can list all the namespaces here
        notifications = {
          enabled = true,
          verbose = false,
          blend = 100,
        },
        hints = true,
        context = true,
        float_size = {
          -- Almost fullscreen:
          -- width = 1.0,
          -- height = 0.95, -- Setting it to 1 will cause bottom to be cutoff by statuscolumn

          -- For more context aware size:
          width = 0.9,
          height = 0.8,

          -- -- Might need to tweak these to get it centered when float is smaller
          -- col = 10,
          -- row = 5,
        },
        obj_fresh = 0, -- highlight if creation newer than number (in minutes)
        mappings = {
          -- exit = "<leader>uk",
        },
      })
      local group = vim.api.nvim_create_augroup("kubectl_mappings", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "k8s_*",
        callback = function(ev)
          local k = vim.keymap
          local opts = { buffer = ev.buf }
          for i = 1, 6 do
            pcall(k.del, "n", tostring(i), opts)
          end
        end,
      })
    end,
  },
  {
    "linrongbin16/lsp-progress.nvim",
    event = "KindaLazy",
    config = function()
      require("lsp-progress").setup({
        client_format = function(client_name, spinner, series_messages)
          if #series_messages == 0 then
            return nil
          end
          return {
            name = client_name,
            body = spinner .. " " .. table.concat(series_messages, ", "),
          }
        end,
        format = function(client_messages)
          --- @param name string
          --- @param msg string?
          --- @return string
          local function stringify(name, msg)
            return msg and string.format("%s %s", name, msg) or name
          end

          local sign = "" -- nf-fa-gear \uf013
          local lsp_clients = vim.lsp.get_clients()
          local messages_map = {}
          for _, climsg in ipairs(client_messages) do
            messages_map[climsg.name] = climsg.body
          end

          if #lsp_clients > 0 then
            table.sort(lsp_clients, function(a, b)
              return a.name < b.name
            end)
            local builder = {}
            for _, cli in ipairs(lsp_clients) do
              if
                  type(cli) == "table"
                  and type(cli.name) == "string"
                  and string.len(cli.name) > 0
              then
                if messages_map[cli.name] then
                  table.insert(
                    builder,
                    stringify(cli.name, messages_map[cli.name])
                  )
                else
                  table.insert(builder, stringify(cli.name))
                end
              end
            end
            if #builder > 0 then
              return sign .. " " .. table.concat(builder, ", ")
            end
          end
          return ""
        end,
      })

      local group = vim.api.nvim_create_augroup('kubectl_user', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = 'k8s_*',
        callback = function()
          vim.opt.titlestring = 'k8s: %t'
        end,
      })
      local group2 = vim.api.nvim_create_augroup('kubectl_mappings', { clear = false })
      vim.api.nvim_create_autocmd('FileType', {
        group = group2,
        pattern = 'k8s_*',
        callback = function(ev)
          vim.keymap.set('n', 'Z', function()
            local state = require 'kubectl.state'
            local current = state.getFilter()
            local faults_filter = '!1/1,!2/2,!3/3,!4/4,!5/5,!6/6,!7/7,!Completed,!Terminating'
            if current == faults_filter then
              state.setFilter ''
              return
            end
            state.setFilter(faults_filter)
          end, { buffer = ev.buf, desc = 'Toggle Faults' })
        end,
      })
    end,
  },
  -- {
  --   "samharju/yeet.nvim",
  --   dependencies = {
  --     "stevearc/dressing.nvim", -- optional, provides sane UX
  --   },
  --   version = "*",              -- use the latest release, remove for master
  --   cmd = "Yeet",
  --   opts = {},
  -- },
  {
    "junegunn/fzf",
    build = "./install --bin",
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    lazy = true,
    keys = {
      -- search
      { "<leader>sk", "<cmd> FzfLua keymaps <CR>",                                                                desc = "Show Keys" },
      { "<leader>sh", "<cmd> FzfLua help_tags <CR>",                                                              desc = "Help Page" },
      { "<leader>sc", "<cmd> FzfLua highlights <CR>",                                                             desc = "Highlights" },
      { "<leader>sf", "<cmd> FzfLua files<CR>",                                                                   desc = "Search files" },
      { "<leader>st", "<cmd> FzfLua live_grep<CR>",                                                               desc = "Live Grep" },
      { "<leader>sw", "<cmd> FzfLua grep_cWORD<CR>",                                                              mode = "n",                        desc = "Find current word" },
      { "<leader>sw", "<cmd> FzfLua grep_cWORD<CR>",                                                              mode = "v",                        desc = "Find current selection" },
      { "<leader>s/", "<cmd> FzfLua search_history<CR>",                                                          desc = "Search history" },
      { "<leader>sr", "<cmd> FzfLua oldfiles sort_mru=true sort_lastused=true include_current_session=true <CR>", desc = "Search recent" },
      { "<leader>sn", "<cmd> ObsidianQuickSwitch <CR>",                                                           desc = "Find Note" },
      -- git
      { "<leader>gc", "<cmd>FzfLua git_commits<CR>",                                                              desc = "Commits" },
      { "<leader>gs", "<cmd>FzfLua git_status<CR>",                                                               desc = "Status" },
      { "<C-p>",      "<cmd> FzfLua buffers sort_mru=true sort_lastused=true <CR>",                               desc = "[ ] Find existing buffers" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({
        fzf_opts = {
          ["--no-scrollbar"] = true,
          ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
        },
        winopts = {
          fzf_colors = true,
          preview = {
            scrollbar = false,
          },
        },
      })

      local config = require("fzf-lua.config")
      local actions = require("fzf-lua.actions")

      -- Quickfix
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
    end
  },
  {
    "google/executor.nvim",
    enabled = false,
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
  -- {
  --   "mistweaverco/kulala.nvim",
  --   ft = "http",
  --   keys = {
  --     { "<leader>R",  "",                                             desc = "+Rest" },
  --     { "<leader>Rs", "<cmd>lua require('kulala').run()<cr>",         desc = "Send the request" },
  --     { "<leader>Rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle headers/body" },
  --     { "<leader>Rp", "<cmd>lua require('kulala').jump_prev()<cr>",   desc = "Jump to previous request" },
  --     { "<leader>Rn", "<cmd>lua require('kulala').jump_next()<cr>",   desc = "Jump to next request" },
  --   },
  --   opts = {},
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "http", "graphql" },
    },
  },
  {
    "nosduco/remote-sshfs.nvim",
    event = "KindaLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {},
    -- Refer to the configuration section below
    -- or leave empty for defaults
  },
  {
    "Dan7h3x/neaterm.nvim",
    branch = "stable",
    event = "KindaLazy",
    opts = {
      -- Terminal settings
      shell = vim.o.shell,
      float_width = 0.5,
      float_height = 0.4,
      move_amount = 3,
      resize_amount = 2,
      border = 'rounded',

      -- Appearance
      highlights = {
        normal = 'Normal',
        border = 'FloatBorder',
        title = 'Title',
      },

      -- Window management
      min_width = 20,
      min_height = 3,


      -- custom terminals
      terminals = {
        ranger = {
          name = "Ranger",
          cmd = "ranger",
          type = "float",
          float_width = 0.8,
          float_height = 0.8,
          keymaps = {
            quit = "q",
            select = "<CR>",
            preview = "p",
          },
          on_exit = function(selected_file)
            if selected_file then
              vim.cmd('edit ' .. selected_file)
            end
          end
        },
        lazygit = {
          name = "LazyGit",
          cmd = "lazygit",
          type = "float",
          float_width = 0.9,
          float_height = 0.9,
          keymaps = {
            quit = "q",
            commit = "c",
            push = "P",
          },
        },
        btop = {
          name = "Btop",
          cmd = "btop",
          type = "float",
          float_width = 0.8,
          float_height = 0.8,
          keymaps = {
            quit = "q",
            help = "h",
          },
        },

      },

      -- Default keymaps
      use_default_keymaps = true,
      keymaps = {
        toggle = '<A-t>',
        new_vertical = '<C-\\>',
        new_horizontal = '<C-.>',
        new_float = '<C-A-t>',
        close = '<A-d>',
        next = '<C-PageDown>',
        prev = '<C-PageUp>',
        move_up = '<C-A-Up>',
        move_down = '<C-A-Down>',
        move_left = '<C-A-Left>',
        move_right = '<C-A-Right>',
        resize_up = '<C-S-Up>',
        resize_down = '<C-S-Down>',
        resize_left = '<C-S-Left>',
        resize_right = '<C-S-Right>',
        focus_bar = '<C-A-b>',
        repl_toggle = '<leader>rt',
        repl_send_line = '<leader>rl',
        repl_send_selection = '<leader>rs',
        repl_send_buffer = '<leader>rb',
        repl_clear = '<leader>rc',
        repl_history = '<leader>rh',
        repl_variables = '<leader>rv',
        repl_restart = '<leader>rR',
      },

      -- REPL configurations
      repl = {
        float_width = 0.6,
        float_height = 0.4,
        save_history = true,
        history_file = vim.fn.stdpath('data') .. '/neaterm_repl_history.json',
        max_history = 100,
        update_interval = 5000,
      },

      -- REPL language configurations
      repl_configs = {
        python = {
          name = "Python (IPython)",
          cmd = "ipython --no-autoindent --colors='Linux'",
          startup_cmds = {
            -- "import sys",
            -- "sys.ps1 = 'In []: '",
            -- "sys.ps2 = '   ....: '",
          },
          get_variables_cmd = "whos",
          inspect_variable_cmd = "?",
          exit_cmd = "exit()",
        },
        r = {
          name = "R (Radian)",
          cmd = "radian",
          startup_cmds = {
            -- "options(width = 80)",
            -- "options(prompt = 'R> ')",
          },
          get_variables_cmd = "ls.str()",
          inspect_variable_cmd = "str(",
          exit_cmd = "q(save='no')",
        },
        lua = {
          name = "Lua",
          cmd = "lua",
          exit_cmd = "os.exit()",
        },
        node = {
          name = "Node.js",
          cmd = "node",
          get_variables_cmd = "Object.keys(global)",
          exit_cmd = ".exit",
        },
        sh = {
          name = "Shell",
          cmd = vim.o.shell,
          startup_cmds = {
            "PS1='$ '",
            "TERM=xterm-256color",
          },
          get_variables_cmd = "set",
          inspect_variable_cmd = "echo $",
          exit_cmd = "exit",
        },
      },

      -- Terminal features
      features = {
        auto_insert = true,
        auto_close = true,
        restore_layout = true,
        smart_sizing = true,
        persistent_history = true,
        native_search = true,
        clipboard_sync = true,
        shell_integration = true,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },
  },
  {
    "echasnovski/mini.hipatterns",
    event = "KindaLazy",
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
          toggleIgnoreCase = "<C-c>",   -- ripgrep's `--ignore-case`
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
  -- {
  --   "MagicDuck/grug-far.nvim",
  --   opts = { headerMaxWidth = 80 },
  --   cmd = "GrugFar",
  --   keys = {
  --     {
  --       "<leader>sg",
  --       function()
  --         local grug = require("grug-far")
  --         local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
  --         grug.grug_far({
  --           transient = true,
  --           prefills = {
  --             filesFilter = ext and ext ~= "" and "*." .. ext or nil,
  --           },
  --         })
  --       end,
  --       mode = { "n", "v" },
  --       desc = "Search and Replace",
  --     },
  --   },
  -- },
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
      { "gc",  mode = { "n", "v" } },
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
