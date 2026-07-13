return {
    {
        "atdma/caelestia-nvim",
        priority = 1000,
        lazy = false,
        opts = {},
        config = function(_, opts)
            require("caelestia").setup(opts)
            vim.api.nvim_create_autocmd("Colorscheme", {
                pattern = "caelestia",
                callback = function()
                    vim.api.nvim_set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
                    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", ctermbg = "none" })
                    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none", ctermbg = "none" })
                end,
            })
            vim.cmd.colorscheme("caelestia")
        end,
    },
}
