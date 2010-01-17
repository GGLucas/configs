--------------------------------
-- GGLucas' Awesome-3 Lua Config
-- Version 3
--------------------------------
-- Awful: Standard awesome library
require("awful")
require("awful.rules")
require("awful.autofocus")

-- Eminent: Effortless wmii-style dynamic tagging
require("eminent")

-- Beautiful: Theming capabilities
require("beautiful")

-- Teardrop: Dropdown terminal
require("teardrop")

-- Fadelist: Pop-up taglist
require("fadelist")

-- Naughty: Notification library
require("naughty")

-- Rodentbane: Utilities for controlling the cursor
require("rodentbane")

-- Quickmarks: Rapid client focus jumping by hotkey
require("quickmarks")

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
    tmux = "urxvtc -e tmux -2 attach-session -t dl",

    -- Open filemanager
    filemanager = "urxvtc -e vifm /data /data",

    -- Open htop
    htop = "urxvtc -e htop",

    -- Open webbrowser
    browser = "fx",

    -- Suspend activity
    system_suspend = "system_suspend",

    -- Turn off displays
    displays_off = "sleep 0.2 && xset dpms force off",

    -- Shutdown system
    shutdown = "sudo halt",

    -- MPD Control
    -- * Toggle music
    mpd_toggle = "mpc_toggle",
    -- * Show currently playing
    mpd_show = "mpc_show",

    -- Different tmux windows
    irc = "urxvtc -e tmux -2 attach-session -t irc",
    mail = "urxvtc -e tmux -2 attach-session -t mt",
    rtorrent = "urxvtc -e tmux -2 attach-session -t dl",
    newsbeuter = "urxvtc -e tmux -2 attach-session -t rss",
    ncmpcpp = "urxvtc -e tmux -2 attach-session -t mpd",
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

    -- Spawn with a wait at the end
    spawn_wait = function (app, wait)
        awful.util.spawn_with_shell(app)

        if wait then
            os.execute("sleep "..wait)
        end
    end,

    -- Spawn an application with scim enabled
    spawn_with_scim = function(app)
        awful.util.spawn_with_shell("XMODIFIERS='@im=SCIM' GTK_IM_MODULE=scim QT_IM_MODULE=scim "..app)
    end,

    -- Spawn on all screens
    spawn_all = function(app)
        for s=1, screen.count() do
            mouse.screen = s
            awful.util.spawn(app)
        end
    end,

    -- Spawn on bottom screens
    spawn_bottom = function(app)
        for s=1, 4 do
            mouse.screen = s
            awful.util.spawn(app)
        end
    end,

    -- Show fadelist only when enabled
    fadelist = function (...)
        if settings._popup_allowed 
        or settings._popup_allowed == nil then
            fadelist(...)
        end
    end,

    -- Send a list of commands to weechat
    weechat_send = function (commands)
        cmds = ""

        for i,cm in ipairs(commands) do
            cmds = cmds.."*"..cm.."\\n"
        end

        awful.util.spawn_with_shell("echo -e '"..cmds.."' > ~/.weechat/*fifo*")
    end,

    -- Focus a particular weechat window
    weechat_window = function(num)
        if num < 5 then
            -- Focus window
            if quickmarks.get("i") ~= client.focus then
                quickmarks.focus("i")
            end

            -- Go to an established position
            cmd = {"/window left", "/window left", "/window left", "/window left", "/window down"}

            -- Select window
            if num == 1 then
                table.insert(cmd, "/window up")
            elseif num == 2 then
                table.insert(cmd, "/window up")
                table.insert(cmd, "/window right")
            elseif num == 4 then
                table.insert(cmd, "/window right")
            end

            util.weechat_send(cmd)
        else
            -- Focus window
            if quickmarks.get("d") ~= client.focus then
                quickmarks.focus("d")
            end

            -- Go to an established position
            cmd = {"/window right", "/window right", "/window right", "/window right", "/window down"}

            -- Select window
            if num == 5 then
                table.insert(cmd, "/window up")
                table.insert(cmd, "/window left")
            elseif num == 6 then
                table.insert(cmd, "/window up")
            elseif num == 7 then
                table.insert(cmd, "/window left")
            end

            util.weechat_send(cmd)
        end
    end,

    -- Quickmarks in default desktop layout
    defquickmarks = function ()
        --- Set correct geometry on irc windows
        clients = awful.client.visible(5)
        awful.client.floating.set(clients[1], true)
        clients[1]:geometry({ x = 0, y = 0,
            width = 3360, height = 1050 })

        clients = awful.client.visible(6)
        awful.client.floating.set(clients[1], true)
        clients[1]:geometry({ x = -1680, y = 0,
            width = 3360, height = 1050 })

        -- Quickmarks
        -- 1: Firefox
        quickmarks.set(awful.client.visible(1)[1], "u")
        -- 2: Main terms
        quickmarks.set(awful.client.visible(2)[1], "h")
        quickmarks.set(awful.client.visible(2)[2], "w")
        quickmarks.set(awful.client.visible(2)[3], "v")
        -- 3: Monitors+mail
        quickmarks.set(awful.client.visible(3)[1], "t")
        quickmarks.set(awful.client.visible(3)[2], "n")
        quickmarks.set(awful.client.visible(3)[3], "s")
        -- 4: Torrent+rss+mpd
        quickmarks.set(awful.client.visible(4)[1], "a")
        quickmarks.set(awful.client.visible(4)[2], "o")
        quickmarks.set(awful.client.visible(4)[3], "e")
        -- 5/6: irc
        quickmarks.set(awful.client.visible(5)[1], "i")
        quickmarks.set(awful.client.visible(6)[1], "d")
    end
}
-- }}}

