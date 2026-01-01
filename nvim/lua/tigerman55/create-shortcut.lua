-- Derive namespace from composer.json autoload psr-4 map
local function derive_namespace_from_composer(folder)
  -- Find project root (with composer.json)
  local root = vim.fs.root(folder, { "composer.json", ".git" })
  if not root then
    return nil
  end

  local composer_path = root .. "/composer.json"
  local f = io.open(composer_path, "r")
  if not f then
    return nil
  end

  local content = f:read("*a")
  f:close()

  -- Decode JSON (Neovim 0.11 has vim.json.decode)
  local ok, data = pcall(function()
    if vim.json and vim.json.decode then
      return vim.json.decode(content)
    else
      return vim.fn.json_decode(content)
    end
  end)

  if not ok or type(data) ~= "table" then
    return nil
  end

  -- Collect psr-4 maps from autoload + autoload-dev
  local psr4 = {}

  local function collect_psr4(section)
    if type(section) ~= "table" then
      return
    end
    local map = section["psr-4"]
    if type(map) ~= "table" then
      return
    end
    for ns, path in pairs(map) do
      psr4[ns] = path
    end
  end

  collect_psr4(data.autoload)
  collect_psr4(data["autoload-dev"])

  if vim.tbl_isempty(psr4) then
    return nil
  end

  -- Normalize folder path relative to root
  local rel_folder = folder:sub(#root + 2) -- strip "/root/"
  rel_folder = rel_folder:gsub("\\", "/")
  if rel_folder ~= "" and not rel_folder:match("/$") then
    rel_folder = rel_folder .. "/"
  end

  -- Find best matching (longest) PSR-4 path prefix
  local best_ns = nil
  local best_path = nil

  local function try_match(ns, path)
    local paths = path
    if type(paths) == "string" then
      paths = { paths }
    end
    if type(paths) ~= "table" then
      return
    end

    for _, p in ipairs(paths) do
      local norm = p:gsub("\\", "/")
      if norm ~= "" and not norm:match("/$") then
        norm = norm .. "/"
      end

      if rel_folder:sub(1, #norm) == norm then
        if not best_path or #norm > #best_path then
          best_path = norm
          best_ns = ns
        end
      end
    end
  end

  for ns, path in pairs(psr4) do
    try_match(ns, path)
  end

  if not best_ns then
    return nil
  end

  -- Build the remainder of the namespace from the subpath after the psr-4 directory
  local subpath = rel_folder:sub(#best_path + 1) -- can be "" or "Foo/Bar/"
  if subpath:sub(-1) == "/" then
    subpath = subpath:sub(1, -2)
  end

  local base_ns = best_ns:gsub("\\+$", "") -- trim trailing backslashes from prefix
  local sub_ns = subpath:gsub("/", "\\")
  if sub_ns ~= "" then
    return base_ns .. "\\" .. sub_ns
  end

  return base_ns
end

vim.api.nvim_create_user_command("CreatePhpClass", function(opts)
  local class = opts.args
  if class == "" then
    print("Provide a class name: :CreatePhpClass ClassName")
    return
  end

  -- Folder of the current buffer
  local folder = vim.fn.expand("%:p:h")
  if folder == "" then
    print("No valid folder detected")
    return
  end

  local file = folder .. "/" .. class .. ".php"

  -- Guess namespace from composer.json
  local ns = derive_namespace_from_composer(folder)
  if ns then
    ns = ns:gsub("^\\+", "")  -- FIX: Prevent leading "\" in namespace
  end
  local namespace_line = ns and ("namespace " .. ns .. ";") or ""

  local contents = [[<?php

declare(strict_types=1);

]] .. (namespace_line ~= "" and namespace_line .. "\n\n" or "") ..
[[final class ]] .. class .. [[ 
{
    public function __construct()
    {
    }
}
]]

  -- Write (overwrites if exists)
  local fd = io.open(file, "w")
  if not fd then
    print("Could not write file: " .. file)
    return
  end
  fd:write(contents)
  fd:close()

  -- Open in current window (replace current buffer)
  vim.cmd("edit " .. vim.fn.fnameescape(file))

  print("Created: " .. file)
end, {
  nargs = 1,
  complete = "file",
})

