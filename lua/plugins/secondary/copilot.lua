local spec = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = false,
            -- accept_word = "<M-Right>",
            -- accept_line = "<M-Down>",
            -- next = "<M-]>",
            -- prev = "<M-[>",
            -- dismiss = false,
          },
        },
        --copilot_node_command = "node", -- Node.js version must be > 18.x
        --server_opts_overrides = {},
      })
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
