return {
  -- add gruvbox, matching the terminal (oh-my-posh gruvbox theme in .zshrc)
  { "ellisonleao/gruvbox.nvim" },

  -- tell LazyVim to load gruvbox as the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
