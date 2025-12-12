-- map space to no operation so that it can be used as a prefix key
vim.keymap.set("n", "<Space>", "<Nop>", {
  desc = "No Operation on Space"
})

-- Map J in normal mode to join lines by staying at the current postiion
vim.keymap.set("n", "J", "mzJ`z", {
  desc = "Join lines"
})

vim.keymap.set("n", "<C-e>", function()
  local cwd = vim.fn.expand("%:p:h")
  local path = vim.fn.expand("%:p")
  if string.match(cwd, "oil") then
    vim.cmd("!open " .. " . ")
  else
    vim.cmd("!open " .. path)
  end
end, {
  desc = "Open the current working directory in the file explorer"
})

vim.api.nvim_set_keymap("n", "<A-j>", "<cmd>m .+1<cr>==", {
  desc = "Move down"
})

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", {
  expr = true,
  silent = true
})

-- Remap for dealing with word wrap
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", {
  expr = true,
  silent = true
})

-- bind leader + e to open the init.lua file in normal mode
vim.keymap.set("n", "<leader>ee", function()
  vim.cmd(":e $MYVIMRC")
  -- set cwd to the current buffer's directory
  vim.cmd("cd " .. vim.fn.expand("%:p:h"))
end, {
  noremap = true,
  silent = true,
  desc = "Open init.lua"
})

-- bind shift + h to move to the start of the line in normal mode
vim.api.nvim_set_keymap("n", "<S-h>", "^", {
  noremap = true,
  silent = true,
  desc = "Move cursor to the start of the line"
})

-- bind shift + l to move to the end of the line in normal mode
vim.api.nvim_set_keymap("n", "<S-l>", "$", {
  noremap = true,
  silent = true,
  desc = "Move cursor to the end of the line"
})

vim.api.nvim_set_keymap("n", "<leader>L", "<cmd>:Lazy<cr>", {
  desc = "Open Lazy Modal"
})

-- Bind redo to Ctrl + Y
vim.api.nvim_set_keymap("n", "<C-y>", "<cmd>redo<cr>", {
  desc = "Redo"
})

-- Function to get the cwd of the current buffer
function _G.get_cwd()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local cwd = vim.fn.fnamemodify(bufname, ":h")
  return cwd
end

-- Bind leader + b + p to copy the current buffer path to the clipboard
vim.keymap.set("n", "<leader>bp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.cmd("echo 'Copied: " .. path .. " to clipboard'")
end, {
  desc = "Copy buffer path to clipboard"
})

-- Bind alt + shift + f to :Format in normal mode
vim.keymap.set("n", "<A-S-f>", vim.lsp.buf.format, {
  desc = "Format"
})

vim.api.nvim_set_keymap("n", "n", "'Nn'[v:searchforward]", {
  expr = true,
  desc = "Next search result"
})

vim.api.nvim_set_keymap("n", "N", "'nN'[v:searchforward]", {
  expr = true,
  desc = "Prev search result"
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {
  desc = 'Go to previous diagnostic message'
})

vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {
  desc = 'Go to next diagnostic message'
})

-- map leader + l + l to restart the lsp in normal mode
vim.api.nvim_set_keymap("n", "<leader>ll", ":LspRestart<CR>", {
  noremap = true,
  silent = true,
  desc = "Restart LSP"
})

vim.keymap.set("n", "<leader>gmt", function()
  vim.cmd("!go mod tidy<CR>")
end, {
  noremap = true,
  silent = true,
  desc = "Run Go Mod Tidy in CWD"
})

-- set leader + g + t to run go tests when in a go file
vim.keymap.set("n", "<leader>gt", function()
  vim.cmd(":GoTest")
end, {
  noremap = true,
  silent = true,
  desc = "Run Go Tests"
})

vim.keymap.set("n", "<leader>rr", function()
  vim.cmd(":Rest run")
end, {
  desc = "Run request under the cursor"
})

vim.keymap.set("n", "<leader>rl", function()
  vim.cmd(":Rest run last")
end, {
  desc = "Re-run latest request"
})

vim.keymap.set("n", "<leader><leader>", function()
  require("telescope").extensions.smart_open.smart_open()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>ed", function()
  local handle = io.popen("git rev-parse --show-toplevel")
  if handle then
    local git_root = handle:read("*a"):gsub("%s+$", "")
    handle:close()
    vim.cmd("edit " .. git_root .. "/flake.nix")
  end
end, {
  desc = "Open devenv.nix"
})

vim.keymap.set("n", "<leader>ob", function()
    vim.cmd(":ObsidianOpen")
  end,
  {
    desc = "Open Obsidian"
  }
)
