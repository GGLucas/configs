--------------------------------
-- GGLucas' Awesome-3 Lua Config
-- Version 3
--------------------------------
-- Awful: Standard awesome library
require("awful")
require("awful.rules")
require("awful.autofocus")

-- Beautiful: Theming capabilities
require("beautiful")

-- Teardrop: Dropdown terminal
require("teardrop")

-- Naughty: Notification library
require("naughty")

-- Rodentbane: Utilities for controlling the cursor
require("rodentbane")

-- {{{ Configuration
-- Beautiful colors
beautiful.init(os.getenv("HOME").."/.config/awesome/theme.lua")

-- Applications
apps = {
    -- Terminal to use
    terminal = "urxvtc",
    terminal_full = "/usr/bin/urxvtc",

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
}
-- }}}

-- {{{ Utility functions
dropdown = {}
settings = {}
util = {
    tag = {
        getidx = function (i, sc)
            local tags = screen[sc or mouse.screen]:tags()
            local sel = awful.tag.selected(sc)
            for k, t in ipairs(tags) do
                if t == sel then
                    return tags[awful.util.cycle(#tags, k + i)]
                end
            end
        end,
    },

    client = {
        movetonexttag = function (c)
            awful.client.movetotag(util.tag.getidx(1), c)
        end,

        movetoprevtag = function (c)
            awful.client.movetotag(util.tag.getidx(-1), c)
        end,

        warp = function (c)
            -- Warp mouse
            local sel = c or client.focus

            if sel then
                local coords = sel:geometry()
                local m = mouse.coords()

                -- Settings
                mouse_padd = 6
                border_area = 10

                -- Check if mouse is not already inside the window
                if  (( m.x < coords.x-border_area or
                       m.y < coords.y-border_area or
                       m.x > coords.x+coords.width+border_area or
                       m.y > coords.y+coords.height+border_area
                    )
                    or force or (m.x == 0 and m.y == 0))
                then
                    if not force then
                        for k,v in pairs(m.buttons) do
                            if v then
                                return
                            end
                        end
                    end

                    coords = { x=coords.x+coords.width-mouse_padd, y=coords.y+coords.height-mouse_padd}

                    if coords.x > screen[c.screen].workarea.width then
                        coords.x = screen[c.screen].workarea.width-mouse_padd
                    end
                    if coords.y > screen[c.screen].workarea.height then
                        coords.y = screen[c.screen].workarea.height-mouse_padd
                    end

                    mouse.coords(coords)
                end
            end
        end,
    },

    banish = function (c, padd)
        if padd == nil then padd = 6 end
        local client = c or client.focus
        local coords = client:geometry()

        mouse.coords({ x=coords.x+coords.width-padd, y=coords.y+coords.height-padd})
    end,

    prompt = function(text, callback, width, height, margin)
        -- Get current screen
        local sc = mouse.screen

        -- Create wibox
        local promptbox = wibox({
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            border_width = beautiful.border_width,
            border_color = beautiful.border_focus,
        })

        -- Create textbox to type in
        local textbox = widget({
            type = "textbox",
        })

        -- Set margin
        margin = margin or 4

        -- Default geometry
        promptgeom = {
            width = width or 400+margin*2,
            height = height or 20+margin*2,
            x = screen[sc].workarea.width-(width or (400+margin*2)),
            y = 0,
        }

        awful.widget.layout.margins[textbox] = {
            right = margin, left = margin, 
        }

        -- Show promptbox
        promptbox.ontop = true
        promptbox.widgets = {textbox,
        layout = awful.widget.layout.horizontal.leftright}
        promptbox:geometry(promptgeom)
        promptbox.screen = sc

        -- Run prompt
        awful.prompt.run({
            prompt = text,
        }, textbox, callback,
        awful.completion.bash,
        awful.util.getdir("cache").."/history",
        50,
        function ()
            promptbox.screen = nil
        end)
    end,
}
-- }}}

-- {{{ Tags
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6 }, s, awful.layout.suit.tile)
end

-- }}}

