return {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    opts = {
        debugger = {
            enabled = true,
        },
        lsp = {
            settings = {
                renameFilesWithClasses = "always",
            },
        },
    },
}
