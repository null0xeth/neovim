local function render_header_logo()
  local header = [[		                    
    	    	⠀⠀⢀⣀⣠⣤⣤⣶⣶⣿⣷⣆⠀⠀⠀⠀    
    	⠀⠀⠀⢀⣤⣤⣶⣶⣾⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⡆⠀⠀⠀  
    	⠀⢀⣴⣿⣿⣿⣿⣿⣿⡿⠛⠉⠉⠀⠀⠀⣿⣿⣿⣿⣷⠀⠀⠀  
    	⣠⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⢤⣶⣾⠿⢿⣿⣿⣿⣿⣇⠀⠀  
    	⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠈⠉⠀⠀⠀⣿⣿⣿⣿⣿⡆⠀  
    	⢸⣿⣿⣿⣏⣿⣿⣿⣿⣿⣷⠀⠀⢠⣤⣶⣿⣿⣿⣿⣿⣿⣿⡀  
    	⠀⢿⣿⣿⣿⡸⣿⣿⣿⣿⣿⣇⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣧  
    	⠀⠸⣿⣿⣿⣷⢹⣿⣿⣿⣿⣿⣄⣀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿  
    	⠀⠀⢻⣿⣿⣿⡇⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿  
    	⠀⠀⠘⣿⣿⣿⣿⠘⠻⠿⢛⣛⣭⣽⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿  
    	⠀⠀⠀⢹⣿⣿⠏⠀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠋  
    	⠀⠀⠀⠈⣿⠏⠀⣰⣿⣿⣿⣿⣿⣿⠿⠟⠛⠋⠉⠀⠀⠀⠀⠀  
    	⠀⠀⠀⠀⠀⠀⢠⡿⠿⠛⠋⠉⠀⠀⠀⠀               				                
  ]]

  return header
end

local spec = {
  {
    "goolord/alpha-nvim",
    enabled = false,
    dependencies = {
      "echasnovski/mini.icons",
      "echasnovski/mini.files",
    },
    event = "VimEnter",
    -- config = function()
    --   require("alpha").setup(require("alpha.themes.dashboard").config)
    -- end,

    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = render_header_logo()
      dashboard.section.header.val = vim.split(logo, "\n")
      --dashboard.section.footer.val = getRandomQuote(quotes, 80)
      dashboard.section.buttons.val = {
        dashboard.button("n", " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "󰱽 Find a file", ":Telescope find_files<CR>"),
        dashboard.button("e", "󰥩 Explore workspace", "<cmd>lua MiniFiles.open(vim.uv.cwd())<cr>"),
        dashboard.button("w", "󱎸 Look for a word", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("l", "󰒲 Open Lazy.nvim", "<cmd>Lazy<CR>"),
        dashboard.button("q", " Quit Neovim", ":qa<CR>"),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      --dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          once = true,
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.config)

      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "UIEnter",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded "
            .. stats.loaded
            .. "/"
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
return spec