-- {{{ Tags
tags = {}
for s = 1, screen.count() do
    -- Figure out layout to use
    if s == 3 then
        layout = awful.layout.suit.tile.left
    else
        layout = awful.layout.suit.tile
    end

    -- Create tags
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8 }, s, layout)
end

-- }}}

-- {{{ Keybindings
-- Global keybindings
bindings = {
    root = {
        -- Open terminal
        [{"Mod4", ";"}] = {awful.util.spawn, apps.terminal},

        -- Open terminal with scim
        [{"Mod4", "Shift", ";"}] = {util.spawn_with_scim, apps.terminal},

        -- Open terminal on all screens
        [{"Mod4", "Mod1", ";"}] = {util.spawn_all, apps.terminal},

        -- Open terminal on bottom 4 screens
        [{"Mod4", "Mod1", "Shift", ";"}] = {util.spawn_bottom, apps.terminal},

        -- Drop-down urxvtc terminal
        [{"Mod4", "a"}] = {teardrop.toggle, apps.terminal},
        
        -- Pull-left urxvtc terminal
        [{"Mod4", "Shift", "a"}] = {teardrop.toggle, apps.terminal_full, "top", "right", 0.5, 1},

        -- Open terminal with screen
        -- * Local
        [{"Mod4", "b"}] = {awful.util.spawn, apps.tmux},
        -- * Local with scim
        [{"Mod4", "Shift", "b"}] = {util.spawn_with_scim, apps.tmux},

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

        -- Click somewhere in the top left of the screen
        [{"Mod4", "x"}] = function ()
                              mouse.coords({x = 10, y = 10})
                              awful.util.spawn_with_shell("sleep 0.2; xdotool click 1")
                          end,

        -- Tag selection
        [{"Mod4", "w"}] = awful.tag.viewnext,
        [{"Mod4", "v"}] = awful.tag.viewprev,

        ---- Tag selection on all monitors
        [{"Mod4", "Mod1", "w"}] = function () for s=1, screen.count() do
                                              awful.tag.viewnext(screen[s]) end end,
        [{"Mod4", "Mod1", "v"}] = function () for s=1, screen.count() do
                                              awful.tag.viewprev(screen[s]) end end,

        -- Tag selection on bottom 4 monitors
        [{"Mod4", "Mod1", "Shift", "w"}] = function () for s=1, 4 do
                                           awful.tag.viewnext(screen[s]) end end,
        [{"Mod4", "Mod1", "Shift", "v"}] = function () for s=1, 4 do
                                           awful.tag.viewprev(screen[s]) end end,

        -- Window focus
        [{"Mod4", "t"}] = function () awful.client.focus.byidx(1) 
                              if client.focus then client.focus:raise() end
                          end,

        [{"Mod4", "n"}] = function () awful.client.focus.byidx(-1) 
                              if client.focus then client.focus:raise() end
                          end,

        -- Quickmarks
        [{"Mod4", "-"}] = quickmarks.ifocus,
        [{"Mod4", "Shift", "-"}] = quickmarks.iset,

        -- Easy quickmark access with Mod4+Alt_r+Homerow
        [{"Mod4", "Mod5", "a"}] = {quickmarks.focus, "a"},
        [{"Mod4", "Mod5", "o"}] = {quickmarks.focus, "o"},
        [{"Mod4", "Mod5", "e"}] = {quickmarks.focus, "e"},
        [{"Mod4", "Mod5", "u"}] = {quickmarks.focus, "u"},
        [{"Mod4", "Mod5", "i"}] = {quickmarks.focus, "i"},
        [{"Mod4", "Mod5", "d"}] = {quickmarks.focus, "d"},
        [{"Mod4", "Mod5", "h"}] = {quickmarks.focus, "h"},
        [{"Mod4", "Mod5", "t"}] = {quickmarks.focus, "t"},
        [{"Mod4", "Mod5", "n"}] = {quickmarks.focus, "n"},
        [{"Mod4", "Mod5", "s"}] = {quickmarks.focus, "s"},
        [{"Mod4", "Mod5", "w"}] = {quickmarks.focus, "w"},
        [{"Mod4", "Mod5", "v"}] = {quickmarks.focus, "v"},

        -- Irc quickmarks that focus a particular weechat window
        [{"Mod4", "Mod5", "Shift", "."}] = {util.weechat_window, 1},
        [{"Mod4", "Mod5", "Shift", "p"}] = {util.weechat_window, 2},
        [{"Mod4", "Mod5", "Shift", "g"}] = {util.weechat_window, 5},
        [{"Mod4", "Mod5", "Shift", "c"}] = {util.weechat_window, 6},

        [{"Mod4", "Mod5", "Shift", "e"}] = {util.weechat_window, 3},
        [{"Mod4", "Mod5", "Shift", "u"}] = {util.weechat_window, 4},
        [{"Mod4", "Mod5", "Shift", "h"}] = {util.weechat_window, 7},
        [{"Mod4", "Mod5", "Shift", "t"}] = {util.weechat_window, 8},

        -- Quickmark "^^" is a shortcut for "globally last focussed client."
        [{"Mod4", "Mod5", "-"}] = {quickmarks.focus, "^^"},

        -- Switch between layouts
        [{"Mod4", "'"}] = {awful.layout.set, awful.layout.suit.max},
        [{"Mod4", "q"}] = {awful.layout.set, awful.layout.suit.tile},
        [{"Mod4", "j"}] = {awful.layout.set, awful.layout.suit.tile.bottom},
        [{"Mod4", "k"}] = {awful.layout.set, awful.layout.suit.tile.left},

        -- Switch between mwfact modes
        [{"Mod4", "Shift", "'"}] = {awful.tag.setmwfact, 0.5},
        [{"Mod4", "Shift", "q"}] = {awful.tag.setmwfact, 0.618033988769},

        -- Increase or decrease mwfact
        [{"Mod4", "Mod1", "Shift", "h"}] = {awful.tag.incmwfact, -0.05},
        [{"Mod4", "Mod1", "Shift", "l"}] = {awful.tag.incmwfact, 0.05},

        -- Increase or decrease wfact
        [{"Mod4", "Shift", "h"}] = {awful.client.incwfact, -0.05},
        [{"Mod4", "Shift", "l"}] = {awful.client.incwfact, 0.05},

        -- Reset wfact
        [{"Mod4", "Control", "h"}] = function ()
            tag = awful.tag.selected()
            clients = tag:clients()
            num = #clients-awful.tag.getnmaster(tag)
            fact = 1/num

            for i,c in ipairs(clients) do
                if c ~= awful.client.getmaster(c.screen) then
                    awful.client.setwfact(fact, c)
                end
            end
        end,

        -- Increase or decrease the number of master windows
        [{"Mod4", "Mod1", "'"}] = {awful.tag.incnmaster, -1},
        [{"Mod4", "Mod1", "q"}] = {awful.tag.incnmaster, 1},

        -- Toggle fadelist display
        [{"Mod4", "\\"}] = {fadelist, 0},

        -- Toggle fadelist display on all screens
        [{"Mod4", "Mod1", "\\"}] = function ()
            for s=1, screen.count() do
                fadelist(0, s)
            end
        end,

        -- Screen focus
        [{"Mod4", "h"}] = function ()
            local capiscreen = screen
            local screen = mouse.screen

            if capiscreen.count() == 2 then
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
            local capiscreen = screen
            local screen = mouse.screen

            if capiscreen.count() == 2 then
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

        -- Suspend all activity
        [{"Mod4", "F1"}] = {awful.util.spawn_with_shell, apps.system_suspend},

        -- Turns displays off
        [{"Mod4", "F2"}] = {awful.util.spawn_with_shell, apps.displays_off},

        -- Toggle Line In mute
        [{"Mod4", "F8"}] = function () 
            awful.util.spawn("amixer set Line toggle")
        end,

        -- Toggle naughty notifications displaying
        [{"Mod4", "F10"}] = function ()
            if settings._naughty_notify == nil then
                settings._popup_allowed = true
                settings._naughty_notify = naughty.notify
                settings._naughty_stub = function(args)end
            end

            if settings._naughty_notify == naughty.notify then
                naughty.notify = settings._naughty_stub
                settings._popup_allowed = false
            else 
                naughty.notify = settings._naughty_notify
                settings._popup_allowed = true
            end
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
                awful.util.spawn_with_shell("xmodmap ~/.xkb/xmm/nonumbers")
            else 
                settings._numbers = true
                awful.util.spawn_with_shell("xmodmap ~/.xkb/xmm/numbers")
            end
        end,

        -- Start a set of common clients with quickmarks
        [{"Mod4", "Shift", "KP_Subtract"}] = function ()
            -- Top left
            mouse.screen = 5
            awful.client.visible(mouse.screen)[1]:kill()
            util.spawn_wait(apps.irc)

            -- Top right
            mouse.screen = 6
            awful.client.visible(mouse.screen)[1]:kill()
            util.spawn_wait(apps.irc)

            -- Main right
            mouse.screen = 2
            awful.client.visible(mouse.screen)[1]:kill()
            util.spawn_wait(apps.terminal)
            util.spawn_wait(apps.terminal)
            util.spawn_wait(apps.filemanager)

            -- Outer right
            mouse.screen = 3
            awful.client.visible(mouse.screen)[1]:kill()
            util.spawn_wait(apps.mail)
            util.spawn_wait(apps.terminal)
            util.spawn_wait(apps.htop)

            -- Outer left
            mouse.screen = 4
            awful.client.visible(mouse.screen)[1]:kill()
            util.spawn_wait(apps.rtorrent, "0.5")
            util.spawn_wait(apps.newsbeuter)
            util.spawn_wait(apps.ncmpcpp)

            -- Main left
            mouse.screen = 1
            awful.client.visible(mouse.screen)[1]:kill()
            util.spawn_wait(apps.browser)

            -- Assign quickmarks
            local marktimer = timer { timeout = 1 }
            marktimer:add_signal("timeout", function()
                -- Set quickmarks
                util.defquickmarks()

                -- Stop timer
                marktimer:stop()
            end)
            marktimer:start()

            -- Firefox starts so slowly we need to wait longer
            local fxtimer = timer { timeout = 20 }
            fxtimer:add_signal("timeout", function()
                -- Set firefox quickmark again
                quickmarks.set(awful.client.visible(1)[1], "u")

                -- Stop timer
                fxtimer:stop()
            end)
            fxtimer:start()

        end,

        -- Set quickmarks
        [{"Mod4", "Shift", "KP_Multiply"}] = util.defquickmarks,

        -- Shutdown machine
        [{"Mod4", "Shift", "Pause"}] = {awful.util.spawn, apps.shutdown},

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
        awful.button({}, 1, function (c) client.focus = c; c:raise() end),
        awful.button({"Mod4",}, 1, awful.mouse.client.move),
        awful.button({"Mod4",}, 3, awful.mouse.client.resize)
    ), 
}

---- {{{ Set up number bindings
for i=1, #tags[1]  do
    -- Switch to tag number
    bindings.root[{"Mod4", "#"..i+9}] = function()
        awful.tag.viewonly(tags[mouse.screen][i])
    end

    -- Toggle tag display
    bindings.root[{"Mod4", "Control", "#"..i+9}] = function()
        awful.tag.viewtoggle(tags[client.focus.screen][i])
    end

    -- Move client to tag number
    bindings.client[{"Mod4", "Shift", "#"..i+9}] = function()
        awful.client.movetotag(tags[client.focus.screen][i])
    end

    -- Toggle client on tag number
    bindings.client[{"Mod4", "Control", "Shift", "#"..i+9}] = function(c)
        awful.client.toggletag(tags[client.focus.screen][i])
        client.focus = c
    end

    -- Switch all screens to tag number
    bindings.root[{"Mod4", "Mod1", "#"..i+9}] = function()
        for s=1, screen.count() do
            awful.tag.viewonly(tags[s][i])
        end
    end

    -- Switch bottom 4 screens to tag number
    bindings.root[{"Mod4", "Mod1", "Shift", "#"..i+9}] = function()
        for s=1, 4 do
            awful.tag.viewonly(tags[s][i])
        end
    end
end
---- }}}

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

function mailnotify_set(num)
    if num ~= 0 then
        mailnotify_text.text = "-*- Unread Mail: -["..num.."]- -*-"
        mailnotify.screen = client.focus.screen
    else
        mailnotify.screen = nil
    end
end
-- }}}

-- {{{ Listen to remote code over tempfile
remotefile = timer { timeout = 1 }
remotefile:add_signal("timeout", function()
    local file = io.open('/tmp/awesome-remote')
    local exe = {}

    if file then
        -- Read all code
        for line in file:lines() do
            table.insert(exe, line)
        end

        -- Close and delete file
        file:close()
        os.remove('/tmp/awesome-remote')

        -- Execute code
        for i, code in ipairs(exe) do
            loadstring(code)()
        end
    end
end)

remotefile:start()
-- }}}

-- {{{ Signals
-- Client manage
client.add_signal("manage", function (c, startup)
    -- Floating windows are always above the rest
    c:add_signal("property::floating", function (c)
        c.above = awful.client.property.get(c, "floating") and true or false
    end)

    if not startup then
        -- Set the windows at the slave,
        awful.client.setslave(c)
    end
end)

-- Client focus
client.add_signal("focus", function(c)
    -- Set border color
    c.border_color = beautiful.border_focus

    -- Update screen focus
    naughty.config.presets.normal.screen = c.screen
    if mailnotify.screen then mailnotify.screen = c.screen end
end)

-- Client unfocus
client.add_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}

-- vim: set ft=lua fdm=marker:
