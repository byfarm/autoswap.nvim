local M = {}

M.setup = function()
    -- todo
end

local function reset_state_machine()
    -- reset the state machine
    M.info.key_string = ""
    M.info.add_keys = false
end

---implements fn for vim.on_key()
---@param key string
---@param typed string
---@return string
M.get_keys = function(key, typed)
    -- if not in insert mode or special charachter (newline) then reset the machine
    local translated_key = vim.fn.keytrans(key)
    if vim.api.nvim_get_mode().mode ~= "i" or M.config.clears_list[translated_key] then
        reset_state_machine()
        return key
    end

    -- if backspace then do -1 from the substring
    if "<BS>" == translated_key and #M.info.key_string > 0 then
        M.info.key_string = M.info.key_string:sub(1, #M.info.key_string - 1)
        return key
    end

    local key_string_empty = M.info.key_string == ""

    local dl = M.config.delemeter

    if key_string_empty and key == dl then
        -- turn the flag on to start adding to keystring
        M.info.add_keys = true
        return key
    end

    local key_is_alphanumeric = key:match("%w")
    -- append the key to the keystring
    if M.info.add_keys and key_is_alphanumeric then
        M.info.key_string = M.info.key_string .. key

    -- try to replace on non-alphanumeric
    elseif M.info.add_keys and not key_is_alphanumeric then
        local replace_key = M.config.lookup_table[M.info.key_string]

        if replace_key then
            --  delete back to the delemeter into the null buffer and insert the replace key
            vim.api.nvim_input("<ESC>vF" .. dl .. "\"_c" .. replace_key .. key)
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
    clears_list = { "<CR>", },
    -- delemeter = "\\",
    delemeter = ";",
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

        eta = "η",
        Eta = "Η",

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

        xi = "ξ",
        Xi = "Ξ",

        pi = "π",
        Pi = "Π",

        rho = "ρ",
        Rho = "Ρ",

        sigma = "σ",
        Sigma = "Σ",

        tau = "τ",
        Tau = "Τ",

        upsilon = "υ",
        Upsilon = "Υ",

        phi = "φ",
        Phi = "Φ",

        chi = "χ",
        Chi = "Χ",

        psi = "ψ",
        Psi = "Ψ",

        omega = "ω",
        Omega = "Ω",
    },
}

M.run_plugin()
return M
