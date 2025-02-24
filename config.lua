local settings = {
  colorschemes = {
    catppuccin = true,
    darkplus = false,
    tokyonight = false,
    material = false,
    rosepine = false,
  },
  languages = {
    ansible = true,
    -- cpp = false,
    -- css = false,
    dotfiles = true,
    helm = true,
    json = true,
    go = true,
    lua = true,
    -- markdown = false,
    nix = true,
    -- python = false,
    -- rust = false,
    -- solidity = false,
    typescript = true,
    kcl = true,
    -- ruby = false,
    yaml = true,
    terraform = true,
  },
  keymap_categories = {
    {
      mode = { "n", "v" },
      { "<leader>b",   group = "Buffer" },
      { "<leader>c",   group = "Coding" },
      { "<leader>cT",  desc = "+TODO Comments" },
      { "<leader>ct",  desc = "+Trouble (QF)" },

      { "<leader>d",   group = "Nvim DAP" },
      { "<leader>da",  desc = "+Adapters" },
      { "<leader>du",  group = "DAP UI" },
      { "<leader>duf", desc = "+Float elements.." },
      { "<leader>duv", desc = "+Virtual Text" },
      { "<leader>duw", desc = "+UI Widgets" },

      { "<leader>e",   group = "Editor" },
      { "<leader>ef",  desc = "+Folding" },
      { "<leader>f",   group = "Telescope" },
      { "<leader>fD",  desc = "+DAP Telescope" },
      { "<leader>fG",  desc = "+Git" },
      { "<leader>fd",  desc = "+Diagnostics" },
      { "<leader>ff",  desc = "+Normal Search" },
      { "<leader>fg",  desc = "+General" },
      { "<leader>fl",  desc = "+LSP" },
      { "<leader>fz",  desc = "+Fuzzy Search" },

      { "<leader>g",   group = "Git" },
      { "<leader>gs",  group = "Gitsigns" },
      { "<leader>gsb", desc = "+Buffer" },
      { "<leader>gsh", desc = "+Hunk" },
      { "<leader>gsl", desc = "+Line" },

      { "<leader>l",   group = "LSP" },
      { "<leader>la",  desc = "+Annotations" },
      { "<leader>lc",  desc = "+Code Navigation" },
      { "<leader>lg",  desc = "+Glance" },

      { "<leader>m",   group = "Movement" },
      { "<leader>mn",  desc = "+Navigation" },
      { "<leader>mr",  desc = "+Reach" },

      { "<leader>p",   group = "Persistence" },

      { "<leader>r",   group = "Refactoring" },

      { "<leader>S",   group = "Syntax" },

      { "<leader>s",   group = "Search" },
      { "<leader>sr",  desc = "+SSR" },
      { "<leader>ss",  desc = "+Nvim Spectre" },

      { "<leader>t",   group = "Testing" },
      { "<leader>tn",  desc = "+Neotest" },
      { "<leader>to",  desc = "+Overseer" },
      { "<leader>tv",  desc = "+Vim Test" },

      { "<leader>u",   group = "UI/Windows" },
      { "<leader>un",  desc = "+Noice (Notifications)" },

      { "<leader>v",   group = "View" },
      { "<leader>vs",  desc = "+Symbols" },
      { "<leader>vw",  group = "Windows" },
      { "<leader>vws", desc = "+Splits" },
    },
  },
  -- --a = false,
  -- prefix = "<leader>",
  -- mode = { "n", "v" },
  -- b = {
  -- 	name = "+Buffer",
  -- },
  -- c = {
  -- 	name = "+Coding",
  -- 	t = { "+Trouble (QF)" },
  -- 	T = { "+TODO Comments" },
  -- },
  -- d = {
  -- 	name = "+Nvim DAP",
  -- 	a = { "+Adapters" },
  -- 	u = {
  -- 		name = "+DAP UI",
  -- 		f = { "+Float elements.." },
  -- 		v = { "+Virtual Text" },
  -- 		w = { "+UI Widgets" },
  -- 	},
  -- },
  -- e = {
  -- 	name = "+Editor",
  -- 	f = { "+Folding" },
  -- },
  -- f = {
  -- 	name = "+Telescope",
  -- 	d = { "+Diagnostics" },
  -- 	D = { "+DAP Telescope" },
  -- 	f = { "+Normal Search" },
  -- 	g = { "+General" },
  -- 	G = { "+Git" },
  -- 	l = { "+LSP" },
  -- 	z = { "+Fuzzy Search" },
  -- },
  -- g = {
  -- 	name = "+Git",
  -- 	s = {
  -- 		name = "+Gitsigns",
  -- 		h = { "+Hunk" },
  -- 		b = { "+Buffer" },
  -- 		l = { "+Line" },
  -- 	},
  -- },

  -- --h = false,
  -- --i = false,
  -- --j = false,
  -- --k = false,
  -- l = {
  -- 	name = "+LSP",
  -- 	a = { "+Annotations" },
  -- 	g = { "+Glance" },
  -- 	c = { "+Code Navigation" },
  -- },
  -- m = {
  -- 	name = "+Movement",
  -- 	r = { "+Reach" },
  -- 	n = { "+Navigation" },
  -- },
  -- --n = false,
  -- --o = false,
  -- p = { name = "+Persistence" },
  -- --q = false,
  -- r = {
  -- 	name = "+Refactoring", -- add search.lua sjit
  -- },
  -- s = {
  -- 	name = "+Search",
  -- 	s = { "+Nvim Spectre" },
  -- 	r = { "+SSR" },
  -- },
  -- S = { name = "+Syntax" },
  -- t = {
  -- 	name = "+Testing",
  -- 	n = { "+Neotest" },
  -- 	o = { "+Overseer" },
  -- 	v = { "+Vim Test" },
  -- },
  -- u = {
  -- 	name = "+UI/Windows",
  -- 	n = { "+Noice (Notifications)" },
  -- },
  -- v = {
  -- 	name = "+View",
  -- 	s = { "+Symbols" },
  -- 	w = {
  -- 		name = "+Windows",
  -- 		s = { "+Splits" },
  -- 	},
  -- },
  --w = false,
  --x = false,
  --y = false,
  --z = false,
}

return settings