-- {{{ Keybindings
-- Global keybindings
bindings = {
    root = {
        -- Open terminal
        [{"Mod4", ";"}] = {awful.util.spawn, apps.terminal},

        -- Drop-down urxvtc terminal
        [{"Mod4", "a"}] = {teardrop.toggle, apps.terminal},
        
        -- Pull-left urxvtc terminal
        [{"Mod4", "Shift", "a"}] = {teardrop.toggle, apps.terminal_full, "top", "right", 0.5, 1},

        -- Open terminal with screen
        -- * Local
        [{"Mod4", "b"}] = {awful.util.spawn, apps.screen},
        -- * Server
        [{"Mod4", "Shift", "b"}] = {awful.util.spawn, apps.screen_server},

        -- Toggle music
        [{"Mod4", "."}] = {awful.util.spawn, apps.mpd_toggle},

        -- Open spawn prompt
        [{"Mod4", ","}] = {util.prompt, "Run: ", awful.util.spawn},

        -- Open file manager
        [{"Mod4", "e"}] = {awful.util.spawn, apps.filemanager},

        -- Show MPD currently playing song
        [{"Mod4", "p"}] = {awful.util.spawn_with_shell, apps.mpd_show},

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
        [{"Mod4", "t"}] = function () awful.client.focus.byidx(1) 
                              if client.focus then client.focus:raise() end
                          end,

        [{"Mod4", "n"}] = function () awful.client.focus.byidx(-1) 
                              if client.focus then client.focus:raise() end
                          end,

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

            if screen.count() == 2 then
                screen = 1+(screen%2)
            else
                if screen == 1 then
                    screen = 4
                elseif screen == 5 then
                    screen = 6
                elseif screen == 6 then
                    screen = 5
                else
                    screen = screen - 1
                end
            end

            mouse.screen = screen

            local c = awful.client.focus.history.get(screen, 0)
            if c then
                mouse.coords({ x = c:geometry().x+6,
                               y = c:geometry().y+4
                            })
                client.focus = c
            end
        end,

        [{"Mod4", "l"}] = function ()
            local screen = mouse.screen

            if screen.count() == 2 then
                screen = 1+(screen%2)
            else
                if screen == 4 then
                    screen = 1
                elseif screen == 5 then
                    screen = 6
                elseif screen == 6 then
                    screen = 5
                else
                    screen = screen + 1
                end
            end
                
            mouse.screen = screen

            local c = awful.client.focus.history.get(screen, 0)
            if c then
                mouse.coords({ x = c:geometry().x+6,
                               y = c:geometry().y+4
                            })
                client.focus = c
            end
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

            mouse.screen = screen

            local c = awful.client.focus.history.get(screen, 0)
            if c then
                mouse.coords({ x = c:geometry().x+6,
                               y = c:geometry().y+4
                            })
                client.focus = c
            end
        end,

        -- Toggle Line In mute
        [{"Mod4", "F10"}] = function () 
            awful.util.spawn("amixer set Line toggle")
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
    },

    -- Keybindings with a client
    client = {
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
        [{"Mod4", "Shift", "w"}] = util.client.movetonexttag,
        [{"Mod4", "Shift", "v"}] = util.client.movetoprevtag,

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

        -- Left screenjoin bottom
        [{"Mod4", "Shift", "+"}] = function ()
            awful.client.floating.set(client.focus, true)

            client.focus:geometry({
                x = 0,
                y = -240,
                width = 3360,
                height = 1050
            })
        end,

        -- Right screenjoin bottom
        [{"Mod4", "Shift", "]"}] = function ()
            awful.client.floating.set(client.focus, true)

            client.focus:geometry({
                x = -1680,
                y = -240,
                width = 3360,
                height = 1050
            })
        end,
    },

    root_buttons = awful.util.table.join(
        awful.button({}, 3, function () awful.util.spawn(apps.terminal) end)
    ),

    client_buttons = awful.util.table.join(
        awful.button({"Mod4",}, 1, awful.mouse.client.move),
        awful.button({"Mod4",}, 3, awful.mouse.client.resize)
    ), 
}

---- {{{ Set up keybindings - Code
    -- Root binding table
    local rbinds = {}

    -- Bind all root bindings
    for keys, func in pairs(bindings.root) do
        -- Get regular key
        local actkey = keys[#keys]
        table.remove(keys, #keys)

        -- Get function to call
        if type(func) == "table" then
            -- Get arguments and function from table
            local args = func
            local ofunc = args[1]

            table.remove(args, 1)

            -- Create new function
            func = function ()
                ofunc(unpack(args))
            end
        end

        -- Create binding
        local bind = awful.key(keys, actkey, func) 

        -- Insert into table
        table.insert(rbinds, bind)
    end

    -- Bind
    root.keys(awful.util.table.join(unpack(rbinds)))

    -- Client binding table
    local clientbinds = {}

    -- Bind all client bindings
    for keys, func in pairs(bindings.client) do
        -- Get regular key
        local actkey = keys[#keys]
        table.remove(keys, #keys)

        -- Get function to call
        if type(func) == "table" then
            -- Get arguments and function from table
            local args = func
            local ofunc = args[1]
            table.remove(args, 1)

            -- Create new function
            if type(ofunc) == "string" and ofunc:sub(1,1) == ":" then
                -- Insert placeholder for instance
                table.insert(args, 1, nil)

                -- Method calls
                func = function (c)
                    -- Insert instance into table
                    args[1] = c

                    -- Call
                    c[ofunc:sub(2)](unpack(args))
                end
            elseif type(ofunc) == "string" and ofunc:sub(1,1) == "+" then
                -- Toggle an attribute
                func = function (c)
                    c[ofunc:sub(2)] = not c[ofunc:sub(2)]
                end
            elseif type(ofunc) == "string" and ofunc:sub(1,1) == "." then
                -- Set an attribute
                func = function (c)
                    c[ofunc:sub(2)] = args[1]
                end
            else
                -- Regular function
                func = function (c)
                    ofunc(unpack(args))
                end
            end
        end

        -- Create binding
        local bind = awful.key(keys, actkey, func) 

        -- Insert into table
        table.insert(clientbinds, bind)
    end

    clientbinds = awful.util.table.join(unpack(clientbinds))
    
    -- Root buttons
    root.buttons(bindings.root_buttons)
---- }}}
-- }}}

-- {{{ Rules
awful.rules.rules = {
    {
        -- Default client attributes
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            buttons = bindings.client_buttons,
            size_hints_honor = false,
            focus = true,
            keys = clientbinds,
        },
    },

    {
        -- Float the GIMP
        rule = { class = "GIMP", },
        properties = { floating = true, },
    },
}
-- }}}

-- {{{ Naughty settings
-- No padding
naughty.config.padding = 0

-- No spacing
naughty.config.spacing = -1

-- Lower timeout
naughty.config.presets.normal.timeout = 3

-- Colours
naughty.config.presets.normal.bg = "#444444"
naughty.config.presets.normal.fg = "#ffffff"
naughty.config.presets.normal.border_color = "#ffffff"

-- Regular font
naughty.config.presets.normal.font = "Terminus 10"

-- }}}

-- {{{ Mail notifier box
-- Create wibox
mailnotify = wibox({
    fg = beautiful.fg_urgent,
    bg = beautiful.bg_urgent,
    border_width = 1,
    border_color = "#ffffff",
})

-- Set geometry
mailnotify:geometry({ x = 0, y = 0, height = 20, width = 220 })
mailnotify.ontop = true
mailnotify.screen = nil

-- Create textbox
mailnotify_text = widget({ type = "textbox" })

-- Add textbox to wibox
mailnotify.widgets = {mailnotify_text, 
    layout = awful.widget.layout.horizontal.leftright}

-- Add hook to check mail
checkmail = timer { timeout = 3 }
checkmail:add_signal("timeout", function()
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

checkmail:start()


-- }}}

-- {{{ Signals
-- Client manage
client.add_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

-- Client focus
client.add_signal("focus", function(c)
    -- Set border color
    c.border_color = beautiful.border_focus

    -- Set naughty screen
    naughty.config.presets.normal.screen = c.screen
end)

-- Client unfocus
client.add_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}

-- vim: set ft=lua fdm=marker:
