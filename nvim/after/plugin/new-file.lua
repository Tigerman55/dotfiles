local ls = require('luasnip')

local templates = {
    file = {
        php = [[<?php

$0
]],
        svelte = [[<script lang="ts">
    $0
</script>
]],
    },
    class = {
        typescript = [[
export class $1 {
    public constructor($2) {
    }

    $0
}
        ]],
    },
    ['function'] = {
        typescript = [[
export async function $1($2): $3
{
    $0
}
        ]],

    }
}

local function buffer_is_empty(bufnr)
    return vim.api.nvim_buf_line_count(bufnr) == 1
        and vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] == ''
end

local function new_file_snippet_for(fileType, fileTemplate)
    local snippets = ls.get_snippets(fileType) or {}
    for _, snippet in ipairs(snippets) do
        if snippet.trigger == '__new_file' then
            return snippet
        end
    end

    local template = templates[fileTemplate][fileType]
    if template then
        return ls.parser.parse_snippet({ trig = '__new_file_fallback' }, template)
    end
end

local function expand_template_for_current_filetype(fileTemplate)
    local bufnr = vim.api.nvim_get_current_buf()
    if not buffer_is_empty(bufnr) then
        return
    end

    local snippet = new_file_snippet_for(vim.bo.filetype, fileTemplate)
    if snippet then
        ls.snip_expand(snippet)
    end
end

local function resolve_base_dir()
    local ok, oil = pcall(require, 'oil')
    if ok then
        local oil_dir = oil.get_current_dir()
        if oil_dir and oil_dir ~= '' then
            return oil_dir
        end
    end

    return vim.uv.cwd()
end

local function resolve_path(input)
    local normalized = vim.fs.normalize(input)
    if vim.startswith(normalized, '/') then
        return normalized
    end

    return vim.fs.normalize(vim.fs.joinpath(resolve_base_dir(), normalized))
end

local function create_file_from_dialog(fileTemplate)
    vim.ui.input({
        prompt = ('New %s path: '):format(fileTemplate),
        completion = 'file',
    }, function(input)
        if not input or input == '' then
            return
        end

        local path = resolve_path(input)
        local dir = vim.fs.dirname(path)
        local existed = vim.uv.fs_stat(path) ~= nil

        vim.fn.mkdir(dir, 'p')
        vim.cmd.edit(vim.fn.fnameescape(path))

        local function ensure_lsp_attached()
            vim.cmd('silent! LspStart')
        end

        if not existed then
            vim.cmd.write()
            vim.schedule(function()
                ensure_lsp_attached()
                expand_template_for_current_filetype(fileTemplate)
            end)
        else
            vim.schedule(ensure_lsp_attached)
        end
    end)
end

vim.keymap.set('n', '<leader>nn', function ()
    create_file_from_dialog('file')
end, {
    desc = 'Create file in Oil directory',
    silent = true,
})

vim.keymap.set('n', '<leader>nc', function ()
    create_file_from_dialog('class')
end, {
    desc = 'Create class in Oil directory',
    silent = true,
})

vim.keymap.set('n', '<leader>nf', function ()
    create_file_from_dialog('function')
end, {
    desc = 'Create function in Oil directory',
    silent = true,
})

