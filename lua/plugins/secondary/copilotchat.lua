return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    build = "make tiktoken",
    -- opts = function()
    --   local user = vim.env.USER or "User"
    --   user = user:sub(1, 1):upper() .. user:sub(2)
    --   return {
    --     auto_insert_mode = true,
    --     show_help = true,
    --     question_header = "  " .. user .. " ",
    --     answer_header = "  Copilot ",
    --     window = {
    --       width = 0.4,
    --     },
    --     selection = function(source)
    --       local select = require("CopilotChat.select")
    --       return select.visual(source) or select.buffer(source)
    --     end,
    --   }
    -- end,
    keys = {
      {
        "<leader>aic",
        function()
          require("CopilotChat").toggle()
        end,
        desc = "CopilotChat - Quick chat",
      },
      {
        "<leader>aiq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
      {
        "<leader>aih",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
      },
      -- Show prompts actions with fzf-lua
      {
        "<leader>aip",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
    },
    -- keys = {
    --   { "<c-s>",     "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
    --   { "<leader>a", "",     desc = "+ai",        mode = { "n", "v" } },
    --   {
    --     "<leader>aa",
    --     function()
    --       return require("CopilotChat").toggle()
    --     end,
    --     desc = "Toggle (CopilotChat)",
    --     mode = { "n", "v" },
    --   },
    --   {
    --     "<leader>ax",
    --     function()
    --       return require("CopilotChat").reset()
    --     end,
    --     desc = "Clear (CopilotChat)",
    --     mode = { "n", "v" },
    --   },
    --   {
    --     "<leader>aq",
    --     function()
    --       local input = vim.fn.input("Quick Chat: ")
    --       if input ~= "" then
    --         require("CopilotChat").ask(input)
    --       end
    --     end,
    --     desc = "Quick Chat (CopilotChat)",
    --     mode = { "n", "v" },
    --   },
    --   -- Show help actions with telescope
    --   { "<leader>ad", M.pick("help"),   desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
    --   -- Show prompts actions with telescope
    --   { "<leader>ap", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)",  mode = { "n", "v" } },
    -- },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local actions = require('CopilotChat.actions')
      local integration = require('CopilotChat.integrations.fzflua')
      --require("CopilotChat.integrations.cmp").setup()

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup({
        debug = true,
        model = 'claude-3.5-sonnet',
        --question_header = '',
        --answer_header = '',
        error_header = '',
        allow_insecure = true,
        mappings = {
          reset = {
            normal = '',
            insert = '',
          },
        },
        auto_insert_mode = true,
        show_help = true,
        question_header = "  " .. "Null0x" .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.buffer(source)
        end,
        prompts = {
          Explain = {
            mapping = '<leader>ae',
            description = 'AI Explain',
          },
          Review = {
            mapping = '<leader>ar',
            description = 'AI Review',
          },
          Tests = {
            mapping = '<leader>at',
            description = 'AI Tests',
          },
          Fix = {
            mapping = '<leader>af',
            description = 'AI Fix',
          },
          Optimize = {
            mapping = '<leader>ao',
            description = 'AI Optimize',
          },
          Docs = {
            mapping = '<leader>ad',
            description = 'AI Documentation',
          },
          CommitStaged = {
            mapping = '<leader>ac',
            description = 'AI Generate Commit',
          },
        },
      })
    end,
  },
}
