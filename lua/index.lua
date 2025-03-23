local log = require("log")
local M = {}
M.setup = function()
    -- todo
end


local function reset_state_machine()
    -- reset the state machine
    M.info.key_string = ""
    M.info.add_keys = false
end
local function in_table(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then return key end
    end
    return false
end

---implements fn for vim.on_key()
---@param key string
---@param typed string
---@return string
M.get_keys = function(key, typed)
    if vim.api.nvim_get_mode().mode ~= "i" or in_table(M.config.clears_list, key) then
        reset_state_machine()
        return key
    end

    local dl = M.config.delemeter

    if key ~= " " then
        return key
    end

    -- vim.api.nvim_input("<ESC>h")
    local word_under_cursor = vim.fn.expand("<cWORD>")
    log.debug(word_under_cursor)

    if not string.find(word_under_cursor, dl, 1, true) then
        vim.api.nvim_input("la")
        return key
    end

    -- take the dl out of the string
    local string_matcher = string.sub(word_under_cursor, 2, #word_under_cursor - 1)
    -- nil if matcher not in table
    local replace_value = M.config.lookup_table[string_matcher]

    if replace_value then
        local save_view = vim.fn.winsaveview()
        vim.api.nvim_input("<ESC>V:s/" .. word_under_cursor .. "/" .. replace_value .. "/<CR>")
        vim.fn.winrestview(save_view)
    end

    return key
end

M.run_plugin = function()
    vim.on_key(M.get_keys)
end

M.info = {
    key_string = "",
    add_keys = false,
}

M.config = {
    clears_list = { "<CR>", "<BS>" },
    -- delemeter = "\\",
    delemeter = ";",
    yank_register = "f",
    lookup_table = {
        alpha = "α",
        Alpha = "Α",

        beta = "β",
        Beta = "Β",

        gamma = "γ",
        Gamma = "Γ",

        delta = "δ",
        Delta = "Δ",

        epsilon = "ε",
        Epsilon = "Ε",

        zeta = "ζ",
        Zeta = "Ζ",

        nthingy = "η",
        Nthingy = "Η",

        theta = "θ",
        Theta = "Θ",

        kappa = "κ",
        Kappa = "Ι",

        lambda = "λ",
        Lambda = "Λ",

        mu = "μ",
        Mu = "Μ",

        nu = "ν",
        Nu = "Ν",

        eta = "ξ",
        Eta = "Ξ",

        rho = "ρ",
        Rho = "Ρ",

        sum = "ς",
        Sum = "Σ",

        sigma = "σ",
        Sigma = "Σ",

        tau = "τ",
        Tau = "Τ",

        nus = "υ",
        Nus = "Υ",

        phi = "φ",
        Phi = "Φ",

        xi = "χ",
        Xi = "Χ",

        wave = "ψ",
        Wave = "Ψ",

        omega = "ω",
        Omega = "Ω",
    },
}

M.run_plugin()
return M
