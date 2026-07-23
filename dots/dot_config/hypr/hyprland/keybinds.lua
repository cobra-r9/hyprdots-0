-- ~/.config/hypr/hyprland/keybinds.lua
local vars = require("variables")
local fn   = require("hyprland.functions")
local boot = require("core.bootstrap")

-- Launcher
hl.bind("SUPER + SUPER_L", hl.dsp.global("caelestia:launcher"), { release = true })

-- Misc (caelestia shell panels)
hl.bind(vars.kbSession, hl.dsp.global("caelestia:session"))
hl.bind(vars.kbShowSidebar, hl.dsp.global("caelestia:sidebar"))
hl.bind(vars.kbClearNotifs, hl.dsp.global("caelestia:clearNotifs"), { locked = true })
hl.bind(vars.kbShowPanels, hl.dsp.global("caelestia:showall"))
hl.bind(vars.kbLock, hl.dsp.global("caelestia:lock"))

hl.bind(vars.kbRestoreLock, boot.safe_call(function()
    hl.dispatch(hl.dsp.exec_cmd("caelestia shell -d"))
    hl.dispatch(hl.dsp.global("caelestia:lock"))
end, "kbRestoreLock"))

-- Brightness (brightnessctl installed)
hl.bind("XF86MonBrightnessUp", hl.dsp.global("caelestia:brightnessUp"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), { locked = true })
hl.bind("SUPER + XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -d platform::kbd_backlight set +1"))
hl.bind("SUPER + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -d platform::kbd_backlight set 1-"))

-- Media (playerctl + mpd/rmpc installed — caelestia panel handles the rest)
hl.bind("CTRL + SUPER + Space", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("CTRL + SUPER + Equal", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind("CTRL + SUPER + Minus", hl.dsp.global("caelestia:mediaPrev"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.global("caelestia:mediaPrev"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.global("caelestia:mediaStop"), { locked = true })

-- Kill/restart shell (quickshell-git provides `qs`)
hl.bind(vars.kbKillCaelestia, hl.dsp.exec_cmd("qs -c caelestia kill"), { release = true })
hl.bind(
    vars.kbRestartCaelestia,
    hl.dsp.exec_cmd("qs -c caelestia kill; sleep .1; caelestia shell -d"),
    { release = true }
)

-- Workspaces 1-10 / groups
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(vars.kbGoToWs .. " + " .. key, fn.wsaction("focus", "", i))
    hl.bind(vars.kbMoveWinToWs .. " + " .. key, fn.wsaction("move", "", i))
    hl.bind(vars.kbGoToWsGroup .. " + " .. key, fn.wsaction("focus", "group", i))
    hl.bind(vars.kbMoveWinToWsGroup .. " + " .. key, fn.wsaction("move", "group", i))
end

-- Workspace -1/+1
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "+1" }))
hl.bind(vars.kbPrevWs, hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind(vars.kbNextWs, hl.dsp.focus({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + Page_down", hl.dsp.focus({ workspace = "+1" }), { repeating = true })

-- Workspace group -1/+1
hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "-10" }))
hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "+10" }))

-- Move window to workspace -1/+1
hl.bind("SUPER + ALT + Page_Up", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + ALT + Page_Down", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("CTRL + SUPER + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("CTRL + SUPER + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })

-- Move to/from special workspace
hl.bind("CTRL + SUPER + up", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + down", hl.dsp.window.move({ workspace = "e+0" }))

-- Window groups
hl.bind(vars.kbWindowGroupCycleNext, hl.dsp.window.cycle_next(), { repeating = true })
hl.bind(vars.kbWindowGroupCyclePrev, hl.dsp.window.cycle_next({ next = false }), { repeating = true })
hl.bind("CTRL + ALT + Tab", hl.dsp.group.next(), { repeating = true })
hl.bind("CTRL + SHIFT + ALT + Tab", hl.dsp.group.prev(), { repeating = true })
hl.bind(vars.kbToggleGroup, hl.dsp.group.toggle())
hl.bind(vars.kbUngroup, hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + SHIFT + Comma", hl.dsp.group.lock_active())

-- Focus / move by direction
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

------------------------------------------------------------------
-- Window resize — FIXED: wrapped in functions so the active-window/
-- active-monitor lookup happens at keypress time, not config-load time.
------------------------------------------------------------------
hl.bind("SUPER + Minus", function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_active_window(-10, 0)))
end, { repeating = true })
hl.bind("SUPER + Equal", function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_active_window(10, 0)))
end, { repeating = true })
hl.bind("SUPER + SHIFT + Minus", function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_active_window(0, -10)))
end, { repeating = true })
hl.bind("SUPER + SHIFT + Equal", function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_active_window(0, 10)))
end, { repeating = true })
hl.bind("SUPER + ALT + left", function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_active_window(-10, 0)))
end, { repeating = true })
hl.bind("SUPER + ALT + right", function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_active_window(10, 0)))
end, { repeating = true })
hl.bind("SUPER + ALT + up", function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_active_window(0, -10)))
end, { repeating = true })
hl.bind("SUPER + ALT + down", function()
    hl.dispatch(hl.dsp.window.resize(fn.resize_active_window(0, 10)))
end, { repeating = true })

-- Move/resize with mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Other window functions
hl.bind("CTRL + SUPER + Backslash", hl.dsp.window.center())
hl.bind("CTRL + SUPER + ALT + Backslash", function() -- FIXED, same bug as above
    hl.dispatch(hl.dsp.window.resize(fn.resize_by_screen(55, 70)))
end)

