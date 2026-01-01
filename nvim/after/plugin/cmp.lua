local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },

  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
})

local cmp = require("cmp")
local types = require("cmp.types")

cmp.setup({
  -- your existing config…

  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- etc...
  },
})

-- After confirming a completion item, auto-add "::" for classes/enums
local cmp   = require("cmp")
local types = require("cmp.types")

cmp.setup({
  -- your normal setup...
})

local function in_type_or_signature_context(line, word_start_col)
  local before = line:sub(1, word_start_col - 1)

  -- 1. function signatures
  if before:match("%f[%w_]function%f[%W]") or before:match("%f[%w_]fn%f[%W]") then
    return true
  end

  -- 2. property declarations: public Foo $x;
  if before:match("%f[%w_](public|protected|private|var)%f[%W]") then
    local after = line:sub(word_start_col)
    -- if after-type token is a $, it's a property declaration
    if after:match("^%s*[%w_\\]+%s+%$") or after:match("^%s*%$") then
      return true
    end
  end

  -- 3. return type on same line
  if before:match(":%s*[%w_\\]+$") then
    return true
  end

  -- 4. extends
  if before:match("%f[%w_]extends%f[%W]") then
    return true
  end

  -- 5. implements
  if before:match("%f[%w_]implements%f[%W]") then
    return true
  end

  -- 6. inside interface / trait declarations
  if before:match("%f[%w_]interface%f[%W]") then
    return true
  end

  if before:match("%f[%w_]trait%f[%W]") then
    return true
  end

  return false
end


-- need to clean this up significantly. Just an AI vibecode version that is buggy
--[[cmp.event:on("confirm_done", function(evt)
  -- Only for PHP
  local bufnr = evt.buf or vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype ~= "php" then
    return
  end

  local kind = evt.entry:get_kind()

  -- Only apply to class / enum items
  if
    kind ~= types.lsp.CompletionItemKind.Class
    and kind ~= types.lsp.CompletionItemKind.Enum
  then
    return
  end

  ------------------------------------------------------------------------------
  -- Find insertion boundaries
  ------------------------------------------------------------------------------
  local row, col0 = unpack(vim.api.nvim_win_get_cursor(0))
  local line      = vim.api.nvim_get_current_line()
  local col       = col0 + 1   -- convert to 1-based

  -- Find start of word we just inserted
  local start_col = col
  while start_col > 1 do
    local ch = line:sub(start_col - 1, start_col - 1)
    if ch:match("[%w_\\]") then
      start_col = start_col - 1
    else
      break
    end
  end

  -- If inside a type context (interfaces, extends, properties, etc.)
  if in_type_or_signature_context(line, start_col) then
    return
  end

  ------------------------------------------------------------------------------
  -- Insert :: unless already present
  ------------------------------------------------------------------------------
  if line:sub(col, col + 1) == "::" then
    return
  end

  local before = line:sub(1, col0)
  local after  = line:sub(col0 + 1)
  vim.api.nvim_set_current_line(before .. "::" .. after)

  -- Move cursor after ::
  vim.api.nvim_win_set_cursor(0, { row, col0 + 2 })

  -- Trigger second completion (enum cases, named ctors)
  cmp.complete()
end)]]--

