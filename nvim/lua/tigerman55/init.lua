local function load_env()
  local env_file = vim.fn.expand("~/.config/nvim/.env.local")
  if vim.fn.filereadable(env_file) == 1 then
    for line in io.lines(env_file) do
      local key, value = line:match("^(%w+)%=(.*)$")
      if key and value then
        vim.fn.setenv(key, value)
      end
    end
  end
end

load_env()

require("tigerman55.lazy")
require("tigerman55.remap")
require("tigerman55.vim-options")
require("tigerman55.create-shortcut")

local path = vim.fn.stdpath("config") .. "/lua/tigerman55/projects/local/config.lua"

local f, err = loadfile(path)

if f ~= nil then
    local project_root = vim.fn.getcwd();
    local localProjects = f()

    for projectName, projectRoot in pairs(localProjects) do
        if project_root == projectRoot then
            require("tigerman55.projects.local." .. projectName)

            break
        end
    end
end

