return {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
        -- Advertise nvim-cmp's richer completion capabilities (snippets +
        -- auto-import via additionalTextEdits) to every LSP server.
        vim.lsp.config("*", {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })

        -- You can pass LSP settings to the server:
        vim.lsp.config("rust_analyzer", {
            settings = {
                ["rust-analyzer"] = {
                    imports = {
                        granularity = {
                            group = "module",
                        },
                        prefix = "self",
                    },
                    cargo = {
                        buildScripts = {
                            enable = true,
                        },
                    },
                    procMacro = {
                        enable = true
                    },
                },
            },
        })

        -- Show diagnostics inline (virtual text) plus a nicer float; by
        -- default Neovim only shows signs/underline with no visible message.
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = { border = "rounded", source = true },
        })

        -- Auto-open the diagnostic float when the cursor rests on a line.
        -- CursorHold fires after 'updatetime' ms, so shorten it a bit.
        vim.o.updatetime = 300
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.diagnostic.open_float(nil, { focus = false })
            end,
        })

        -- Actually start rust_analyzer. vim.lsp.config() only stores settings;
        -- vim.lsp.enable() registers the FileType autocmd that launches the server.
        vim.lsp.enable("rust_analyzer")

        -- You can enable different LSP features
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(ev)
                local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
                -- Inlay hints display inferred types, etc.
                if client:supports_method("textDocument/inlayHint") then
                    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                end
                -- Completion is handled by nvim-cmp (see lua/plugins/nvim-cmp.lua),
                -- so we intentionally do NOT enable Neovim's built-in completion here.

                -- Buffer-local LSP keymaps (only active where a server attaches).
                -- Neovim 0.11+ already provides defaults for K, grn, gra, grr,
                -- gri, gO and <C-S>; these are the extra/custom bindings.
                local function map(mode, lhs, rhs)
                    vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf })
                end
                map("n", "gd", vim.lsp.buf.definition)
                map("n", "gn", vim.lsp.buf.rename)
                map({ "n", "x" }, "ga", vim.lsp.buf.code_action)
                map("i", "<C-S>", vim.lsp.buf.signature_help)
            end,
        })
    end,
}
