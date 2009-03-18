----------------------------------------------------------------------------
-- @author Lucas de Vries &lt;lucas@tuple-typed.org&gt;
-- @copyright 2009 Lucas de Vries
-- @release v0.1
----------------------------------------------------------------------------
-- Note that this is not finished at all, there are a lot of features
-- missing and it's really only useful for me, so you're really not advised
-- to use it.
----------------------------------------------------------------------------

-- Grab environment
local awful = require("awful")
local beautiful = require("beautiful")

local pairs = pairs
local ipairs = ipairs
local type = type
local table = table
local unpack = unpack
local print = print

-- Grab C API
local capi =
{
    awesome = awesome,
    screen = screen,
    client = client,
    mouse = mouse,
    button = button,
    tag = tag,
    root = root,
    key = key,
    wibox = wibox,
    widget = widget,
}

-- Easy configuration library
module("magnifconfig")

-- Tags that were created
tags = {}

-- User hooks
awful.hooks.user.create('newtag')

--
function setup(settings)
    -- {{{ Behaviour functionality
    if settings["behaviour"] then
        --- Cursor warping
        if settings.behaviour.warp_cursor then
            awful.hooks.focus.register(function ()
                -- Get vars
                local sel = capi.client.focus
                if not sel then return end

                local coords = sel:geometry()
                local m = capi.mouse.coords()

                -- Settings
                mouse_padd = settings.behaviour.warp_padd or 6
                border_area = settings.behaviour.warp_border or 10

                -- Check if mouse is not already inside the window
                if  (( m.x < coords.x-border_area or
                       m.y < coords.y-border_area or
                       m.x > coords.x+coords.width+border_area or
                       m.y > coords.y+coords.height+border_area
                    )
                    or force)
                then
                    if not force then
                        for k,v in pairs(m.buttons) do
                            if v then
                                return
                            end
                        end
                    end

                    capi.mouse.coords({ x=coords.x+mouse_padd, y=coords.y+mouse_padd})
                end
            end)
        end
    end
    -- }}}

    -- {{{ Beautiful values
    if settings.beautiful then
        if type(beautiful) == "table" then
            for name, value in pairs(settings.beautiful) do
                beautiful[name] = value
            end
        else
            beautiful.init(settings.beautiful)
        end
    end

    capi.awesome.font = beautiful.font
    -- }}}

    -- {{{ Initial client settings
    awful.hooks.manage.register(function (c, startup) 
        -- Move window to the screen where the mouse is.
        if not startup and awful.client.focus.filter(c) then
            c.screen = capi.mouse.screen
        end

        if settings["behaviour"] then
            -- New become master
            if (settings.behaviour.new_become_master ~= nil and
                    settings.behaviour.new_become_master == false) then
                    awful.client.swap.byidx(1, c)
            end

            -- Size hints
            if settings.behaviour.size_hints_honor ~= nil then
                c.size_hints_honor = settings.behaviour.size_hints_honor
            end

            -- Floatapps
            if settings.behaviour.floatapps then
                if settings.behaviour.floatapps[c.class] then
                    awful.client.floating.set(c, settings.behaviour.floatapps[c.class])
                end

                if settings.behaviour.floatapps[c.instance] then
                    awful.client.floating.set(c, settings.behaviour.floatapps[c.instance])
                end
            end

            -- Borders
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_normal

            -- Focus new clients
            if settings.behaviour.focusnew == nil or settings.behaviour.focusnew then
                capi.client.focus = c
            end
        end
    end)

    awful.hooks.arrange.register(function (screen)
        -- Give focus to the latest client in history if no window has focus
        -- or if the current window is a desktop or a dock one.
        if not capi.client.focus then
            local c = awful.client.focus.history.get(screen, 0)
            if c then capi.client.focus = c end
        end
    end)

    awful.hooks.focus.register(function (c)
        -- Focus border color
        c.border_color = beautiful.border_focus

        -- Raise if needed
        if settings.behaviour.focusraise == nil or settings.behaviour.focusraise then
            c:raise()
        end
    end)

    awful.hooks.unfocus.register(function (c)
        -- Focus border color
        c.border_color = beautiful.border_normal
    end)

    awful.hooks.mouse_enter.register(function (c)
        -- Sloppy focus
        if settings.behaviour.sloppyfocus == nil or settings.behaviour.sloppyfocus then
            if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                and awful.client.focus.filter(c) then
                capi.client.focus = c
            end
        end
    end)
    -- }}}

    -- {{{ Set up tagging
    if settings.tagging then
        awful.hooks.newtag.register(function (t)
            if settings.tagging.default_mwfact then
                awful.tag.setmwfact(settings.tagging.default_mwfact, t)
            end

            if settings.tagging.default_nmaster then
                awful.tag.setnmaster(settings.tagging.default_nmaster, t)
            end

            if settings.tagging.default_ncol then
                awful.tag.setncol(settings.tagging.default_ncol, t)
            end

            if settings.tagging.default_layout then
                awful.layout.set(settings.tagging.default_layout, t)
            end

            if settings.tagging.default_properties then
                for prop, value in pairs(settings.tagging.default_properties) do
                    t.setproperty(t, prop, value)
                end
            end
        end)

        if settings.tagging.tags then
            if settings.tagging.tags[1] and type(settings.tagging.tags[1]) ~= "table" then
                -- Tags for every screen
                for screen = 1, capi.screen.count() do
                    if not tags[screen] then tags[screen] = {} end

                    for index, tagname in pairs(settings.tagging.tags) do
                        t = capi.tag(tagname)
                        t.screen = screen

                        table.insert(tags[screen], t)

                        awful.hooks.user.call("newtag", t)
                    end

                    tags[screen][1].selected = true
                end
            else
                -- Specific screen tags
                for screen, tagtbl in pairs(settings.tagging.tags) do
                    if not tags[screen] then tags[screen] = {} end

                    for index, tagname in pairs(tagtbl) do
                        t = capi.tag(tagname)
                        t.screen = screen

                        table.insert(tags[screen], t)

                        awful.hooks.user.call("newtag", t)
                    end

                    tags[screen][1].selected = true
                end
            end
        end
    end
    -- }}}
