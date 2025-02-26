return {
    "mfussenegger/nvim-dap",
    recommended = true,
    desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "rcarriga/nvim-dap-ui",
        -- virtual text for the debugger
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {},
        },
    },

    -- stylua: ignore
    keys = {
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
        { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
        { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
        { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>dj", function() require("dap").down() end, desc = "Down" },
        { "<leader>dk", function() require("dap").up() end, desc = "Up" },
        { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
        { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
        { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
        { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
        { "<leader>ds", function() require("dap").session() end, desc = "Session" },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },

    config = function()
        local dap = require('dap')

        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

        dap.adapters.dart = {
            type = "executable",
            command = "dart",
            args = {"debug_adapter"},
        }
        dap.adapters.flutter = {
            type = "executable",
            command = "flutter",
            args = {"debug_adapter"},
        }
        dap.adapters.flutter_test = {
            type = "executable",
            command = "flutter",
            args = {"debug_adapter", "--test"},
        }
        dap.configurations.dart = {
            {
                type = "flutter",
                request = "launch",
                name = "Launch flutter",
                dartSdkPath = "/opt/homebrew/bin/dart",
                flutterSdkPath = "/opt/homebrew/bin/flutter",
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
            },
            {
                type = "flutter_test",
                request = "launch",
                name = "Run test file",
                dartSdkPath = "/opt/homebrew/bin/dart",
                flutterSdkPath = "/opt/homebrew/bin/flutter",
                program = "${file}",
                cwd = "${workspaceFolder}",
            },
            {
                type = "dart",
                request = "launch",
                name = "Launch dart",
                dartSdkPath = "/opt/homebrew/bin/dart",
                flutterSdkPath = "/opt/homebrew/bin/flutter",
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
            },
        }
    end,
}
