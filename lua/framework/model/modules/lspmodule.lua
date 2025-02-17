local module_cache = {}

---@package
---@param name string
---@param cacheKey string
---@return table
local function get_module(name, cacheKey)
  if module_cache[cacheKey] then
    return module_cache[cacheKey]
  end
  module_cache[cacheKey] = require(name)
  return module_cache[cacheKey]
end

-- Memoization with closure:
local function memoize(f)
  local cache = {}
  return function()
    if cache[1] then
      return unpack(cache)
    end
    cache = { f() }
    return unpack(cache)
  end
end

---@class lspmodule
local lspmodule = {}

local deepExtend = vim.tbl_deep_extend

---@param opts table|function: A table with setup instructions for LSP servers
---@return table: A map-like structure with setup instructions for LSP servers
---Helper function that translates opts to an array with LSP servers
local function convert_opts_to_map(opts)
  local serverSetups = {}
  local servers = opts.servers
  local setup = opts.setup
  local serversLen = #servers

  for i = 1, serversLen do
    local server = servers[i]
    serverSetups[server] = setup[server] or setup["*"]
  end
  return serverSetups
end

---Initializes the default LSP capabilities if not already initialized.
---@protected
---@return table defaultCapabilities: Returns a table containing the default LSP server capabilities
-- lspmodule.set_default_capabilities = memoize(function()
--   local default_capabilities = require('lspconfig').util.default_config
--   local capabilities = vim.tbl
--   lspconfig_defaults.default_capabilities = vim.tbl_deep_extend(
--     'force',
--     lspconfig_defaults.default_capabilities,
--     require('blink.cmp').get_lsp_capabilities()
--   )
--   lspconfig_defaults.capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
--   return lspconfig_defaults.capabilities
-- end)

---Configure and set up an individual LSP server
---@package
---@param server string: The name of the LSP server
---@param serverOpts table: A lua table containing configurations for this LSP server
---@param serverSetup table: A slice of serverSetups for this particular LSP server
local function setup_lsp_server(server, serverOpts, serverSetup)
  --local default_capabilities = lspmodule.set_default_capabilities()

  -- Deep extend options
  -- serverOpts = deepExtend("force", {
  --   --#capabilities = default_capabilities,
  --   capabilities = require('blink.cmp').get_lsp_capabilities(serverOpts.capabilities)
  -- }, serverOpts)

  -- Use the directly passed serverSetup function
  if serverSetup then
    if serverSetup(server, serverOpts) then
      return
    end
  end
  local lsp_zero = require('lsp-zero')

  lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
  end)

  lsp_zero.setup_servers(server)
  -- Fallback to default setup if no custom setup is provided
  require("lspconfig")[server].setup(serverOpts)
end

local lsp, fn = vim.lsp, vim.fn
local diagnostic = vim.diagnostic

local function falsy(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == "boolean" then
    return not item
  end
  if item_type == "string" then
    return item == ""
  end
  if item_type == "number" then
    return item <= 0
  end
  if item_type == "table" then
    return vim.tbl_isempty(item)
  end
  return item ~= nil
end

local function show_related_locations(diag)
  local related_info = diag.relatedInformation
  if not related_info or #related_info == 0 then
    return diag
  end
  for _, info in ipairs(related_info) do
    diag.message = ("%s\n%s(%d:%d)%s"):format(
      diag.message,
      fn.fnamemodify(vim.uri_to_fname(info.location.uri), ":p:."),
      info.location.range.start.line + 1,
      info.location.range.start.character + 1,
      not falsy(info.message) and (": %s"):format(info.message) or ""
    )
  end
  return diag
end

local function on_supports_method(method, fn)
  return vim.api.nvim_create_autocmd("User", {
    pattern = "LspSupportsMethod",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buffer = args.data.buffer ---@type number
      if client and method == args.data.method then
        return fn(client, buffer)
      end
    end,
  })
end

-- local words_enabled = false
-- local function words_setup(opts)
--   opts = opts or {}
--   if not opts.enabled then
--     return
--   end
--   words_enabled = true
--   local handler = vim.lsp.handlers["textDocument/documentHighlight"]
--   vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
--     if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
--       return
--     end
--     vim.lsp.buf.clear_references()
--     return handler(err, result, ctx, config)
--   end
--
--   on_supports_method("textDocument/documentHighlight", function(_, buf)
--     vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }, {
--       group = vim.api.nvim_create_augroup("lsp_word_" .. buf, { clear = true }),
--       buffer = buf,
--       callback = function(ev)
--         if not require("lazyvim.plugins.lsp.keymaps").has(buf, "documentHighlight") then
--           return false
--         end
--
--         if not ({ M.words.get() })[2] then
--           if ev.event:find("CursorMoved") then
--             vim.lsp.buf.clear_references()
--           elseif not LazyVim.cmp.visible() then
--             vim.lsp.buf.document_highlight()
--           end
--         end
--       end,
--     })
--   end)
-- end

---@package
---Initializes the LSP config and assigns icons to the various LSP symbols.
local function init_lsp_config() --= memoize(function()
  -- local lsp_zero = require('lsp-zero')
  --
  -- lsp_zero.on_attach(function(client, bufnr)
  --   lsp_zero.default_keymaps({buffer = bufnr})
  -- end)
  local handler = lsp.handlers["textDocument/publishDiagnostics"]
  ---@diagnostic disable-next-line: duplicate-set-field
  lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
    result.diagnostics = vim.tbl_map(show_related_locations, result.diagnostics)
    handler(err, result, ctx, config)
  end

  local lspConfig = {
    diagnostic = {
      --virtual_text = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
        -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        --prefix = "icons",
      },
      underline = false,
      update_in_insert = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
        texthl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        },
      },
    },
    inlay_hints = {
      enabled = true,
      exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
    },
    codelens = {
      enabled = false,
    },
    -- Enable lsp cursor word highlighting
    document_highlight = {
      enabled = true,
    },
    -- add any global capabilities here
    capabilities = {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
      },
    },
    -- options for vim.lsp.buf.format
    -- `bufnr` and `filter` is handled by the LazyVim formatter,
    -- but can be also overridden when specified
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
  }
  -- diagnostics signs
  -- if vim.fn.has("nvim-0.10.0") == 0 then
  --   for severity, icon in pairs(lspConfig.diagnostics.signs.text) do
  --     local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
  --     name = "DiagnosticSign" .. name
  --     vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  --   end
  -- end


  diagnostic.config(vim.deepcopy(lspConfig.diagnostic))
end

---Take an array of LSP servers and initialize them.
---@protected
---@param opts table: A lua table containing LSP server configurations
function lspmodule.process_lsp_servers(opts)
  init_lsp_config()

  local sSetups = convert_opts_to_map(opts)

  local servers = opts.servers
  for server, s_opts in pairs(servers) do
    if s_opts then
      s_opts = s_opts == true and {} or s_opts
      s_opts.capabilities = require('blink.cmp').get_lsp_capabilities(s_opts.capabilities)
      setup_lsp_server(server, s_opts, sSetups[server])
    end
  end
end

return lspmodule
