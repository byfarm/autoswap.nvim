vim.api.nvim_create_user_command("StartSwap", function()
    require("autoswap").setup()
end, {})
