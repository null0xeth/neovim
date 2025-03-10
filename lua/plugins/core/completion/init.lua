local M = {}
M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
  end
end

local border = {
  {
    "🭽",
    "▔",
    "🭾",
    "▕",
    "🭿",
    "▁",
    "🭼",
    "▏",
  }
}
local icons = {
  {
    Copilot = "",
    Text = '󰉿',
    Method = '󰊕',
    Function = '󰊕',
    Constructor = '󰒓',

    Field = '󰜢',
    Variable = '󰆦',
    Property = '󰖷',

    Class = '󱡠',
    Interface = '󱡠',
    Struct = '󱡠',
    Module = '󰅩',

    Unit = '󰪚',
    Value = '󰦨',
    Enum = '󰦨',
    EnumMember = '󰦨',

    Keyword = '󰻾',
    Constant = '󰏿',

    Snippet = '󱄽',
    Color = '󰏘',
    File = '󰈔',
    Reference = '󰬲',
    Folder = '󰉋',
    Event = '󱐋',
    Operator = '󰪚',
    TypeParameter = '󰬛',
  },
}
-- local icons = {
--   -- if you change or add symbol here
--   -- replace corresponding line in readme
--   Text = "󰉿",
--   Method = "󰆧",
--   Function = "󰊕",
--   Constructor = "",
--   Field = "󰜢",
--   Variable = "󰀫",
--   Class = "󰠱",
--   Interface = "",
--   Module = "",
--   Property = "󰜢",
--   Unit = "󰑭",
--   Value = "󰎠",
--   Enum = "",
--   Keyword = "󰌋",
--   Snippet = "",
--   Color = "󰏘",
--   File = "󰈙",
--   Reference = "󰈇",
--   Folder = "󰉋",
--   EnumMember = "",
--   Constant = "󰏿",
--   Struct = "󰙅",
--   Event = "",
--   Operator = "󰆕",
--   TypeParameter = "",
-- }

