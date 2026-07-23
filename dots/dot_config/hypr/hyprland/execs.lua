-- ~/.config/hypr/hyprland/execs.lua
local vars = require("variables")
local fn   = require("hyprland.functions")
local boot = require("core.bootstrap")

hl.on("hyprland.start", function()

    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Auto-delete trash 30 days old (trash-cli)
    hl.exec_cmd("trash-empty 30")

    -- Cursors
    hl.exec_cmd("hyprctl setcursor " .. vars.cursorTheme .. " " .. vars.cursorSize)
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme " .. vars.cursorTheme)
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size " .. vars.cursorSize)

    -- Night light: hyprsunset is installed (Hyprland's own daemon) —
    -- replaces gammastep, which isn't in your package list.
    hl.exec_cmd("/usr/lib/geoclue-2.0/demos/agent")

    hl.exec_cmd("hyprsunset")

    -- Forward bluetooth media commands to MPRIS (ships with bluez)
    hl.exec_cmd("mpris-proxy")

    -- kdeconnect-indicator
    hl.exec_cmd("kdeconnect-indicator")

    -- Start shell if enabled
    if vars.enable_caelestia then
        hl.exec_cmd("caelestia shell -d")
    end
    -- without caelestia, you have no notification daemon running.
end)

-- Shared handler for both window.open and window.title (was duplicated
-- logic in the old config; collapsed to one function per our earlier fix).
local function handle_window(win)
    local d = {
        hl.dsp.window.float({ action = "on", window = fn.addr(win) }),
        hl.dsp.window.center({ window = fn.addr(win) }),
    }
    local pip = fn.move_actions(win) or {}

    fn.resizer(win, "Bitwarden", 20, 54, d, true)
    fn.resizer(win, "Picture[- ]in[- ][Pp]icture", 0, 0, pip, false)
end

hl.on("window.open", boot.safe_call(handle_window, "window.open"))
hl.on("window.title", boot.safe_call(handle_window, "window.title"))
