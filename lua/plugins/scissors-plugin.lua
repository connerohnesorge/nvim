return {
  "chrisgrieser/nvim-scissors",
  event = "VeryLazy",
  rev = "855ce6b",
  dependencies = "nvim-telescope/telescope.nvim",
  opts = {
    snippetDir = vim.fn.stdpath("config") .. "/snippets",
  }
}
