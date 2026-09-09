-- ~/.markdownlint.json is NOT picked up automatically: markdownlint-cli2
-- only resolves config files within the globbed project tree, it does not
-- walk up to $HOME. Force every markdownlint-cli2 invocation (lint + format)
-- to load it explicitly so rules like disabling MD013 apply everywhere.
local global_config = vim.fn.expand("~/.markdownlint.json")

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", global_config },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", global_config },
        },
      },
    },
  },
}
