-- ~/.config/hypr/hyprland/rules.lua
local vars = require("variables")
local boot = require("core.bootstrap")

----------------------
---- Window rules ----
----------------------

local window_rules = {
    -- Center all floating windows (skip xwayland — breaks popups/menus)
    { match = { float = true, xwayland = false }, center = true },

    ------------------------------------------------------------------
    -- Opaque apps: forces solid regardless of the universal transparency
    -- set in decoration.lua. Rebuilt against what's actually installed —
    -- video/image/screenshot content and shell UI look wrong blurred/see-
    -- through; everything else stays universally transparent as you asked.
    ------------------------------------------------------------------
    { match = { class = "mpv" }, tag = "+opaque_app" },              -- video playback
    { match = { class = "org.kde.okular" }, tag = "+opaque_app" },   -- document/image reader
    { match = { class = "swappy" }, tag = "+opaque_app" },           -- screenshot editor
    { match = { class = "org.quickshell" }, tag = "+opaque_app" },   -- caelestia shell surfaces
    { match = { tag = "opaque_app" }, opaque = true },

    ------------------------------------------------------------------
    -- Floating utility apps (sized/centered via variables.floatRules,
    -- applied at spawn time by fn.floatSpawnRule in keybinds.lua — these
    -- window_rule entries just catch the ones NOT spawned through a keybind,
    -- e.g. launched from a menu/rofi/fuzzel directly)
    ------------------------------------------------------------------
 
    -- GTK/portal file pickers and misc system dialogs (xdg-desktop-portal-gtk)
    {
        match = {
            title = "(Select|Open)( a)? (File|Folder)(s)?|File (Operation|Upload)( Progress)?|.* Properties|Save As",
        },
        tag = "+float",
    },

    { match = { tag = "float" }, float = true },

    ------------------------------------------------------------------
    -- Proportionally-sized floating utility windows (scale with monitor,
    -- unlike variables.floatRules which is fixed-pixel)
    ------------------------------------------------------------------
    { match = { class = "org.pulseaudio.pavucontrol" }, tag = "+float_60_70" },
    { match = { class = "dev.geopjr.Tuba" }, tag = "+float_70_80" },
    { match = { class = "nwg-look" }, tag = "+float_50_60" },
    { match = { class = "blueman-manager" }, tag = "+float_60_70" },
    { match = { class = "org.kde.partitionmanager" }, tag = "+float_70_80" },

    {
        match  = { tag = "float_60_70" },
        float  = true,
        size   = "(monitor_w*0.6) (monitor_h*0.7)",
        center = true,
    },
    {
        match  = { tag = "float_70_80" },
        float  = true,
        size   = "(monitor_w*0.7) (monitor_h*0.8)",
        center = true,
    },
    {
        match  = { tag = "float_50_60" },
        float  = true,
        size   = "(monitor_w*0.5) (monitor_h*0.6)",
        center = true,
    },

    -- Xwayland empty-title/class popups (menus, tooltips) — don't dim/shadow/blur
    { match = { xwayland = true, title = "win[0-9]+" }, tag = "+xwl_popup" },
    {
        match = { xwayland = true, title = "", class = "", initial_title = "", initial_class = "" },
        tag   = "+xwl_popup",
    },
    {
        match     = { tag = "xwl_popup" },
        no_dim    = true,
        no_shadow = true,
        no_blur   = true,
        opaque    = true,
        rounding  = 10,
    },

    -- Communication -> special workspace (element-desktop is your matrix client)
    { match = { class = "dev.geopjr.Tuba|Element" }, workspace = "special:communication" },
}

boot.apply_all(hl.window_rule, window_rules, "rules.window")

-------------------------
---- Workspace rules ----
-------------------------

local workspace_rules = {
    -- Smart gaps: no gaps when a workspace/monitor has exactly one window
    { workspace = "w[tv1]s[false]", gaps_out = vars.singleWindowGapsOut },
    { workspace = "f[1]s[false]",   gaps_out = vars.singleWindowGapsOut },
    -- special:communication uses scrolling layout with full-width columns —
    -- each app takes the entire monitor width; scrolling horizontally between
    -- them behaves like paging through full-screen apps rather than tiling
    -- side-by-side.
    {
        workspace = "special:communication",
        layout    = "scrolling",
        layout_opts = {
            column_width      = 1.0, -- 1.0 = full monitor width per column
            focus_fit_method  = 1,   -- 1 = fit (scroll the focused column fully into view, not just centered)
            follow_focus      = true,
        },
    },
}

boot.apply_all(hl.workspace_rule, workspace_rules, "rules.workspace")

---------------------
---- Layer rules ----
---------------------

local layer_rules = {
    { match = { namespace = "hyprpicker" },     animation = "fade" },
    { match = { namespace = "logout_dialog" },  animation = "fade" },
    { match = { namespace = "selection" },      animation = "fade" }, -- slurp
    { match = { namespace = "wayfreeze" },      animation = "fade" },
    { match = { namespace = "launcher" },       animation = "popin 80%", blur = true }, -- fuzzel/wofi

    -- caelestia shell surfaces
    { match = { namespace = "caelestia-(border-exclusion|area-picker)" }, no_anim = true },
    { match = { namespace = "caelestia-(drawers|background)" }, animation = "fade" },
}

boot.apply_all(hl.layer_rule, layer_rules, "rules.layer")
