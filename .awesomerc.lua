---- GGLucas' Awesome-3 Lua Config :D
------
-- I use both wicked and eminent, so to use it,
-- you'll need to get both those helper libraries too.
------
-- Note that I use all-custom keybindings and you might
-- want to copy the default awesomerc.lua's keybindings 
-- into here if you wish to use those, although you might
-- find you like mine better :P
------
-- Requires
require("awful")
require("wicked")
require("eminent")

-- {{{ Settings
-- We define variables here we can later use to set
-- the specific settings.
default_font = 'Terminus 8'
default_mwfact = 0.618033988769
spacer = " "
separator = " " 

awesome.resizehints_set(false)
awesome.font_set(default_font)

-- }}}

-- {{{ Applications
-- We define frequently used applications into variables
-- so we can easily change which ones we use.
terminal = 'urxvtc'
-- Note: mydmenu is my own script that feeds
-- specific options/values into dmenu, replace it
-- with how you call dmenu if you wish to use it.
menu = 'mydmenu'
lock = 'xscreensaver-command -lock'
filemanager = terminal..' -e mc -c'

--- {{{ Music
-- Note: mpdtoggle is my own script for finding out if 
-- I want to toggle or play/stop, replace it with mpc if
-- you wish to use it.
music_toggle = 'mpdtoggle toggle'
music_stop = 'mpdtoggle stop'
music_next = 'mpc next'
music_prev = 'mpc prev'

---- }}}

-- }}}

-- {{{ Colors
-- Background Colors
bg_normal = '#222222'
bg_focus = '#285577'
bg_urgent = '#A10000'

-- Text Colors
fg_normal = '#888888'
fg_focus = '#ffffff'
fg_urgent = '#ffffff'

-- Border Colors/Width
border_width = 2
border_normal = '#333333'
border_focus = '#4C7899'

-- Set default colors
awesome.colors_set({ fg = fg_normal, bg = bg_normal })

-- }}}

-- {{{ Modkeys
modkey = "Mod4"
shift = "Shift"
alt = "Mod1"
control = "Control"

-- }}}

-- {{{ Key combinations
k_n = {}
k_m = {modkey}
k_ms = {modkey, shift}
k_ma = {modkey, alt}
k_mc = {modkey, control}
k_a = {alt}
k_ac = {alt, control}
k_as = {alt, shift}
k_c = {control}
k_cs = {control, shift}
k_s = {shift}

-- }}}

