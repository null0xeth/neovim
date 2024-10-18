local instance_cache = {}
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

---@package
---@param name string
---@param cacheKey string
---@return table
local function get_obj(name, cacheKey)
  local uninitialized_obj = get_module(name, cacheKey)
  if instance_cache[cacheKey] then
    return instance_cache[cacheKey]
  end

  instance_cache[cacheKey] = uninitialized_obj:new()
  return instance_cache[cacheKey]
end

-- Caching:
local fn = vim.fn
local globpath = fn.globpath
local isDirectory = fn.isdirectory
local contains = vim.tbl_contains

-- Configuration:
local basePath = fn.stdpath("config") .. "/lua"
local corePath = basePath .. "/plugins/core"
local extensionPath = basePath .. "/plugins/core/languages"
local colorschemePath = basePath .. "/plugins/colorschemes"
local secondaryPath = basePath .. "/plugins/secondary"
local excludedDirectories = { "languages" }
local insert = table.insert

-- [[##########################]] --
--          Initialization        --
-- [[##########################]] --
---@class PluginModel
local PluginModel = {}
PluginModel.__index = PluginModel

--> Fetch the plugin spec from a given file, and return it.
local function fetchSpecsFromFile(filePath)
  local specs_from_file = {}
  local relative_file_path = filePath:gsub(basePath .. "/", "")
  local module_file_path = relative_file_path:gsub("%.lua$", ""):gsub("/", ".")
  local _, plugin_list_from_file = pcall(require, module_file_path)

  local plugin_list_len = #plugin_list_from_file

  for i = 1, plugin_list_len do
    specs_from_file[i] = plugin_list_from_file[i]
  end

  return specs_from_file
end

-- [[ REFACTORED VERSIONS ]]
--  higher order functions:
-- local function wrap_async_function(func)
--   local dev = get_module("util.libraries.test", "dev")
--   --return dev.create(func, 0)()
--   dev.create(func, 0)()
-- end

-- local function delegate_async_function(func)
--   wrap_async_function(func)
-- end

local function merge_all_plugins(...)
  local args = { ... }
  local arglen = #args
  local result = {}

  for i = 1, arglen do
    --delegate_async_function(function()
    local len = #args[i]
    for j = 1, len do
      --delegate_async_function(function()
      insert(result, args[i][j])
      --end)
    end
    --end)
  end
  return result
end

-- local function convertToMap(i_table)
--   local map = {}
--   local input_table = i_table
--   local table_len = #input_table

--   for i = 1, table_len do -- Use numeric for-loop
--     --wrap_async_function(function()
--     local table_item = input_table[i]
--     local t_item_name = table_item[1]
--     local map_entry = map[t_item_name]
--     if not map_entry then
--       map[t_item_name] = {}
--     end
--     map[t_item_name][#map[t_item_name] + 1] = table_item
--     --end)
--   end
--   return map
-- end

-- local function curryMerge(t2)
--   return function(t1)
--     for k, v in pairs(t2) do
--       if type(v) == "table" then
--         if type(t1[k]) == "table" then
--           curryMerge(v)(t1[k])
--         else
--           t1[k] = v
--         end
--       else
--         t1[k] = v
--       end
--     end
--     return t1
--   end
-- end

local function fetch_directories_from_path(path_to_directory, main_dir_init)
  local directory_list = globpath(path_to_directory, "*", 0, 1)
  local d_list_len = #directory_list
  local directory_table = {}

  if main_dir_init then
    directory_table[#directory_table + 1] = main_dir_init .. "/init.lua"
  end

  for i = 1, d_list_len do
    local directory = directory_list[i]
    if isDirectory(directory) and not string.match(directory, "%.lua$") then
      local directory_name = directory:match(".-([^/]+)/*$")
      if not contains(excludedDirectories, directory_name:match(".-([^/]+)/*$")) then
        directory_table[#directory_table + 1] = directory .. "/init.lua"
      end
    end
  end
  return directory_table
end

--> From a given path, and filter; return a list with all relevant files.
local function fetch_lua_files_from_path_no_filter(path)
  local file_table = {}
  local extension_list = globpath(path, "*.lua", 0, 1)
  local e_list_len = #extension_list

  for i = 1, e_list_len do
    insert(file_table, extension_list[i])
  end
  return file_table
end

--> From a given path, and filter; return a list with all relevant files.
local function fetch_lua_files_from_path(path, filter)
  local file_table = {}
  local extension_list = globpath(path, "*.lua", 0, 1)
  local e_list_len = #extension_list

  local item_filter = filter
  for i = 1, e_list_len do
    local e_file_name = fn.fnamemodify(extension_list[i], ":t:r")
    if contains(item_filter, e_file_name) then
      insert(file_table, extension_list[i])
    end
  end
  return file_table
end

local function abstractMerge(target_table, data_table)
  local tt = target_table
  local dt = data_table
  local dlen = #data_table

  for i = 1, dlen do
    insert(target_table, dt[i])
  end

  return tt
end

local function process_specs_in_file(file, cb)
  local specs_from_file = {}
  local fetched_specs = fetchSpecsFromFile(file)
  specs_from_file = abstractMerge(specs_from_file, fetched_specs)

  -- stylua: ignore
  if cb then cb(specs_from_file) end

  return specs_from_file
end

local function multi_spec_fetch(files)
  local collected_specs = {} --match
  local file_map = files --match
  local f_map_len = #file_map

  for i = 1, f_map_len do
    process_specs_in_file(file_map[i], function(specs_from_file)
      abstractMerge(collected_specs, specs_from_file)
    end)
  end

  return collected_specs
end

local function get_filter(filter)
  local cacheController = get_obj("framework.controller.cachecontroller", "cachecontroller")
  return cacheController:query(filter)
end
--  fetcher functions:
local function fetch_core_specs()
  local directories = fetch_directories_from_path(corePath)
  return multi_spec_fetch(directories)
end

local function fetch_language_specs()
  local filtertable = get_filter("languages")
  local languages = fetch_lua_files_from_path(extensionPath, filtertable)
  return multi_spec_fetch(languages)
end

local function fetch_colorscheme_specs()
  local filtertable = get_filter("colorschemes")
  local colorscheme_files = fetch_lua_files_from_path(colorschemePath, filtertable)
  return process_specs_in_file(colorscheme_files[1])
end

local function fetch_secondary_specs()
  local secondary_directories = fetch_lua_files_from_path_no_filter(secondaryPath)
  return multi_spec_fetch(secondary_directories)
end

local function merge_all_plugins_interface(core, languages)
  return function(colorschemes)
    return function(secondary)
      return merge_all_plugins(core, languages, colorschemes, secondary)
    end
  end
end
-- [[ END OF REFACTORED VERSIONS ]]

--> Merge together the: colorscheme-, secondary, core-, and extension plugins.
---@protected
---@param self PluginModel
---@return table
function PluginModel:fetch_all_plugins()
  local core = fetch_core_specs()
  local languages = fetch_language_specs()
  local colorschemes = fetch_colorscheme_specs()
  local secondary = fetch_secondary_specs()

  local curry = merge_all_plugins_interface(core, languages)
  local final_spec = curry(colorschemes)(secondary)

  return final_spec
end

---@param self PluginModel
---@return PluginModel
function PluginModel:new()
  local obj = {}
  setmetatable(obj, self)
  return obj
end

return PluginModel
