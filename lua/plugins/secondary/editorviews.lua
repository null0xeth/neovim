local spec = {

  -- {
  --   "j-hui/fidget.nvim",
  --   enabled = false,
  --   tag = "legacy",
  --   event = { "LspAttach" },
  --   config = function()
  --     local fidget = require("fidget")
  --     fidget.setup({
  --       window = {
  --         blend = 0,
  --       },
  --       text = {
  --         spinner = "dots",
  --         done = "",
  --         commenced = "",
  --         completed = "",
  --       },
  --       fmt = {
  --         stack_upwards = false,
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "nvimdev/lspsaga.nvim",
  --   enabled = false,
  --   event = "LspAttach",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     local catppuccin = function()
  --       local cachecontroller = require("framework.controller.cachecontroller"):new()
  --       local config = cachecontroller:query("colorschemes")
  --       if config[1] == "catppuccin" then
  --         local _kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind()
  --         local ui = {
  --           kind = _kind,
  --         }
  --         return ui
  --       else
  --         return {}
  --       end
  --     end
  --     require("lspsaga").setup({
  --       symbol_in_winbar = {
  --         enable = false,
  --       },
  --       lightbulb = {
  --         enable = false,
  --       },
  --       ui = catppuccin(),
  --     })
  --   end,
  -- },
  -- {
  --   "echasnovski/mini.map",
  --   opts = true,
  --   keys = {
  --     --stylua: ignore
  --     { "<leader>vm", function() require("mini.map").toggle {} end, desc = "Toggle Minimap" },
  --   },
  --   config = function(_, opts)
  --     require("mini.map").setup(opts)
  --   end,
  -- },
  {
    "hedyhli/outline.nvim",
    keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    cmd = "Outline",
    opts = function()
      local defaults = require("outline.config").defaults
      local opts = {
        symbols = {},
        keymaps = {
          up_and_jump = "<up>",
          down_and_jump = "<down>",
        },
      }
      return opts
    end,
  },
}

return spec