-- {{{ Set tag names
-- eminent.tag.name(Tag_Number, Screen_Number, Name)
eminent.tag.name(1, 1, 'main')
eminent.tag.name(1, 2, 'main')
eminent.tag.name(2, 2, 'msg')
eminent.tag.name(3, 2, 'mpd')
eminent.tag.name(4, 2, 'dl')

-- {{{ Markup helper functions
-- Inline markup is a tad ugly, so use these functions
-- to dynamically create markup.
function bg(color, text)
    return '<bg color="'..color..'" />'..text
end

function fg(color, text)
    return '<span color="'..color..'">'..text..'</span>'
end

function font(font, text)
    return '<span font_desc="'..font..'">'..text..'</span>'
end

function title()
    return '<title />'
end

function title_normal()
    return bg(bg_normal, fg(fg_normal, title()))
end

function title_focus()
    return bg(bg_focus, fg(fg_focus, title()))
end

function title_urgent()
    return bg(bg_urgent, fg(fg_urgent, title()))
end

function heading(text)
    return fg(fg_focus, text)
end

-- }}}

-- {{{ Functions
-- Toggle whether we're viewing a tag
function tag_toggleview(tag)
    tag:view(not tag:isselected())
end

-- Redraw all currently visible clients
function redraw_all()
    local cls = client.visible_get(mouse.screen_get())
    for idx, c in ipairs(cls) do
        c:redraw()
    end
end

-- Get the screen number we're on
function getscreen()
    local sel = client.focus_get()
    local s
    if sel then
        s = sel:screen_get()
    else
        s = mouse.screen_get()
    end

    return s
end

-- Move current client to a specific screen
function client_movetoscreen(i)
    local sel = client.focus_get()
    sel:screen_set(i)
end

-- }}}

-- {{{ Taglist
maintaglist = widget.new(
{ type = 'taglist',
  name = 'maintaglist'
})

maintaglist:set('text_normal',
    spacer..title_normal()..spacer    
)

maintaglist:set('text_focus',
    spacer..title_focus()..spacer
)

maintaglist:set('text_urgent',
    spacer..title_urgent()..spacer
)

maintaglist:set('show_empty', 'false')

maintaglist:mouse(k_n, 1,
    awful.tag.viewonly
)

maintaglist:mouse(k_m, 1,
    tag_toggleview
)

maintaglist:mouse(k_a, 1,
    awful.client.movetotag
)

maintaglist:mouse(k_n, 5, function ()
    eminent.tag.next(mouse.screen_get()) end)

maintaglist:mouse(k_n, 4, function () 
    eminent.tag.prev(mouse.screen_get()) end)

-- }}}

mytasklist = widget.new({ type = "tasklist", name = "mytasklist" })
mytasklist:mouse({ }, 1, function (c) c:focus_set(); c:raise() end)
mytasklist:mouse({ }, 4, function () awful.client.focus(1) end)
mytasklist:mouse({ }, 5, function () awful.client.focus(-1) end)
mytasklist:set("text_focus", "<bg color=\"#555555\"/> <title/> ")


-- {{{ MPD Widget
mpdwidget = widget.new({
    type = 'textbox',
    name = 'mpdwidget',
    align = 'right'
})

mpdwidget:set('text', spacer..heading('MPD')..': '..spacer..separator)
wicked.register(mpdwidget, 'mpd', function (widget, args)
    -- I don't want the stream name on my statusbar, so I gsub it out, feel free to take it out
    return spacer..heading('MPD')..': '..args[1]:gsub('AnimeNfo Radio  | Serving you the best Anime music!: ','')..spacer..separator end)

-- }}}

-- {{{ GMail Widget
gmailwidget = widget.new({
    type = 'textbox',
    name = 'gmailwidget',
    align = 'right'
})

gmailwidget:set('text', spacer..heading('GMail')..': 0'..spacer..separator)
wicked.register(gmailwidget, 'function', function (widget, args)
    -- Call GMail check script to check for new email
    local f = io.popen('/home/archlucas/other/.gmail.py')
    if f == nil then return '' end
    local n = f:read()
    if n == nil then return '' end
    f:close()
    out = spacer..heading('GMail')..': '

    if tonumber(n) > 0 then
        out = out..bg(bg_urgent, fg(fg_urgent, tostring(n)))
    else
        out = out .. tostring(n)
    end

    out = out..spacer..separator

    return out
end, 120)

-- }}}

-- {{{ GPU Temp Widget
gpuwidget = widget.new({
    type = 'textbox',
    name = 'gpuwidget',
    align = 'right'
})

gpuwidget:set('text', spacer..heading('GPU')..': n/a°C'..spacer..separator)
wicked.register(gpuwidget, 'function', function (widget, args)
    -- Use nvidia-settings to figure out the GPU temperature
    command = "nvidia-settings -q [gpu:0]/GPUCoreTemp | grep '):'"
    local f = io.popen(command)
    if f == nil then return '' end
    local n = f:read()
    if n == nil then return '' end
    out = ''
    f:close()

    if n ~= nil then
        n = string.sub(n, -3, -2)

        out = spacer..heading('GPU')..': '..n..'°C'..spacer..separator 
    end
    return out
end, 120)

-- }}}

-- {{{ CPU Usage Widget
cputextwidget = widget.new({
    type = 'textbox',
    name = 'cputextwidget',
    align = 'right'
})

cputextwidget:set('text', spacer..heading('CPU')..': '..spacer..separator)
wicked.register(cputextwidget, 'cpu', function (widget, args) 
    -- Add a zero if lower than 10
    if args[1] < 10 then 
        args[1] = '0'..args[1]
    end

    return spacer..heading('CPU')..': '..args[1]..'%'..spacer..separator end) 

-- }}}

-- {{{ CPU Graph Widget
cpugraphwidget = widget.new({
    type = 'graph',
    name = 'cpugraphwidget',
    align = 'right'
})

cpugraphwidget:set('height', '0.85')
cpugraphwidget:set('width', '45')
cpugraphwidget:set('grow', 'left')
cpugraphwidget:set('bg', '#333333')
cpugraphwidget:set('bordercolor', '#0a0a0a')
cpugraphwidget:set('fg', 'cpu #AEC6D8')
cpugraphwidget:set('fg_center', 'cpu #285577')
cpugraphwidget:set('fg_end', 'cpu #285577')
cpugraphwidget:set('vertical_gradient', 'cpu false')

wicked.register(cpugraphwidget, 'cpu', 'cpu $1', 1, 'data')

-- }}}

-- {{{ Memory Usage Widget
memtextwidget = widget.new({
    type = 'textbox',
    name = 'memtextwidget',
    align = 'right'
})

memtextwidget:set('text', spacer..heading('MEM')..': '..spacer..separator)
wicked.register(memtextwidget, 'mem', function (widget, args) 
    -- Add extra preceding zeroes when needed
    if tonumber(args[1]) < 10 then args[1] = '0'..args[1] end
    if tonumber(args[2]) < 1000 then args[2] = '0'..args[2] end
    if tonumber(args[3]) < 1000 then args[3] = '0'..args[3] end
    return spacer..heading('MEM')..': '..args[1]..'% ('..args[2]..'/'..args[3]..')'..spacer..separator end)

-- }}}
--
-- {{{ Memory Graph Widget
memgraphwidget = widget.new({
    type = 'graph',
    name = 'memgraphwidget',
    align = 'right'
})

memgraphwidget:set('height', '0.85')
memgraphwidget:set('width', '45')
memgraphwidget:set('grow', 'left')
memgraphwidget:set('bg', '#333333')
memgraphwidget:set('bordercolor', '#0a0a0a')
memgraphwidget:set('fg', 'mem #AEC6D8')
memgraphwidget:set('fg_center', 'mem #285577')
memgraphwidget:set('fg_end', 'mem #285577')
memgraphwidget:set('vertical_gradient', 'mem false')

wicked.register(memgraphwidget, 'mem', 'mem $1', 1, 'data')

-- }}}
--
-- {{ Other Widget
spacerwidget = widget.new({ type = 'textbox', name = 'spacerwidget', align = 'right' })
spacerwidget:set('text', spacer..separator)

-- }}

-- {{{ Statusbar
mainstatusbar = {}
statusbar_status = {}

for s = 1, screen.count() do
    mainstatusbar[s] = statusbar.new({ 
        position = "top", 
        height = 18,
        name = "mainstatusbar" .. s,                        
        fg = fg_normal, 
        bg = bg_normal })
    
    mainstatusbar[s]:widget_add(maintaglist)
    mainstatusbar[s]:widget_add(mpdwidget)
    mainstatusbar[s]:widget_add(gmailwidget)
    mainstatusbar[s]:widget_add(gpuwidget)
    mainstatusbar[s]:widget_add(cputextwidget)
    mainstatusbar[s]:widget_add(cpugraphwidget)
    mainstatusbar[s]:widget_add(spacerwidget)
    mainstatusbar[s]:widget_add(memtextwidget)
    mainstatusbar[s]:widget_add(memgraphwidget)
    mainstatusbar[s]:widget_add(spacerwidget)
    mainstatusbar[s]:add(s)
    statusbar_status[s] = 1
end

-- }}}

-- {{{ Mouse bindings
-- Alt+Button1: Move window
client.mouse(k_a, 1, function()
   client.focus_get():mouse_move() 
end)

-- Alt+Button3: Resize window
client.mouse(k_a, 3, function()
    client.focus_get():mouse_resize()
end)

-- Button3 on root window: spawn terminal
awesome.mouse(k_n, 3, function () 
    awful.spawn(terminal) end)

-- }}}

-- {{{ Key bindings
---- {{{ Application Launchers
-- Alt+Q: Launch a new terminal
keybinding.new(k_a, "q", function () 
    awful.spawn( terminal ) end):add()

-- Mod+K: Launch a new terminal with screen in it
keybinding.new(k_m, "k", function () 
    awful.spawn( 'urxvtc -e "fish" -c "exec screen -x main"' ) end):add()

-- Alt+W: Launch the menu application set before
keybinding.new(k_a, "w", function () 
    awful.spawn( menu ) end):add()

-- Alt+E: Toggle music playing
keybinding.new(k_a, "e", function () 
    awful.spawn( music_toggle ) end):add()

-- Mod+L: Lock the screen
keybinding.new(k_m, "l", function () 
    awful.spawn( lock ) end):add()

-- Alt+D: Spawn file manager in /data
keybinding.new(k_a, "d", function ()
    awful.spawn( filemanager..' /data')
end):add()

-- Alt+A: Spawn file manager in ~
keybinding.new(k_a, "a", function ()
    awful.spawn( filemanager..' /home/archlucas')
end):add()

---- }}}

---- {{{ Client hotkeys
-- Alt+`: Close window
keybinding.new(k_a, "#49", function ()
    client.focus_get():kill() end):add()

-- Mod+`: Redraw window
keybinding.new(k_m, "#49", function ()
    client.focus_get():redraw() end):add()

-- Mod+Shift+`: Redraw all windows
keybinding.new(k_ms, "#49", function ()
    redraw_all() end):add()


-- Mod+M: Toggle window maximized
keybinding.new(k_m, "m", function ()
    awful.client.togglemax() end):add()


-- Mod+{Q/W}: Focus Prev/Next window
keybinding.new(k_m, "q", function ()
    awful.client.focus(-1) end):add()

keybinding.new(k_m, "w", function ()
    awful.client.focus(1) end):add()

-- Mod+Shift+{Q/W}: Swap window with the Prev/Next one
keybinding.new(k_ms, "q", function ()
    awful.client.swap(-1) end):add()

keybinding.new(k_ms, "w", function ()
    awful.client.swap(1) end):add()


-- Mod+C: Toggle window floating
keybinding.new(k_m, "c", function ()
    awful.client.togglefloating() end):add()

-- Mod+#94 (left of Z, not all keyboards have it): 
-- Make window master
keybinding.new(k_m, "#94", function ()
    client.visible_get(client.focus_get():screen_get())[1]:swap(client.focus_get())
end):add()

-- Mod+Shift+{A/S}: Move window to Prev/Next tag
keybinding.new(k_ms, "a", function()
    awful.client.movetotag(eminent.tag.getprev())
end):add()

keybinding.new(k_ms, "s", function()
    awful.client.movetotag(eminent.tag.getnext())
end):add()


-- Mod+Shift_{E/D}: move window to next/prev screen
keybinding.new(k_ms, "e", function()
   local s = getscreen()+1
   while s > screen.count() do
       s = s-screen.count()
   end

   client_movetoscreen(s)
end):add()

keybinding.new(k_ms, "d", function()
   local s = getscreen()-1
   while s < 1 do
       s = s+screen.count()
   end

   client_movetoscreen(s)
end):add()


---- }}}

---- {{{ Tag hotkeys
-- Mod+{A/S}: Switch to prev/next tag
keybinding.new(k_m, "a", function()
    eminent.tag.prev() end):add()

keybinding.new(k_m, "s", function()
    eminent.tag.next() end):add()

keybinding.new(k_m, "n", function()
    awful.tag.viewonly(eminent.tag.new()) end):add()

keybinding.new(k_ms, "n", function()
    eminent.name_dialog() end):add()

-- Alt+#94 (left of Z, not all keyboards have it):
-- Switch to floating layout
keybinding.new(k_a, "#94", function ()
    awful.tag.selected():layout_set('floating')
    redraw_all()
end):add()

-- Alt+Z: Switch to max layout
keybinding.new(k_a, "z", function ()
    awful.tag.selected():layout_set('max')
    redraw_all()
end):add()

-- Alt+X: Switch to regular tile layout
keybinding.new(k_a, "x", function ()
    awful.tag.selected():layout_set('tile')
    redraw_all()
end):add()

-- Mod+{Z/X}: Decrease/Increase the amount of masters
keybinding.new(k_m, "z", function ()
    awful.tag.incnmaster(-1)
end):add()

keybinding.new(k_m, "x", function ()
    awful.tag.incnmaster(1)
end):add()

-- Mod+Control+Z: Switch to default mwfact
keybinding.new(k_mc, "z", function ()
    awful.tag.setmwfact(default_mwfact) end):add()

-- Mod+Control+X: Switch to mwfact 0.5
keybinding.new(k_mc, "x", function ()
    awful.tag.setmwfact(0.5) end):add()

---- }}}

---- {{{ Miscellaneous hotkeys
-- Mod+R: Restart awesome
keybinding.new(k_m, "r", 
    awesome.restart):add()

-- Mod+{E/D}: Switch to next/previous screen
keybinding.new(k_m, "e", function ()
    awful.screen.focus(1) end):add()

keybinding.new(k_m, "d", function ()
    awful.screen.focus(-1) end):add()

-- Mod+B: Turn off statusbar on current screen
keybinding.new(k_m, "b", function ()
    local w = getscreen()
    local s = mainstatusbar[w]

    if statusbar_status[w] == 0 then
        statusbar_status[w] = 1
        s:position_set('top')
    else
        s:position_set('off')
        statusbar_status[w] = 0
    end
end):add()

---- }}}

---- {{{ Number keys
-- Mod+#: Switch to tag
-- Mod+Shift+#: Toggle tag display
-- Mod+Control+#: Move client to tag
-- Mod+Alt+#: Toggle client on tag
for i = 1, 9 do
    keybinding.new(k_m, i,
                function ()
                    local t = eminent.tag.getn(i)
                    if t ~= nil then
                       awful.tag.viewonly(t) 
                    end
                end):add()
    keybinding.new(k_ms, i,
                function ()
                    local t = eminent.tag.getn(i)
                    if t ~= nil then
                        t:view( not t:isselected() )
                    end
                end):add()
    keybinding.new(k_mc, i,
                function ()
                    local t = eminent.tag.getn(i)
                    if t ~= nil then
                        awful.client.movetotag(t)
                    end
                end):add()
    keybinding.new(k_ma, i,
                function ()
                    local t = eminent.tag.getn(i)
                    if t ~= nil then
                        client.focus_get():tag(t, not client.focus_get():istagged(t))
                    end
                end):add()
end

---- }}}

-- }}}


-- {{{ Hooks
function hook_focus(c)
    -- Set border to active color
    c:border_set({ 
        width = border_width, 
        color = border_focus 
    })

    -- Raise the client
    c:raise()
end

function hook_unfocus(c)
    -- Set border back to normal
    c:border_set({ 
        width = border_width, 
        color = border_normal 
    })
end

function hook_mouseover(c)
    -- Set focus for sloppy focus
    c:focus_set()
end

function hook_newclient(c)
    -- Focus new clients
    c:focus_set()
   
    -- Prevents new windows from becoming master
    cls = client.visible_get(mouse.screen_get())
    for i,p in pairs(cls) do
        if p ~= c then
            c:swap(p)
            break
        end
    end
    
    -- Create border
    c:border_set({ 
        width = border_width, 
        color = border_focus 
    })

    -- Make gimp floating
    if c:name_get():lower():find('gimp') then
        c:floating_set(true)
    end
end

-- Attach the hooks
awful.hooks.focus(hook_focus)
awful.hooks.unfocus(hook_unfocus)
awful.hooks.newclient(hook_newclient)
awful.hooks.mouseover(hook_mouseover)

-- }}}
