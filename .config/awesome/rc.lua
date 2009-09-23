--------------------------------
-- GGLucas' Awesome-3 Lua Config
-- Version 3
--------------------------------
-- Awful: Standard awesome library
require("awful")

-- Naughty: Notification library
require("naughty")

-- Rodentbane: Utilities for controlling the cursor
require("rodentbane")

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
        -- * Local
        screen = "urxvtc -e screen -x main -p 4",
        -- * Server
        screen_server = "urxvtc -e ssh -t root@tuple-typed.org screen -x main -p 0",

        -- Open filemanager
        filemanager = "urxvtc -e vifm /data /data",

        -- MPD Control
        -- * Toggle music
        mpd_toggle = "mpc_toggle",
        -- * Show currently playing
        mpd_show = "mpc_show",
    },

    -- Behaviour settings
    behaviour = {
        -- Add new windows to the stack instead of as master
        new_become_master = false,

        -- Don't honor size hints
        size_hints_honor = false,

        -- Sloppy focus
        sloppyfocus = true,

        -- Warp cursor
        warp_cursor = false,

        -- Applications to put as floating
        floatapps = {
            ["gimp"] = true,
        },
    },

    -- Tagging settings
    tagging = {
        -- Tags to use
        tags = {"1", "2", "3", "4", "5", "6"},

        -- Default master width factor
        default_mwfact = 0.5,

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
        border_width = 1,
        border_normal = '#000000',
        border_focus = '#aaaaaa',
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
    [{"Mod4", ";"}] = {awful.util.spawn, settings.apps.terminal},

    -- Drop-down urxvtc terminal
    [{"Mod4", "a"}] = {magnifconfig.util.dropdown, settings.apps.terminal},

    -- Open terminal with screen
    -- * Local
    [{"Mod4", "b"}] = {awful.util.spawn, settings.apps.screen},
    -- * Server
    [{"Mod4", "Shift", "b"}] = {awful.util.spawn, settings.apps.screen_server},

    -- Toggle music
    [{"Mod4", "."}] = {awful.util.spawn, settings.apps.mpd_toggle},

    -- Open spawn prompt
    [{"Mod4", ","}] = {magnifconfig.prompt, "Run: ", awful.util.spawn},

    -- Open file manager
    [{"Mod4", "e"}] = {awful.util.spawn, settings.apps.filemanager},

    -- Show MPD currently playing song
    [{"Mod4", "p"}] = {awful.util.spawn_with_shell, settings.apps.mpd_show},

    -- Start rodentbane cursor navigation
    [{"Mod4", "r"}] = rodentbane.start,

    -- Start rodentbane cursor navigation in recall mode
    [{"Mod4", "Shift", "r"}] = {rodentbane.start, mouse.screen, true},

    -- Warp pointer to top left of the screen
    [{"Mod4", "Mod1", "$"}] = {mouse.coords, {x = 0, y = 0}},

    -- Tag selection
    [{"Mod4", "w"}] = awful.tag.viewnext,
    [{"Mod4", "v"}] = awful.tag.viewprev,

    -- Window focus
    [{"Mod4", "t"}] = {awful.client.focus.byidx, 1},
    [{"Mod4", "n"}] = {awful.client.focus.byidx, -1},

    -- Switch between layouts
    [{"Mod4", "'"}] = {awful.layout.set, awful.layout.suit.max},
    [{"Mod4", "q"}] = {awful.layout.set, awful.layout.suit.tile},
    [{"Mod4", "j"}] = {awful.layout.set, awful.layout.suit.tile.bottom},

    -- Switch between mwfact modes
    [{"Mod4", "Shift", "'"}] = {awful.tag.setmwfact, 0.5},
    [{"Mod4", "Shift", "q"}] = {awful.tag.setmwfact, 0.618033988769},

    -- Increase or decrease the number of master windows
    [{"Mod4", "Mod1", "'"}] = {awful.tag.incnmaster, -1},
    [{"Mod4", "Mod1", "q"}] = {awful.tag.incnmaster, 1},

    -- Screen focus
    [{"Mod4", "h"}] = function ()
        local screen = mouse.screen

        if screen == 1 then
            screen = 4
        elseif screen == 5 then
            screen = 6
        elseif screen == 6 then
            screen = 5
        else
            screen = screen - 1
        end
            
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
        mouse.screen = screen
    end,

    [{"Mod4", "l"}] = function ()
        local screen = mouse.screen

        if screen == 4 then
            screen = 1
        elseif screen == 5 then
            screen = 6
        elseif screen == 6 then
            screen = 5
        else
            screen = screen + 1
        end
            
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
        mouse.screen = screen
    end,

    [{"Mod4", "g"}] = function ()
        local screen = mouse.screen

        if screen == 5 then
            screen = 1
        elseif screen == 6 then
            screen = 2
        elseif screen == 1 or screen == 4 then
            screen = 5
        elseif screen == 2 or screen == 3 then
            screen = 6
        end

        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
        mouse.screen = screen
    end,

    -- Toggle between low and high mpd volumes
    [{"Mod4", "F11"}] = function ()
        if settings._mpd_volume == nil then
            settings._mpd_volume = 74
        end

        if settings._mpd_volume == 74 then
            awful.util.spawn_with_shell("mpc volume 30")
            settings._mpd_volume = 30
        elseif settings._mpd_volume == 30 then
            awful.util.spawn_with_shell("mpc volume 74")
            settings._mpd_volume = 74
        end
    end,

    -- Toggle between numbers and special characters by default on number row
    [{"Mod4", "F12"}] = function ()
        if settings._numbers then
            settings._numbers = false
            awful.util.spawn_with_shell("xmodmap ~/.Xmodmap-nonumbers")
        else 
            settings._numbers = true
            awful.util.spawn_with_shell("xmodmap ~/.Xmodmap-numbers")
        end
    end,

    -- Restart awesome
    [{"Mod4", "Mod1", "r"}] = awful.util.restart,
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
    [{"Mod4", "$"}] = {":kill"},

    -- Redraw client
    [{"Mod4", "/"}] = {":redraw"},

    -- Window swapping
    [{"Mod4", "Shift", "t"}] = {awful.client.swap.byidx, 1},
    [{"Mod4", "Shift", "n"}] = {awful.client.swap.byidx, -1},

    -- Toggle floating
    [{"Mod4", "c"}] = awful.client.floating.toggle,

    -- Move to tag
    [{"Mod4", "Shift", "w"}] = magnifconfig.util.client.movetonexttag,
    [{"Mod4", "Shift", "v"}] = magnifconfig.util.client.movetoprevtag,

    -- Left screenjoin
    [{"Mod4", "+"}] = function ()
        awful.client.floating.set(client.focus, true)

        client.focus:geometry({
            x = 0,
            y = 0,
            width = 3360,
            height = 1050
        })
    end,

    -- Right screenjoin
    [{"Mod4", "]"}] = function ()
        awful.client.floating.set(client.focus, true)

        client.focus:geometry({
            x = -1680,
            y = 0,
            width = 3360,
            height = 1050
        })
    end,
}

-- Mouse clicks on a client
clientmousebindings = {
    -- Move client
    [{"Mod4", 1}] = awful.mouse.client.move,

    -- Resize client
    [{"Mod4", 3}] = awful.mouse.client.resize,
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
naughty.config.presets.normal.timeout = 3

-- Wider notifications
naughty.config.presets.normal.width = 500

-- Colours
naughty.config.presets.normal.bg = "#444444"
naughty.config.presets.normal.fg = "#ffffff"

-- Regular font
naughty.config.presets.normal.font = "Terminus 10"

-- Tell naughty about the currently focussed screen
awful.hooks.focus.register(function (c)
    naughty.config.presets.normal.screen = c.screen
end)

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

    if file then
        local number = file:read()
        file:close()

        if number ~= "0" then
            mailnotify_text.text = "-*- Unread Mail: -["..number.."]- -*-"
            mailnotify.screen = client.focus.screen
            return
        end
    end

    mailnotify.screen = nil
end)

-- }}}

-- vim: set ft=lua fdm=marker:
