--------------------------------
-- GGLucas' Awesome-3 Lua Config
-- Version 3
--------------------------------
-- Use with awesome-git/next
--------------------------------
-- Awful: Standard awesome library
require("awful")

-- Wicked: Dynamic widget library
require("wicked")

-- Naughty: Notification library
require("naughty")

-- MagnifConfig: Easy automation of awesome configuration
-- Note: Unreleased, bug me on IRC to remind me to work on releasing it
require("magnifconfig")

-- {{{ Config Settings
settings = {
    -- Used applications
    apps = {
        -- Terminal to use
        terminal = "urxvtc",

        -- Open a terminal with screen
        screen = "urxvtc -e screen -x main",

        -- Toggle mpd music
        togglempd = "mpdtoggle toggle",

        -- Open filemanager
        vifm = "urxvtc -e vifm /data",
    },

    -- Behaviour settings
    behaviour = {
        -- Warp the mouse cursor to the focussed window
        warp_cursor = true,

        -- Add new windows to the stack instead of as master
        new_become_master = false,

        -- Don't honor size hints
        size_hints_honor = false,

        -- Applications to put as floating
        floatapps = {
            ["gimp"] = true,
        },
    },

    -- Tagging settings
    tagging = {
        -- Use dynamic tagging like wmii/eminent
        --dynamic = true,

        -- Tags to use
        tags = {"www", "irc", "vim"},

        -- Default master width factor
        default_mwfact = 0.618033988769,

        -- Default layout
        default_layout = awful.layout.suit.tile,
    },

    -- Beautiful colors
    beautiful = {
        -- Background
        bg_normal = "#22222222",
        bg_focus = "#285577",
        bg_sbfocus = '#11335565',
        bg_urgent = '#A10000',

        -- Foreground
        fg_normal = '#999999',
        fg_focus = '#ffffff',
        fg_urgent = '#ffffff',

        -- Border
        border_width = 2,
        border_normal = '#333333',
        border_focus = '#4C7899',
        border_marked = '#91231c',

        -- Font
        font = "Terminus 10",
    },
}

-- Run settings through MagnifConfig
magnifconfig.setup(settings)
-- }}}

-- {{{ Keybindings
-- Note: Mine are dvorak, might not be comfortable in qwerty
-- Global keybindings
rootbindings = {
    -- Open terminal
    [{"Mod1", ";"}] = {awful.util.spawn, settings.apps.terminal},

    -- Open terminal with screen
    [{"Mod4", "b"}] = {awful.util.spawn, settings.apps.screen},

    -- Toggle music
    [{"Mod1", "."}] = {awful.util.spawn, settings.apps.togglempd},

    -- Open spawn prompt
    [{"Mod1", ","}] = {magnifconfig.prompt, "Run: ", awful.util.spawn},

    -- Open vifm
    [{"Mod1", "e"}] = {awful.util.spawn, settings.apps.vifm},

    -- Show CPU/MEM/etc statistics
    [{"Mod1", "u"}] = {awful.util.spawn, "stump-stats"},

    -- Show MPD currently playing song
    [{"Mod1", "p"}] = {awful.util.spawn, "stump-mpc"},

    -- Screen focus
    [{"Mod4", "l"}] = {awful.screen.focus, 1},
    [{"Mod4", "h"}] = {awful.screen.focus, -1},

    -- Tag selection
    [{"Mod4", "w"}] = awful.tag.viewnext,
    [{"Mod4", "v"}] = awful.tag.viewprev,

    -- Window focus
    [{"Mod4", "t"}] = {awful.client.focus.byidx, 1},
    [{"Mod4", "n"}] = {awful.client.focus.byidx, -1},

    -- Switch between layouts
    [{"Mod1", "'"}] = {awful.layout.set, awful.layout.suit.max},
    [{"Mod1", "q"}] = {awful.layout.set, awful.layout.suit.tile},

    -- Restart awesome
    [{"Mod1", "Mod4", "r"}] = awful.util.restart,
}

-- Mouse clicks on wallpaper
rootmousebindings = {
    -- Open terminal
    [{3}] = {awful.util.spawn, settings.apps.terminal},
}

-- Keybindings with a client
clientbindings = {
    -- Toggle fullscreen
    [{"Mod4", "f"}] = {"+fullscreen"},

    -- Close window
    [{"Mod1", "$"}] = {":kill"},

    -- Window swapping
    [{"Mod4", "Shift", "t"}] = {awful.client.swap.byidx, 1},
    [{"Mod4", "Shift", "n"}] = {awful.client.swap.byidx, -1},

    -- Toggle floating
    [{"Mod4", "c"}] = awful.client.floating.toggle,

    -- Move to tag
    [{"Mod4", "Shift", "w"}] = magnifconfig.util.client.movetonexttag,
    [{"Mod4", "Shift", "v"}] = magnifconfig.util.client.movetoprevtag,
}

-- Mouse clicks on a client
clientmousebindings = {
    -- Move client
    [{"Mod1", 1}] = awful.mouse.client.move,

    -- Resize client
    [{"Mod1", 3}] = awful.mouse.client.resize,
}

-- Run keybinds through MagnifConfig
-- Keys
magnifconfig.keys(rootbindings, clientbindings)

-- Buttons
magnifconfig.buttons(rootmousebindings, clientmousebindings)
-- }}}

-- {{{ Naughty settings
-- No padding
naughty.config.padding = 0

-- No spacing
naughty.config.spacing = -1

-- Lower timeout
naughty.config.presets.low.timeout = 3
naughty.config.presets.normal.timeout = 3
naughty.config.presets.critical.timeout = 60

-- Wider notifications
naughty.config.presets.normal.width = 500

-- White text
naughty.config.presets.low.fg = "#ffffff"
naughty.config.presets.normal.fg = "#ffffff"
naughty.config.presets.critical.fg = "#ffffff"
-- }}}

-- {{{ Mail notifier box
-- Create wibox
mailnotify = wibox({
    position = "floating",
    fg = beautiful.fg_urgent,
    bg = beautiful.bg_urgent,
    border_width = 1,
    border_color = "#ffffff",
})

-- Set geometry
mailnotify:geometry({ x = 0, y = 0, height = 20, width = 220 })
mailnotify.ontop = true

-- Create textbox
mailnotify_text = widget({ type = "textbox" })

-- Add textbox to wibox
mailnotify.widgets = {mailnotify_text}

-- Add hook to check mail
awful.hooks.timer.register(3, function()
    local file = io.open('/tmp/mail-temp')
    local number = file:read()
    file:close()

    if number ~= "0" then
        mailnotify_text.text = "-*- Unread Mail: -["..number.."]- -*-"
        mailnotify.screen = client.focus.screen
    else
        mailnotify.screen = nil
    end
end)

-- }}}

-- vim: set ft=lua fdm=marker:
