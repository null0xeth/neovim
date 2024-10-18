return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {},
    keys = { { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Open DiffView" } },
  },
  -- {
  --   "NeogitOrg/neogit",
  --   cmd = "Neogit",
  --   keys = {
  --     { "<leader>gN", "<cmd>Neogit kind=floating<cr>", desc = "Git Status (Neogit)" },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- required
  --     "nvim-telescope/telescope.nvim", -- optional
  --     "sindrets/diffview.nvim", -- optional
  --   },
  --   config = function()
  --     require("neogit").setup()
  --   end,
  -- },
}
