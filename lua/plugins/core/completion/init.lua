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
  -- if you change or add symbol here
  -- replace corresponding line in readme
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}

return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    build = "cargo build --release",
    dependencies = {
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
      completion = {
        list = {
          selection = {
            preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
            auto_insert = function(ctx) return ctx.mode ~= 'cmdline' end
          }
        },
        menu = {
          enabled = true,
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
          end,
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
          draw = {
            -- Aligns the keyword you've typed to a component in the menu
            align_to = 'label', -- or 'none' to disable
            -- Left and right padding, optionally { left, right } for different padding on each side
            padding = 1,
            -- Gap between columns
            gap = 1,

            -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            columns = { { "kind_icon" }, { "label", gap = 1 } },
            components = {
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then
                    -- Or you want to add more item to label
                    return highlights_info.label
                  else
                    return ctx.label
                  end
                end,
                highlight = function(ctx)
                  local highlights = {}
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then
                    highlights = highlights_info.highlights
                  end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch", fg = "none", style = "bold" })
                  end
                  -- Do something else
                  return highlights
                end,
              },
            },
            -- components = {
            --   kind_icon = {
            --     ellipsis = false,
            --     text = function(ctx) return ctx.kind_icon .. ctx.icon_gap end,
            --     highlight = function(ctx)
            --       return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or
            --           'BlinkCmpKind' .. ctx.kind
            --     end,
            --   },
            --
            --   kind = {
            --     ellipsis = false,
            --     width = { fill = true },
            --     text = function(ctx) return ctx.kind end,
            --     highlight = function(ctx)
            --       return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or
            --           'BlinkCmpKind' .. ctx.kind
            --     end,
            --   },
            --
            --   label = {
            --     width = { fill = true, max = 60 },
            --     text = function(ctx) return ctx.label .. ctx.label_detail end,
            --     highlight = function(ctx)
            --       -- label and label details
            --       local highlights = {
            --         { 0, #ctx.label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
            --       }
            --       if ctx.label_detail then
            --         table.insert(highlights,
            --           { #ctx.label, #ctx.label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
            --       end
            --
            --       -- characters matched on the label by the fuzzy matcher
            --       for _, idx in ipairs(ctx.label_matched_indices) do
            --         table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
            --       end
            --
            --       return highlights
            --     end,
            --   },
            --
            --   label_description = {
            --     width = { max = 30 },
            --     text = function(ctx) return ctx.label_description end,
            --     highlight = 'BlinkCmpLabelDescription',
            --   },
            --
            --   source_name = {
            --     width = { max = 30 },
            --     text = function(ctx) return ctx.source_name end,
            --     highlight = 'BlinkCmpSource',
            --   },
            -- },
          },
        },
        documentation = {
          -- Controls whether the documentation window will automatically show when selecting a completion item
          auto_show = true,
          -- Delay before showing the documentation window
          auto_show_delay_ms = 500,
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
      cmdline = {
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == '/' or type == '?' then return { 'buffer' } end
          -- Commands
          if type == ':' then return { 'cmdline' } end
          return {}
        end,
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        -- Please see https://github.com/Saghen/blink.compat for using `nvim-cmp` sources
        providers = {
          lsp = {
            -- dont show LuaLS require statements when lazydev has items
            fallbacks = { "buffer" },
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
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
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = -2,
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              show_hidden_files_by_default = false,
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            }
          },
          snippets = {
            name = 'Snippets',
            module = 'blink.cmp.sources.snippets',
            score_offset = -3,
            max_items = 4,
            min_keyword_length = 4,
            opts = {
              friendly_snippets = true,
              search_paths = { vim.fn.stdpath('config') .. '/snippets' },
              global_snippets = { 'all' },
              extended_filetypes = {},
              ignored_filetypes = {},
              get_filetype = function(context)
                return vim.bo.filetype
              end
            }

            --- Example usage for disabling the snippet provider after pressing trigger characters (i.e. ".")
            -- enabled = function(ctx)
            --   return ctx ~= nil and ctx.trigger.kind == vim.lsp.protocol.CompletionTriggerKind.TriggerCharacter
            -- end,
          },
          buffer = {
            name = 'Buffer',
            module = 'blink.cmp.sources.buffer',
            max_items = 4,
            score_offset = -3,
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
    end,
  },

  -- LSP servers and clients communicate what features they support through "capabilities".
  --  By default, Neovim support a subset of the LSP specification.
  --  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
  --  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
  --
  -- This can vary by config, but in-general for nvim-lspconfig:
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        --config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      local cmp = require("blink.cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local ts_utils = require("nvim-treesitter.ts_utils")

      local ts_node_func_parens_disabled = {
        -- ecma
        named_imports = true,
        -- rust
        use_declaration = true,
      }
      local default_handler = cmp_autopairs.filetypes["*"]["("].handler
      cmp_autopairs.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
        local node_type = ts_utils.get_node_at_cursor():type()
        if ts_node_func_parens_disabled[node_type] then
          if item.data then
            item.data.funcParensDisabled = true
          else
            char = ""
          end
        end
        default_handler(char, item, bufnr, rules, commit_character)
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          require("copilot.suggestion").dismiss()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
      -- cmp.event:on(
      -- 	"confirm_done",
      -- 	cmp_autopairs.on_confirm_done({
      -- 		sh = false,
      -- 	})
      --)
    end,
  }
  --   {
  --     "windwp/nvim-autopairs",
  --     dependencies = {
  --       "hrsh7th/nvim-cmp",
  --     },
  --     event = "InsertEnter",
  --     config = function()
  --       local autopairs = require("nvim-autopairs")
  --
  --       autopairs.setup({
  --         enable_check_bracket_line = false,
  --       })
  --
  --       local cmp = require("cmp")
  --       local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  --       local ts_utils = require("nvim-treesitter.ts_utils")
  --
  --       local ts_node_func_parens_disabled = {
  --         -- ecma
  --         named_imports = true,
  --         export_clause = true,
  --         -- rust
  --         use_declaration = true,
  --       }
  --
  --       local default_handler = cmp_autopairs.filetypes["*"]["("].handler
  --       cmp_autopairs.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
  --         local node_type = ts_utils.get_node_at_cursor():type()
  --         if ts_node_func_parens_disabled[node_type] then
  --           if item.data then
  --             item.data.funcParensDisabled = true
  --           else
  --             char = ""
  --           end
  --         end
  --         default_handler(char, item, bufnr, rules, commit_character)
  --       end
  --
  --       cmp.event:on(
  --         "confirm_done",
  --         cmp_autopairs.on_confirm_done({
  --           filetypes = {
  --             sh = false,
  --           },
  --         })
  --       )
  --     end,
  --   },
  -- }
}
