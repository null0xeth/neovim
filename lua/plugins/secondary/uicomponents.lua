---@class snacks.util
local M = {}

---@alias snacks.util.hl table<string, string|vim.api.keyset.highlight>

local hl_groups = {} ---@type table<string, vim.api.keyset.highlight>
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("snacks_util_hl", { clear = true }),
  callback = function()
    for hl_group, hl in pairs(hl_groups) do
      vim.api.nvim_set_hl(0, hl_group, hl)
    end
  end,
})

--- Ensures the hl groups are always set, even after a colorscheme change.
---@param groups snacks.util.hl
---@param opts? { prefix?:string, default?:boolean, managed?:boolean }
function M.set_hl(groups, opts)
  for hl_group, hl in pairs(groups) do
    hl_group = opts and opts.prefix and opts.prefix .. hl_group or hl_group
    hl = type(hl) == "string" and { link = hl } or hl --[[@as vim.api.keyset.highlight]]
    hl.default = not (opts and opts.default == false)
    if not (opts and opts.managed == false) then
      hl_groups[hl_group] = hl
    end
    vim.api.nvim_set_hl(0, hl_group, hl)
  end
end

---@param group string
---@param prop? string
function M.color(group, prop)
  prop = prop or "fg"
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  return hl[prop] and string.format("#%06x", hl[prop])
end

---@param win number
---@param wo vim.wo
function M.wo(win, wo)
  for k, v in pairs(wo or {}) do
    vim.api.nvim_set_option_value(k, v, { scope = "local", win = win })
  end
end

---@param buf number
---@param bo vim.bo
function M.bo(buf, bo)
  for k, v in pairs(bo or {}) do
    vim.api.nvim_set_option_value(k, v, { buf = buf })
  end
end

---@param name string
---@param cat? string
---@return string, string?
function M.icon(name, cat)
  local try = {
    function()
      return require("mini.icons").get(cat or "file", name)
    end,
    function()
      local Icons = require("nvim-web-devicons")
      if cat == "filetype" then
        return Icons.get_icon_by_filetype(name, { default = false })
      elseif cat == "file" then
        local ext = name:match("%.(%w+)$")
        return Icons.get_icon(name, ext, { default = false }) --[[@as string, string]]
      elseif cat == "extension" then
        return Icons.get_icon(nil, name, { default = false }) --[[@as string, string]]
      end
    end,
  }
  for _, fn in ipairs(try) do
    local ret = { pcall(fn) }
    if ret[1] and ret[2] then
      return ret[2], ret[3]
    end
  end
  return " "
end

-- Encodes a string to be used as a file name.
---@param str string
function M.file_encode(str)
  return str:gsub("([^%w%-_%.\t ])", function(c)
    return string.format("_%%%02X", string.byte(c))
  end)
end

-- Decodes a file name to a string.
---@param str string
function M.file_decode(str)
  return str:gsub("_%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)
end

---@param fg string foreground color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
function M.blend(fg, bg, alpha)
  local bg_rgb = { tonumber(bg:sub(2, 3), 16), tonumber(bg:sub(4, 5), 16), tonumber(bg:sub(6, 7), 16) }
  local fg_rgb = { tonumber(fg:sub(2, 3), 16), tonumber(fg:sub(4, 5), 16), tonumber(fg:sub(6, 7), 16) }
  local blend = function(i)
    local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end
  return string.format("#%02x%02x%02x", blend(1), blend(2), blend(3))
end

local transparent ---@type boolean?
function M.is_transparent()
  if transparent == nil then
    transparent = M.color("Normal", "bg") == nil
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("snacks_util_transparent", { clear = true }),
      callback = function()
        transparent = nil
      end,
    })
  end
  return transparent
end