end

--
function keys(rootbindings, clientbindings)
    -- {{{ Root bindings
    -- Root binding table
    local rbinds = {}

    -- Bind all root bindings
    for keys, func in pairs(rootbindings) do
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
        local bind = capi.key(keys, actkey, func) 

        -- Insert into table
        table.insert(rbinds, bind)
    end

    -- Bind
    capi.root.keys(rbinds)
    -- }}}

    -- {{{ Client bindings
    -- Client binding table
    local cbinds = {}

    -- Bind all root bindings
    for keys, func in pairs(clientbindings) do
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
        local bind = capi.key(keys, actkey, func) 

        -- Insert into table
        table.insert(cbinds, bind)
    end

    -- Bind
    awful.hooks.manage.register(function (c)
        c:keys(cbinds)
    end)
    -- }}}
end

--
function buttons(rootbindings, clientbindings)
    -- {{{ Root bindings
    -- Root binding table
    local rbinds = {}

    -- Bind all root bindings
    for keys, func in pairs(rootbindings) do
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
        local bind = capi.button(keys, actkey, func) 

        -- Insert into table
        table.insert(rbinds, bind)
    end

    -- Bind
    capi.root.buttons(rbinds)
    -- }}}

    -- {{{ Client bindings
    -- Client binding table
    local cbinds = {}

    -- Bind all root bindings
    for keys, func in pairs(clientbindings) do
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
        local bind = capi.button(keys, actkey, func) 

        -- Insert into table
        table.insert(cbinds, bind)
    end

    -- Bind
    awful.hooks.manage.register(function (c)
        c:buttons(cbinds)
    end)
    -- }}}
end

--
function wibox(widgets, screens)
end

--
function titlebar(widgets)
end

function prompt(text, callback, width, height, margin)
-- {{{ Floating prompt
    -- Get current screen
    local screen = capi.mouse.screen

    -- Create wibox
    local promptbox = capi.wibox({
        position = "floating",
        fg = beautiful.fg_normal,
        bg = beautiful.bg_normal,
        border_width = beautiful.border_width,
        border_color = beautiful.border_focus,
    })

    -- Create textbox to type in
    local textbox = capi.widget({
        type = "textbox",
    })

    -- Set margin
    margin = margin or 4
    textbox:margin({ right = margin, left = margin })

    -- Default geometry
    promptgeom = {
        width = width or 400+margin*2,
        height = height or 20+margin*2,
        x = capi.screen[screen].workarea.width-(width or (400+margin*2)),
        y = 0,
    }

    -- Show promptbox
    promptbox.ontop = true
    promptbox.widgets = {textbox}
    promptbox:geometry(promptgeom)
    promptbox.screen = screen

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
-- }}}
end

util = {
    tag = {
        getidx = function (i, screen)
            local tags = capi.screen[screen or capi.mouse.screen]:tags()
            local sel = awful.tag.selected(screen)
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
}

-- vim: set ft=lua fdm=marker:
