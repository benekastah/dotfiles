return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "sidlatau/neotest-dart"
  },
  keys = {
    { "<leader>tr", function() require('neotest').run.run() end, desc = "Run nearest test" },
    { "<leader>td", function() require('neotest').run.run({strategy = "dap"}) end, desc = "Debug nearest test" },
    { "<leader>ts", function() require('neotest').run.stop() end, desc = "Stop nearest test" },
    { "<leader>tf", function() require('neotest').run.run(vim.fn.expand('%')) end, desc = "Run test file" },
    { "<leader>ts", function() require('neotest').summary.toggle() end, desc = "Toggle test summary" },
    { "<leader>to", function() require('neotest').output_panel.toggle() end, desc = "Toggle test output" },
  },
  config = function()
    require('neotest').setup({
      summary = {
        mappings = {
          expand = "e",
          expand_all = "E",
          output = "o",
          jumpto = "J",
          stop = "s",
          run = "r",
          debug = "d",
          mark = "m",
          run_marked = "R",
          debug_marked = "D",
          clear_marked = "c",
          target = "t",
          clear_target = "T",
          next_failed = "f",
          prev_failed = "F",
          watch = "w",
        }
      },
      adapters = {
        require('neotest-dart') {
          command = 'flutter',
          use_lsp = true
        }
      }
    })
  end
}
