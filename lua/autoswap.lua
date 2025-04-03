local log = require("log")
local M = {}

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
        return key
    end

    local dl = M.config.delemeter

    local key_is_alphanumeric = key:match("%w")
    -- append the key to the keystring
    if key_is_alphanumeric then
        -- if greedy want to check if string matches
        local replace_words = vim.fn.expand("<cword>")
        local replacement = get_replacement(replace_words)

        -- if string does match make the replacement
        if replacement then
            log.info("can replace")
            -- replace("", dl, replacement, "")
            return key
        end
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
