local ls = require 'luasnip';

ls.add_snippets("php", {
  ls.parser.parse_snippet('inh', [[
/**
 * @inheritdoc
 */
]]),

  ls.parser.parse_snippet('doc', [[
/**
 * $0
 */
]]),

  ls.parser.parse_snippet('tmp', [[
/**
 * @template $0
 */
]]),

  ls.parser.parse_snippet('pm', [[
public function $1($2): $3
{
    $0
}
]]),

  ls.parser.parse_snippet('prm', [[
private function $1($2): $3
{
    $0
}
]]),

    ls.parser.parse_snippet('__inv', [[
public function __invoke($1): $2
{
    $3
}
]]),

})


vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })
