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
