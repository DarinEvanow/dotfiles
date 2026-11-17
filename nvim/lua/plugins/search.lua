-- Search keymaps that replace LazyVim's defaults under <leader>s.
return {
  {
    "folke/todo-comments.nvim",
    keys = {
      -- LazyVim: <leader>st = every todo keyword, <leader>sT = TODO/FIX/FIXME.
      -- Here <leader>st takes the narrower list and <leader>sT is freed for
      -- the test-excluding grep below.
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Todo/Fix/Fixme",
      },
      { "<leader>sT", false },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>sT",
        -- Like <leader>/ (grep from the project root), but skips any file or
        -- directory with "test" in its name, case-insensitively (so TestModal.tsx
        -- and __tests__/ are excluded too).
        function()
          LazyVim.pick("grep", { args = { "--iglob=!*test*" } })()
        end,
        desc = "Grep (Root Dir, excluding tests)",
      },
    },
  },
}
