return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend" },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    },
    opts = {
      terminal = {
        snacks_win_opts = {
          keys = {
            -- snacks' "terminal" style normally turns a quick double-<Esc> into
            -- :stopinsert (drop to Neovim Normal mode) instead of forwarding the
            -- 2nd <Esc> to the job. Claude Code's rewind UI needs that 2nd <Esc>,
            -- so disable the double-escape behavior just for the Claude terminal.
            term_normal = false,
          },
        },
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)
      vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Exit terminal + move to editor (left)" })
    end,
  },
}
