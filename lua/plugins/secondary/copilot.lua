local spec = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    config = function()
      local keymapcontroller = require("framework.controller.keymapcontroller", "keymapcontroller"):new()
      local suggestion = require("copilot.suggestion")
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            --accept = "<M-l>",
            accept = false,
            --accept_word = false,
            accept_word = "<M-Right>",
            accept_line = "<M-Down>",
            --accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = false,
            --dismiss = "<C-]>",
          },
        },
        -- filetypes = {
        --   yaml = true,
        --   lua = true,
        --   nix = true,
        --   markdown = false,
        --   help = false,
        --   gitcommit = false,
        --   gitrebase = false,
        --   hgcommit = false,
        --   svn = false,
        --   cvs = false,
        --   ["."] = false,
        -- },
        copilot_node_command = "node", -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })

      keymapcontroller:register_keymap("i", "<C-=>", function()
        if suggestion.is_visible() then
          suggestion.accept()
        else
          suggestion.next()
        end
      end, { silent = true })
    end,
  },
  -- {
  --   "nvim-cmp",
  --   dependencies = {
  --     {
  --       "zbirenbaum/copilot-cmp",
  --       dependencies = "zbirenbaum/copilot.lua",
  --       config = function()
  --         local copilot_cmp = require("copilot_cmp")
  --         copilot_cmp.setup()
  --       end,
  --     },
  --   },
  --   -- ---@param opts cmp.ConfigSchema
  --   -- opts = function(_, opts)
  --   --   table.insert(opts.sources, 1, {
  --   --     name = "copilot",
  --   --     group_index = 1,
  --   --   })
  --   -- end,
  -- },
}

return spec
