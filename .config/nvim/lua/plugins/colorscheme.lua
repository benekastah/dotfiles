return {
    -- "rebelot/kanagawa.nvim",
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        -- vim.cmd.colorscheme 'kanagawa'
        vim.cmd.colorscheme 'tokyonight-night'
    end
}