local spec = {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },

      dashboard = {
        enabled = true,
        width = 60,
        row = nil,                                                                   -- dashboard position. nil for center
        col = nil,                                                                   -- dashboard position. nil for center
        pane_gap = 4,                                                                -- empty columns between vertical panes
        autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
        -- These settings are used by some built-in sections
        preset = {
          -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
          ---@type fun(cmd:string, opts:table)|nil
          pick = "fzf-lua",
          -- Used by the `keys` section to show keymaps.
          -- Set your custom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = true },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          -- Used by the `header` section
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
        -- item field formatters
        formats = {
          icon = function(item)
            if item.file and item.icon == "file" or item.icon == "directory" then
              return M.icon(item.file, item.icon)
            end
            return { item.icon, width = 2, hl = "icon" }
          end,
          footer = { "%s", align = "center" },
          header = { "%s", align = "center" },
          file = function(item, ctx)
            local fname = vim.fn.fnamemodify(item.file, ":~")
            fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
            if #fname > ctx.width then
              local dir = vim.fn.fnamemodify(fname, ":h")
              local file = vim.fn.fnamemodify(fname, ":t")
              if dir and file then
                file = file:sub(-(ctx.width - #dir - 2))
                fname = dir .. "/…" .. file
              end
            end
            local dir, file = fname:match("^(.*)/(.+)$")
            return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
          end,
        },
        sections = {
          { section = "header" },
          { section = "keys",   gap = 1, padding = 1 },
          { section = "startup" },
        },
        -- sections = {
        --   { section = "header" },
        --   {
        --     pane = 2,
        --     section = "terminal",
        --     cmd = "colorscript -e square",
        --     height = 5,
        --     padding = 1,
        --   },
        --   { section = "keys", gap = 1, padding = 1 },
        --   { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        --   { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        --   {
        --     pane = 2,
        --     icon = " ",
        --     title = "Git Status",
        --     section = "terminal",
        --     enabled = function()
        --       return Snacks.git.get_root() ~= nil
        --     end,
        --     cmd = "hub status --short --branch --renames",
        --     height = 5,
        --     padding = 1,
        --     ttl = 5 * 60,
        --     indent = 3,
        --   },
        --   { section = "startup" },
        -- },
      },
      -- gitbrowse =
      -- {
      --   notify = true, -- show notification on open
      --   -- Handler to open the url in a browser
      --   ---@param url string
      --   open = function(url)
      --     if vim.fn.has("nvim-0.10") == 0 then
      --       require("lazy.util").open(url, { system = true })
      --       return
      --     end
      --     vim.ui.open(url)
      --   end,
      --   ---@type "repo" | "branch" | "file" | "commit"
      --   what = "file", -- what to open. not all remotes support all types
      --   branch = nil, ---@type string?
      --   line_start = nil, ---@type number?
      --   line_end = nil, ---@type number?
      --   -- patterns to transform remotes to an actual URL
      --   remote_patterns = {
      --     { "^(https?://.*)%.git$",               "%1" },
      --     { "^git@(.+):(.+)%.git$",               "https://%1/%2" },
      --     { "^git@(.+):(.+)$",                    "https://%1/%2" },
      --     { "^git@(.+)/(.+)$",                    "https://%1/%2" },
      --     { "^ssh://git@(.*)$",                   "https://%1" },
      --     { "^ssh://([^:/]+)(:%d+)/(.*)$",        "https://%1/%3" },
      --     { "^ssh://([^/]+)/(.*)$",               "https://%1/%2" },
      --     { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
      --     { "^https://%w*@(.*)",                  "https://%1" },
      --     { "^git@(.*)",                          "https://%1" },
      --     { ":%d+",                               "" },
      --     { "%.git$",                             "" },
      --   },
      --   url_patterns = {
      --     ["github%.com"] = {
      --       branch = "/tree/{branch}",
      --       file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
      --       commit = "/commit/{commit}",
      --     },
      --     ["gitlab%.com"] = {
      --       branch = "/-/tree/{branch}",
      --       file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
      --       commit = "/-/commit/{commit}",
      --     },
      --     ["bitbucket%.org"] = {
      --       branch = "/src/{branch}",
      --       file = "/src/{branch}/{file}#lines-{line_start}-L{line_end}",
      --       commit = "/commits/{commit}",
      --     },
      --   },
      -- }
      notifier = {
        enabled = true,
        timeout = 3000,
        top_down = false,
      },
      quickfile = { enabled = true },

      statuscolumn = {
        enabled = false,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
        folds = {
          open = false,            -- show open fold icons
          git_hl = false,          -- use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true } -- Wrap notifications
        }
      }
    },
    -- toggle = {
    --   enabled = true,
    --   map = vim.keymap.set, -- keymap.set function to use
    --   which_key = true,     -- integrate with which-key to show enabled/disabled icons and colors
    --   notify = true,        -- show a notification when toggling
    --   -- icons for enabled/disabled states
    --   icon = {
    --     enabled = " ",
    --     disabled = " ",
    --   },
    --   -- colors for enabled/disabled states
    --   color = {
    --     enabled = "green",
    --     disabled = "yellow",
    --   },
    -- }
    keys = {
      { "<leader>.",  function() Snacks.scratch() end,                 desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end,          desc = "Select Scratch Buffer" },
      { "<leader>n",  function() Snacks.notifier.show_history() end,   desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end,               desc = "Delete Buffer" },
      { "<leader>cR", function() Snacks.rename.rename_file() end,      desc = "Rename File" },
      { "<leader>gB", function() Snacks.gitbrowse() end,               desc = "Git Browse" },
      { "<leader>gb", function() Snacks.git.blame_line() end,          desc = "Git Blame Line" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end,        desc = "Lazygit Current File History" },
      { "<leader>gg", function() Snacks.lazygit() end,                 desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end,             desc = "Lazygit Log (cwd)" },
      { "<leader>un", function() Snacks.notifier.hide() end,           desc = "Dismiss All Notifications" },
      { "<c-/>",      function() Snacks.terminal() end,                desc = "Toggle Terminal" },
      { "<c-_>",      function() Snacks.terminal() end,                desc = "which_key_ignore" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",              mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",              mode = { "n", "t" } },

    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
            "<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end,
      })
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    enabled = true,
    --branch = "0.10",
    event = "VeryLazy",
    config = function()
      -- config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        setopt = true,      -- Whether to set the 'statuscolumn' option, may be set to false for those who
        relculright = true, -- whether to right-align the cursor line number with 'relativenumber' set

        --   require("statuscol").setup({
        -- configuration goes here, for example:
        bt_ignore = {
          "terminal",
          "nofile",
        },
        ft_ignore = {
          "neo-tree",
          "toggleterm",
          "help",
          "aerial",
          "markdown",
          "dashboard",
          "vim",
          "noice",
          "lazy",
        },
        segments = {
          {
            text = {
              builtin.foldfunc,
              " ",
            },
            click = "v:lua.ScFa",
          },
          {
            sign = {
              namespace = { ".*/diagnostic/signs" }, --"diagnostic" },
              maxwidth = 1,
              colwidth = 2,
              auto = true,
              foldclosed = true,
            },
            click = "v:lua.ScSa",
          },
          {
            sign = {
              name = { "Dap.*" },
              maxwidth = 1,
              colwidth = 2,
              auto = true,
            },
            click = "v:lua.ScLa",
          },
          {
            text = { builtin.lnumfunc, " " },
            click = "v:lua.ScLa",
            --[[             condition = { true, builtin.not_empty }, ]]
          },
          {
            sign = {
              namespace = { "gitsign*" },
              maxwidth = 1,
              colwidth = 1,
              auto = true,
            },
            click = "v:lua.ScSa",
          },
          -- Segment: Add padding
          {
            text = { " " },
            hl = "Normal",
            condition = { true, builtin.not_empty },
          },
        },
        --})
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "luukvbaal/statuscol.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false,     -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false,    -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
        current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,  -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },

        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "]g", function()
            if vim.wo.diff then
              return "]g"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map("n", "[g", function()
            if vim.wo.diff then
              return "[g"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })

          -- Actions
          map("n", "<leader>gshs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>gshr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>gshS", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage hunk" })
          map("v", "<leader>gshR", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset hunk" })
          map("n", "<leader>gsbs", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>gshu", gs.undo_stage_hunk, { desc = "Unstage hunk" })
          map("n", "<leader>gsbr", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>gshp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>gslb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line" })
          map("n", "<leader>gslu", gs.toggle_current_line_blame, { desc = "Toggle Git blame" })
          map("n", "<leader>gsdd", gs.diffthis, { desc = "Diff" })
          map("n", "<leader>gsdh", function()
            gs.diffthis("~")
          end, { desc = "Diff HEAD" })
          map("n", "<leader>gst", gs.toggle_deleted, { desc = "Toggle removed" })

          -- Text object
          map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
        end,
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = "KindaLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local bufferlinecontroller = require("framework.controller.bufferlinecontroller"):new()
      bufferlinecontroller:setup()
    end,
  },
  {
    "utilyre/barbecue.nvim",
    enabled = false,
    event = "KindaLazy",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      attach_navic = false,
      show_dirname = false,
      show_basename = false,
      theme = "auto",
      exclude_filetypes = {
        "netrw",
        "aerial",
        "markdown",
        "vimwiki",
        "help",
        "dashboard",
        "NvimTree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lspinfo",
        "checkhealth",
        "TelescopePrompt",
        "TelescopeResults",
        "dapui_watches",
        "dapui_breakpoints",
        "dapui_scopes",
        "dapui_console",
        "dapui_stacks",
        "dap-repl",
        "neo-tree",
        "",
        "nofile",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "KindaLazy",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --{ "SmiteshP/nvim-navic" },
    },
    config = function()
      local statuslinecontroller = require("framework.controller.statuslinecontroller"):new()
      statuslinecontroller:setup()
    end,
  },
  -- {
  --   "glepnir/dashboard-nvim",
  --   --event = "VimEnter",
  --   init = vim.schedule(function()
  --     local interface = require("framework.interfaces.engine_interface"):new()
  --     local is_dashboard = interface.is_plugin_loaded("dashboard-nvim")
  --     if not is_dashboard then
  --       require("lazy").load({ plugins = { "dashboard-nvim" } })
  --     end
  --   end),
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = vim.schedule(function()
  --     local dashboardcontroller = require("framework.controller.dashboardcontroller"):new()
  --     dashboardcontroller:initialize_dashboard()
  --   end),
  -- },
  {
    "rcarriga/nvim-notify",
    keys = {
      -- stylua: ignore
      { "<leader>ud", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss all (Nvim-Notify)", },
    },
    opts = {
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },
}

return spec
