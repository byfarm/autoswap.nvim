-- local log = require("log")
local M = {}
local state_machine = {
    key_string = "",
    add_keys = false,
}

local function reset_state_machine()
    -- reset the state machine
    state_machine.key_string = ""
    state_machine.add_keys = false
end

---actrually replaces the stuff wanted
---@param prefix string
---@param dl string
---@param replace_key string
---@param key string
local function replace(prefix, dl, replace_key, key)
    --  delete back to the delemeter into the null buffer and insert the replace key
    vim.api.nvim_input(prefix .. "<ESC>vF" .. dl .. "\"_c" .. replace_key .. key)
end

---gets the replacement based on key from the lookup table
---@param key string
---@return string | nil
local function get_replacement(key)
    return M.config.lookup_table[key]
end

---implements fn for vim.on_key()
---@param key string
---@param typed string
---@return string
local get_keys = function(key, typed)
    -- if not in insert mode or special charachter (newline) then reset the machine
    local translated_key = vim.fn.keytrans(key)
    if vim.api.nvim_get_mode().mode ~= "i" then
        reset_state_machine()
        return key
    end

    -- if backspace then do -1 from the substring
    if "<BS>" == translated_key and #state_machine.key_string > 0 then
        state_machine.key_string = state_machine.key_string:sub(1, #state_machine.key_string - 1)
        return key
    end

    local key_string_empty = state_machine.key_string == ""

    local dl = M.config.delemeter

    if key_string_empty and key == dl then
        -- turn the flag on to start adding to keystring
        state_machine.add_keys = true
        return key
    end

    local key_is_alphanumeric = key:match("%w")
    -- append the key to the keystring
    if state_machine.add_keys and key_is_alphanumeric then
        state_machine.key_string = state_machine.key_string .. key

        if M.config.greedy == true then
            -- if greedy want to check if string matches
            local replace_key = get_replacement(state_machine.key_string)

            -- if string does match make the replacement
            if replace_key then
                replace("", dl, replace_key, "")
                reset_state_machine()
                return key
            end
        end

        -- try to replace on non-alphanumeric
    elseif state_machine.add_keys and not key_is_alphanumeric then
        local replace_key = get_replacement(state_machine.key_string)

        if replace_key then
            local prefix = ""

            if translated_key == "<CR>" then
                prefix = "<BS>"
            end
            replace(prefix, dl, replace_key, key)
        end

        reset_state_machine()
    end

    return key
end

M.setup = function(opts)
    opts = opts or {}
    if opts["behavior"] == "overwrite" then
        M.config = opts
    else
        M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    end

    -- runs the actual plugin
    vim.on_key(get_keys)
end

-- default config
M.config = {
    delemeter = "\\",
    greedy = false,
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
return M
