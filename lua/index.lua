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
    -- print(M.info.key_string)
    -- print(vim.api.nvim_get_mode().mode)

    if vim.api.nvim_get_mode().mode ~= "i" or in_table(M.config.clears_list, key) then
        reset_state_machine()
        return key
    end

    local key_string_empty = M.info.key_string == ""

    local dl = M.config.delemeter

    if key_string_empty and key == dl then
        -- turn the flag on to
        M.info.add_keys = true
        return key
    end

    if M.info.add_keys and key ~= " " then
        -- append the key to the keystring
        M.info.key_string = M.info.key_string .. key
    elseif M.info.add_keys and key == " " then
        local replace_key = M.config.lookup_table[M.info.key_string]

        if replace_key then
            --  delete back to the delemeter into the null buffer and insert the replace key
            vim.api.nvim_input("<ESC>vF" .. dl .. "\"_c" .. replace_key .. " ")
        end

        reset_state_machine()
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