return {
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    event = { "KindaLazy" },
    dependencies = {
      "onsails/lspkind.nvim",
      "rafamadriz/friendly-snippets",
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'xzbdmw/colorful-menu.nvim',
      -- lock compat to tagged versions, if you've also locked blink.cmp to tagged versions
      { 'saghen/blink.compat', version = '*', opts = { impersonate_nvim_cmp = true } },
      'giuxtaposition/blink-cmp-copilot',
    },
    opts_extend = { "sources.default" },
    opts = {
      keymap = {
        ["<C-s>"] = { "show" },
        ["<C-h>"] = { "hide" },
        ["<C-CR>"] = { "select_and_accept", "fallback" },
        ['<Tab>'] = {
          function(cmp)
            if require("copilot.suggestion").is_visible() then
              M.create_undo()
              require("copilot.suggestion").accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          'fallback',
        },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next" },
        ["<C-p>"] = { "select_prev" },
        ["<PageDown>"] = { "scroll_documentation_down" },
        ["<PageUp>"] = { "scroll_documentation_up" },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = 'cmdline' },
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == '/' or type == '?' then return { 'buffer' } end
          -- Commands
          if type == ':' then return { 'cmdline' } end
          return {}
        end,
        completion = {
          trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_x_blocked_trigger_characters = {},
          },
          list = {
            selection = {
              -- When `true`, will automatically select the first item in the completion list
              preselect = true,
              -- When `true`, inserts the completion item automatically when selecting it
              auto_insert = true,
            },
          },
          -- Whether to automatically show the window when new completion items are available
          menu = {
            auto_show = function(ctx)
              return vim.fn.getcmdtype() == ':'
              -- enable for inputs as well, with:
              -- or vim.fn.getcmdtype() == '@'
            end,
          },
          -- Displays a preview of the selected item on the current line
          ghost_text = { enabled = true }
        }
      },
      completion = {
        -- list = {
        --   selection = {
        --     preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
        --     auto_insert = function(ctx) return ctx.mode ~= 'cmdline' end
        --   }
        -- },
        -- Disable auto brackets
        -- NOTE: some LSPs may add auto brackets themselves anyway
        accept = { auto_brackets = { enabled = false }, },
        list = { selection = { preselect = function(ctx) return ctx.mode ~= 'cmdline' end } },

        menu = {
          enabled = true,
          -- auto_show = function(ctx)
          --   return ctx.mode ~= "cmdline" or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
          -- end,
          auto_show = true,
          min_width = 15,
          max_height = 10,

          border = 'rounded',
          winblend = 0,
          winhighlight =
          'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
          -- Keep the cursor X lines away from the top/bottom of the window
          scrolloff = 2,
          -- Note that the gutter will be disabled when border ~= 'none'
          scrollbar = false,
          -- Which directions to show the window,
          -- falling back to the next direction when there's not enough space
          direction_priority = { 's', 'n' },
          -- Controls how the completion items are rendered on the popup window
          cmdline_position = function()
            if vim.g.ui_cmdline_pos ~= nil then
              local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
              return { pos[1] - 1, pos[2] }
            end
            local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,
          draw = {
            -- Aligns the keyword you've typed to a component in the menu
            align_to = 'label', -- or 'none' to disable
            -- Left and right padding, optionally { left, right } for different padding on each side
            padding = 1,
            -- Gap between columns
            gap = 1,
            treesitter = { "lsp" },

            -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            columns = {
              --{ "kind_icon" }, { "label", gap = 1 }, { "source_name" } },
              { "label",     "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local lspkind = require("lspkind")
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
              label = {
                width = { fill = true, max = 60 },
                -- text = function(ctx)
                --   return require("colorful-menu").blink_components_text(ctx)
                -- end,
                -- highlight = function(ctx)
                --   return require("colorful-menu").blink_components_highlight(ctx)
                -- end,
                text = function(ctx)
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  return ctx.label
                end,
                highlight = function(ctx)
                  local highlights = {}
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then
                    highlights = highlights_info.highlights
                  end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights,
                      { idx, idx + 1, group = "BlinkCmpLabelMatch", fg = "none", style = "bold" })
                  end
                  -- Do something else
                  return highlights
                end,
              },
            },
          },
        },

        documentation = {
          -- Controls whether the documentation window will automatically show when selecting a completion item
          auto_show = true,
          -- Delay before showing the documentation window
          auto_show_delay_ms = 200,
          -- Delay before updating the documentation window when selecting a new item,
          -- while an existing item is still visible
          update_delay_ms = 50,
          -- Whether to use treesitter highlighting, disable if you run into performance issues
          window = {
            min_width = 10,
            max_width = 60,
            max_height = 20,
            border = "rounded",
            winblend = 0,
            winhighlight =
            'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
            -- Note that the gutter will be disabled when border ~= 'none'
            scrollbar = true,
            -- Which directions to show the documentation window,
            -- for each of the possible menu window directions,
            -- falling back to the next direction when there's not enough space
            direction_priority = {
              menu_north = { 'e', 'w', 'n', 's' },
              menu_south = { 'e', 'w', 's', 'n' },
            },
          },
        },

        -- Displays a preview of the selected item on the current line
        ghost_text = {
          enabled = true,

        },
      },

    },
    fuzzy = {
      implementation = "prefer_rust",
    },
    -- Experimental signature help support
    signature = {
      enabled = true,
      trigger = {
        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
        -- When true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
        show_on_insert_on_trigger_character = true,
      },
      window = {
        min_width = 1,
        max_width = 100,
        max_height = 10,
        border = border,
        winblend = 0,
        winhighlight = 'Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder',
        scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
        -- Which directions to show the window,
        -- falling back to the next direction when there's not enough space,
        -- or another window is in the way
        direction_priority = { 'n', 's' },
        -- Disable if you run into performance issues
      },
    },
    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
      -- Please see https://github.com/Saghen/blink.compat for using `nvim-cmp` sources
      providers = {
        lazydev = {
          name = "LAZY",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
        lsp = {
          -- dont show LuaLS require statements when lazydev has items
          name = "LSP",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          score_offset = 90,
          --fallbacks = { "buffer" },
        },

        copilot = {
          name = "CP",
          enabled = true,
          module = "blink-cmp-copilot",
          score_offset = -100, -- the higher the number, the higher the priority
          async = true,
          min_keyword_length = 6,
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"
            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
        },
        -- lazydev = {
        --   name = "LazyDev",
        --   module = "lazydev.integrations.blink",
        --   fallbacks = { "lsp" },
        -- },
        path = {
          name = 'PATH',
          module = 'blink.cmp.sources.path',
          fallbacks = { "snippets", "buffer" },
          min_keyword_length = 2,
          score_offset = 25,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            show_hidden_files_by_default = true,
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          }
        },
        snippets = {
          name = 'SNIP',
          module = 'blink.cmp.sources.snippets',
          max_items = 4,
          min_keyword_length = 4,
          score_offset = 5,
          -- opts = {
          --   friendly_snippets = true,
          --   search_paths = { vim.fn.stdpath('config') .. '/snippets' },
          --   global_snippets = { 'all' },
          --   extended_filetypes = {},
          --   ignored_filetypes = {},
          --   get_filetype = function(context)
          --     return vim.bo.filetype
          --   end
          -- }

          --- Example usage for disabling the snippet provider after pressing trigger characters (i.e. ".")
          -- enabled = function(ctx)
          --   return ctx ~= nil and ctx.trigger.kind == vim.lsp.protocol.CompletionTriggerKind.TriggerCharacter
          -- end,
        },
        buffer = {
          name = "BUF",
          enabled = true,
          max_items = 3,
          module = "blink.cmp.sources.buffer",
          min_keyword_length = 4,
          score_offset = 15,
        },
      },
    },

    appearance = {
      highlight_ns = vim.api.nvim_create_namespace('blink_cmp'),
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'normal',
      kind_icons = {
        Copilot = "",
        Text = '󰉿',
        Method = '󰊕',
        Function = '󰊕',
        Constructor = '󰒓',

        Field = '󰜢',
        Variable = '󰆦',
        Property = '󰖷',

        Class = '󱡠',
        Interface = '󱡠',
        Struct = '󱡠',
        Module = '󰅩',

        Unit = '󰪚',
        Value = '󰦨',
        Enum = '󰦨',
        EnumMember = '󰦨',

        Keyword = '󰻾',
        Constant = '󰏿',

        Snippet = '󱄽',
        Color = '󰏘',
        File = '󰈔',
        Reference = '󰬲',
        Folder = '󰉋',
        Event = '󱐋',
        Operator = '󰪚',
        TypeParameter = '󰬛',
      },
    },
  },
  config = function(_, opts)
    --   -- opts.sources.default = function(ctx)
    --   --   local success, node = pcall(vim.treesitter.get_node)
    --   --   if vim.bo.filetype == 'lua' then
    --   --     return { 'lsp', 'path', 'copilot' }
    --   --   elseif success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
    --   --     return { 'buffer' }
    --   --   else
    --   --     return { 'lsp', 'path', 'snippets', 'buffer', 'copilot' }
    --   --   end
    --   -- end
    -- setup compat sources
    local enabled = opts.sources.default
    for _, source in ipairs(opts.sources.compat or {}) do
      opts.sources.providers[source] = vim.tbl_deep_extend(
        "force",
        { name = source, module = "blink.compat.source" },
        opts.sources.providers[source] or {}
      )
      if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
        table.insert(enabled, source)
      end
    end

    -- add ai_accept to <Tab> key
    if not opts.keymap["<Tab>"] then
      if opts.keymap.preset == "super-tab" then -- super-tab
        opts.keymap["<Tab>"] = {
          require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
          --LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
          "fallback",
        }
      else -- other presets
        opts.keymap["<Tab>"] = {
          --LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
          "fallback",
        }
      end
    end

    -- Unset custom prop to pass blink.cmp validation
    opts.sources.compat = nil

    -- check if we need to override symbol kinds
    for _, provider in pairs(opts.sources.providers or {}) do
      ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
      if provider.kind then
        local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
        local kind_idx = #CompletionItemKind + 1

        CompletionItemKind[kind_idx] = provider.kind
        ---@diagnostic disable-next-line: no-unknown
        CompletionItemKind[provider.kind] = kind_idx

        ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
        local transform_items = provider.transform_items
        ---@param ctx blink.cmp.Context
        ---@param items blink.cmp.CompletionItem[]
        provider.transform_items = function(ctx, items)
          items = transform_items and transform_items(ctx, items) or items
          for _, item in ipairs(items) do
            item.kind = kind_idx or item.kind
            item.kind_icon = icons[item.kind_name] or item.kind_icon or nil
          end
          return items
        end

        -- Unset custom prop to pass blink.cmp validation
        provider.kind = nil
      end
    end

    require("blink.cmp").setup(opts)


    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpCompletionMenuOpen',
      callback = function()
        require("copilot.suggestion").dismiss()
        vim.b.copilot_suggestion_hidden = true
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpCompletionMenuClose',
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
    --require("blink.cmp").setup(opts)
    vim.lsp.config('*', {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
    })
  end,
}
