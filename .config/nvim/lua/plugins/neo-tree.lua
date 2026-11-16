return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      group_empty_dirs = true,
      scan_mode = "deep",
    },
  },
  keys = {
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          dir = require("lazyvim.util").get_root(),
          source = "buffers",
        })
      end,
      desc = "Explorer NeoTree (root dir)",
    },
    {
      "<leader>bE",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd(), source = "buffers" })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
  },
}
