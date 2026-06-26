--  (otherwise wrong leader will be used)
vim.g.mapleader = "\\"
vim.g.maplocalleader = " "
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
vim.diagnostic.config({ virtual_text = true })
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  }
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
require("lazy").setup {
  { "Bilal2453/luvit-meta", lazy = true },
  { "tpope/vim-sleuth" },
  {
    import = "plugins",
  },
}

require "conneroisu.options"

local highlight_group = vim.api.nvim_create_augroup(
  "YankHighlight",
  { clear = true }
)

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.cmd "syntax on"
vim.cmd "set wrap!"

require "keymaps.visual-keymaps"
require "keymaps.insert-keymaps"
require "keymaps.normal-keymaps"

vim.o.statusline = vim.o.statusline .. "%F"

-- Register the .templ filetype
vim.filetype.add { extension = { templ = "templ", svelte = "svelte" } }
vim.treesitter.language.register("templ", "templ")
vim.treesitter.language.register("svelte", "svelte")

-- vim.cmd "set list"
-- vim.cmd("set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<")

vim.api.nvim_create_user_command('LspLogClear', function()
  local log_path = vim.fn.expand("~/.local/state/nvim/lsp.log")
  local file = io.open(log_path, "w")
  if file then
    file:close()
    print("lsp.log cleared.")
  else
    print("Error: Could not open lsp.log.")
  end
end, {})

vim.api.nvim_create_user_command("Cppath", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

-- vim.lsp.set_log_level("debug")

vim.filetype.add {
  extension = { rasi = 'rasi' },
  pattern = {
    ['.*/waybar/config'] = 'jsonc',
    ['.*/mako/config'] = 'dosini',
    ['.*/kitty/*.conf'] = 'bash',
    ['.*/hypr/.*%.conf'] = 'hyprlang',
  },
}

vim.o.number = true
vim.o.relativenumber = true

require "uni"
