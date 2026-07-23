-- ~/.config/hypr/hyprland.lua
--
-- Orchestrator only. No config logic lives here — it loads bootstrap,
-- resolves the scheme, merges user overrides, then requires every module
-- through boot.safe_require so a broken module logs+notifies instead of
-- killing everything that loads after it.

local home = os.getenv("HOME")
local hypr = home .. "/.config/hypr"
package.path = package.path .. ";" .. home .. "/.config/caelestia/?.lua"

-- This ONE require is intentionally NOT wrapped in pcall: if bootstrap
-- itself fails to load, nothing downstream can help anyway, and Hyprland's
-- own emergency binds (SUPER+Q/R/M) are the fallback at that point.
local boot = require("core.bootstrap")

local function maybe_create(file, content)
    local f = io.open(file)
    if f then f:close(); return end
    f = io.open(file, "w")
    if f then
        if content then f:write(content) end
        f:close()
    end
end

local function maybe_copy(src, dst)
    local out = io.open(dst)
    if out then out:close(); return end
    local input = io.open(src, "r")
    if not input then return end
    out = io.open(dst, "w")
    if out then
        out:write(input:read("*a"))
        out:close()
    end
    input:close()
end

-- Scheme bootstrap: chezmoi applies scheme/private_current.lua -> current.lua
-- on this machine, so this is a fallback ONLY — it fires if current.lua is
-- somehow absent (fresh clone without chezmoi apply having run yet), never
-- overwriting a chezmoi-managed file that already exists.
maybe_copy(hypr .. "/scheme/default.lua", hypr .. "/scheme/current.lua")

-- User variable overrides, deep-merged so nested tables (floatRules etc.)
-- merge instead of getting clobbered wholesale by a partial override.
maybe_create(home .. "/.config/caelestia/hypr-vars.lua", "return {}\n")
local overrides = boot.safe_require("hypr-vars")
if type(overrides) == "table" then
    local vars = boot.safe_require("variables")
    if vars then
        boot.deep_merge(vars, overrides)
    end
end

-- Default monitor conf
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- Core modules, in dependency order (see the plan from earlier in this thread).
-- Each goes through safe_require: a failure here logs + notifies but does not
-- prevent modules further down the list — critically, keybinds.lua still
-- loads even if, say, rules.lua has a typo.
local modules = {
    "hyprland.env",
    "hyprland.general",
    "hyprland.input",
    "hyprland.misc",
    "hyprland.animations",
    "hyprland.decoration",
    "hyprland.group",
    "hyprland.functions",
    "hyprland.execs",
    "hyprland.rules",
    "hyprland.gestures",
    "hyprland.keybinds",
}

for _, name in ipairs(modules) do
    boot.safe_require(name)
end

-- User configs (also safe — a broken hypr-user.lua shouldn't take down
-- everything that already loaded above it)
maybe_create(home .. "/.config/caelestia/hypr-user.lua")
boot.safe_require("hypr-user")