hl.bind(vars.kbWindowPip, boot.safe_call(function()
    local a = hl.get_active_window()
    if a then
        local pip = fn.move_actions(a) or {}
        if not a.floating then table.insert(pip, 1, hl.dsp.window.float()) end
        table.insert(pip, hl.dsp.window.pin({ action = "on", window = fn.addr(a) }))

        for _, x in ipairs(pip) do
            hl.dispatch(x)
        end
    end
end, "kbWindowPip"))

hl.bind(vars.kbPinWindow, hl.dsp.window.pin())
hl.bind(vars.kbWindowPseudo, hl.dsp.window.pseudo())
hl.bind(vars.kbWindowFullscreen, hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(vars.kbWindowBorderedFullscreen, hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind(vars.kbToggleWindowFloating, boot.safe_call(function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    local w = hl.get_active_window()
    if w and w.floating then
        local class = w.class and w.class:lower() or ""
        local rule = vars.floatRules[class] or vars.defaultRule

        hl.dispatch(hl.dsp.window.resize({ exact = true, x = rule.w, y = rule.h }))

        if rule.x and rule.y then
            hl.dispatch(hl.dsp.window.move({ exact = true, x = rule.x, y = rule.y }))
        else
            hl.dispatch(hl.dsp.window.center())
        end
    end
end, "kbToggleWindowFloating"))

hl.bind(vars.kbCloseWindow, hl.dsp.window.close())

-- Special workspace toggles (caelestia)
hl.bind(vars.kbSpecialWs, hl.dsp.exec_cmd("caelestia toggle specialws"))
hl.bind(vars.kbSystemMonitorWs, hl.dsp.exec_cmd("caelestia toggle sysmon"))
hl.bind(vars.kbMusicWs, hl.dsp.exec_cmd("caelestia toggle music"))
hl.bind(vars.kbCommunicationWs, hl.dsp.exec_cmd("caelestia toggle communication"))
hl.bind(vars.kbTodoWs, hl.dsp.exec_cmd("caelestia toggle todo"))

-- Layout toggles: all -> next
hl.bind(vars.kbToggleWsLayout, boot.safe_call(function()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local order = { dwindle = "scrolling", scrolling = "master", master = "monocle", monocle = "dwindle" }
    hl.workspace_rule({ workspace = tostring(ws.id), layout = order[ws.tiled_layout] or "dwindle" })
end, "kbToggleWsLayout"))

-- dwindle <-> scrolling only
hl.bind(vars.kbToggleWsScrollLayout, boot.safe_call(function()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local order = { dwindle = "scrolling", scrolling = "dwindle" }
    hl.workspace_rule({ workspace = tostring(ws.id), layout = order[ws.tiled_layout] or "dwindle" })
end, "kbToggleWsScrollLayout"))

-- Open apps (tiled)
hl.bind(vars.kbTerminal, hl.dsp.exec_cmd(vars.terminal))
hl.bind(vars.kbBrowser, hl.dsp.exec_cmd(vars.browser))
hl.bind(vars.kbEditor, hl.dsp.exec_cmd(vars.editor))
hl.bind(vars.kbFileExplorer, hl.dsp.exec_cmd(vars.fileExplorer))
hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd(vars.audioSettings))

-- Open apps (float, sized via variables.floatRules)
hl.bind("SHIFT + " .. vars.kbTerminal, hl.dsp.exec_cmd(vars.terminal, fn.floatSpawnRule(vars.terminal, { float = true })))
hl.bind("SHIFT + " .. vars.kbBrowser, hl.dsp.exec_cmd(vars.browser, fn.floatSpawnRule(vars.browser, { float = true })))
hl.bind("SHIFT + " .. vars.kbEditor, hl.dsp.exec_cmd(vars.editor, fn.floatSpawnRule(vars.editor, { float = true })))
hl.bind("SHIFT + " .. vars.kbFileExplorer, hl.dsp.exec_cmd(vars.fileExplorer, fn.floatSpawnRule(vars.fileExplorer, { float = true })))
hl.bind("CTRL + " .. vars.kbTerminal, hl.dsp.exec_cmd(vars.terminal, fn.floatSpawnRule(vars.terminal, { pseudo = true })))

-- Screenshots (caelestia wraps grim/slurp/swappy, all installed)
hl.bind("Print", hl.dsp.exec_cmd("caelestia screenshot"), { locked = true })
hl.bind("SUPER + SHIFT + S", hl.dsp.global("caelestia:screenshotFreeze"))
hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.global("caelestia:screenshot"))

-- Screen recording (gpu-screen-recorder installed; caelestia wraps it)
hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd("caelestia record -s"))
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("caelestia record"))
hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("caelestia record -r"))

-- Color picker (hyprpicker installed)
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Volume (wireplumber's wpctl)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l " ..
        (vars.volumeMax / 100) .. " @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%+"
    ),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%-"
    ),
    { locked = true, repeating = true }
)

-- Sleep
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd(vars.sleepGestureCmd), { locked = true })

-- Clipboard / emoji (cliphist + ydotool installed; fuzzel as picker frontend)
hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard"))
hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"))
hl.bind(
    "CTRL + SHIFT + ALT + V",
    hl.dsp.exec_cmd('sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"'),
    { locked = true }
)
