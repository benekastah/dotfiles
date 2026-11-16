-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Merge helpers
map("n", "<leader>ml", function()
  vim.api.nvim_exec2([[ :exe "/<<<<<<<\\\|=======\\\|>>>>>>>" ]], {})
end)
map("n", "<leader>mh", function()
  vim.api.nvim_exec2([[ :exe "?<<<<<<<\\\|=======\\\|>>>>>>>" ]], {})
end)

map("n", "<leader>co", function()
  vim.cmd(":copen")
end, { desc = ":copen" })
map("n", "<leader>cc", function()
  vim.cmd(":cclose")
end, { desc = ":cclose" })
map("n", "<leader>n", function()
  vim.cmd(":cn")
end, { desc = ":cn" })
map("n", "<leader>p", function()
  vim.cmd(":cp")
end, { desc = ":cp" })
