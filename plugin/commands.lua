vim.api.nvim_create_user_command("StartReplace", function()
    require("autoswap").setup()
end, {})
