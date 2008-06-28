-- GGLucas' Awesome-3 Lua Config :D
------
-- If you have any suggestions or questions, feel free
-- to pass me a message, find me in #awesome on OFTC, or
-- email me at <lucasdevries[at]gmail.com>
------
-- I use both wicked and eminent, so to use it,
-- you'll need to get both those helper libraries too.
------
-- Note that I use all-custom keybindings, so you might
-- want to copy the default awesomerc.lua's keybindings 
-- into here if you wish to use those, although you might
-- find you like mine better :P
------
-- Libs included in awesome
require("awful")

-- External libs
require("wicked")
require("eminent")

-- {{{ Settings
-- We define variables here we can later use to set
-- the specific settings.
default_font = 'Terminus 8'
default_mwfact = 0.618033988769
spacer = " "
separator = " " 

-- Highlight statusbars on the screen that has focus, 
-- set this to false if you only have one screen or 
-- you don't like it :P
if screen.count() > 1 then
    statusbar_highlight_focus = true
else
    statusbar_highlight_focus = false
end

awesome.font_set(default_font)

-- Since I use this config on multiple PCs, I check for the
-- existance of a special file in my home directory to select the appropriate
-- set of widgets.
local f = io.open('/home/archlucas/.laptop_mode')
if f == nil then
    mode = 'desktop'
else
    mode = 'laptop'
end

-- Uncomment to enable or disable all widgets
-- mode = 'all'
-- mode = 'none'

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
filemanager = terminal..' -e fish -c "mc'

--- {{{ Music
-- Note: mpdtoggle is my own script for finding out if 
-- I want to toggle or play/stop, replace it with mpc if
-- you wish to use it.
music_toggle = 'mpdtoggle toggle'
music_stop = 'mpdtoggle stop'
music_next = 'mpc next'
music_prev = 'mpc prev'

-- Sound
vol_set = 'amixer -q set PCM '
vol_up = 'amixer -q set PCM 8%+'
vol_down = 'amixer -q set PCM 8%-'
vol_mute = 'amixer -q set Master togglemute'

---- }}}

-- }}}

-- {{{ Colors
-- Background Colors
bg_normal = '#222222'
bg_focus = '#285577'
bg_sbfocus = '#113355'
bg_urgent = '#A10000'

-- Text Colors
fg_normal = '#999999'
fg_focus = '#ffffff'
fg_sbfocus = fg_normal
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

-- {{{ Set tag properties
-- Pre-create extra tags
-- eminent.newtag(Screen_Number, Amount)
for s = 1, screen.count() do 
    eminent.newtag(s, 5)
end

-- }}}

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
    return title()
end

function title_focus()
    return bg(bg_focus, fg(fg_focus, title()))
end

function title_urgent()
    return bg(bg_urgent, fg(fg_urgent, title()))
end

function bold(text)
    return '<b>'..text..'</b>'
end

function heading(text)
    return fg(fg_focus, bold(text))
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

-- Mouse warp function
function mouse.warp(c, force)
    -- Allow skipping a warp
    if warp_skip then
        warp_skip = false
        return
    end

    -- Get vars
    local sel = c or client.focus_get()
    if sel == nil then return end

    local coords = sel:coords_get()
    local m = mouse.coords_get()

    -- Settings
    mouse_padd = 6
    border_area = 5
    
    -- Check if mouse is not already inside the window
    if  (( m.x < coords.x-border_area or
           m.y < coords.y-border_area or
           m.x > coords.x+coords.width+border_area or
           m.y > coords.y+coords.height+border_area
        ) and (
           table.maxn(m.buttons) == 0
        )) or force
    then
        mouse.coords_set(coords.x+mouse_padd, coords.y+mouse_padd)
    end
end

-- Redraw a client
function redraw_client(cls)
    local c = cls or client.focus_get()
    c:redraw()
    c:focus_set()
    mouse.warp(c, true)
end

-- }}}

-- {{{ Taglist
maintaglist = widget.new(
{ type = 'taglist',
  name = 'maintaglist'
})

maintaglist.text_normal = spacer..title_normal()..spacer
maintaglist.text_focus = spacer..title_focus()..spacer
maintaglist.text_urgent = spacer..title_urgent()..spacer
maintaglist.show_empty = false

maintaglist:mouse_add(mouse.new(k_n, 1, function (object, tag)
    awful.tag.viewonly(tag)
end))

maintaglist:mouse_add(mouse.new(k_m, 1, function (object, tag)
    tag_toggleview(tag)
end))

maintaglist:mouse_add(mouse.new(k_a, 1, function (object, tag)
    awful.client.movetotag(tag)
end))

maintaglist:mouse_add(mouse.new(k_n, 5, function (object, tag)
    warp_skip = true
    eminent.tag.next(mouse.screen_get()) end))

maintaglist:mouse_add(mouse.new(k_n, 4, function (object, tag)
    warp_skip = true
    eminent.tag.prev(mouse.screen_get()) end))

-- }}}

if mode ~= 'none' then
-- {{{ MPD Widget
mpdwidget = widget.new({
    type = 'textbox',
    name = 'mpdwidget',
    align = 'right'
})

mpdwidget.text = spacer..heading('MPD')..': '..spacer..separator
wicked.register(mpdwidget, 'mpd', function (widget, args)
    -- I don't want the stream name on my statusbar, so I gsub it out,
    -- feel free to remove this bit
    return spacer..heading('MPD')..': '
    ..args[1]:gsub('AnimeNfo Radio  | Serving you the best Anime music!: ','')
    ..spacer..separator end)

-- }}}

-- {{{ GMail Widget
gmailwidget = widget.new({
    type = 'textbox',
    name = 'gmailwidget',
    align = 'right'
})

gmailwidget.text =  spacer..heading('GMail')..': 0'..spacer..separator
gmailwidget:mouse_add(mouse.new(k_n, 1, function () wicked.update(gmailwidget) end))

wicked.register(gmailwidget, 'function', function (widget, args)
    -- Read temp file created by gmail check script
    local f = io.open('/tmp/gmail-temp')
    if f == nil then
        f:close()
        return spacer..heading('GMail')..': 0'..spacer..separator
    end

    local n = f:read()

    if n == nil then
        f:close()
        return spacer..heading('GMail')..': 0'..spacer..separator
    end

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

-- Start timer to read the temp file
awful.hooks.timer(110, function ()
    -- Call GMail check script to check for new email
    os.execute('/home/archlucas/other/.gmail.py > /tmp/gmail-temp &')
end, true)

-- }}}

-- {{{ Load Averages Widget
loadwidget = widget.new({
    type = 'textbox',
    name = 'loadwidget',
    align = 'right'
})

wicked.register(loadwidget, 'function', function (widget, args)
    -- Use /proc/loadavg to get the average system load on 1, 5 and 15 minute intervals
    local f = io.open('/proc/loadavg')
    local n = f:read()
    f:close()

    -- Find the third space
    local pos = n:find(' ', n:find(' ', n:find(' ')+1)+1)

    return spacer..heading('Load')..': '..n:sub(1,pos-1)..spacer..separator 

end, 2)

-- }}}

-- {{{ CPU Usage Widget
cputextwidget = widget.new({
    type = 'textbox',
    name = 'cputextwidget',
    align = 'right'
})

cputextwidget.text = spacer..heading('CPU')..': '..spacer..separator
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


cpugraphwidget.height = 0.85
cpugraphwidget.width = 45
cpugraphwidget.bg = '#333333'
cpugraphwidget.border_color = '#0a0a0a'
cpugraphwidget.grow = 'left'


cpugraphwidget:plot_properties_set('cpu', {
    fg = '#AEC6D8',
    fg_center = '#285577',
    fg_end = '#285577',
    vertical_gradient = false
})

wicked.register(cpugraphwidget, 'cpu', '$1', 1, 'cpu')

-- }}}

-- {{{ Memory Usage Widget
memtextwidget = widget.new({
    type = 'textbox',
    name = 'memtextwidget',
    align = 'right'
})

memtextwidget.text = spacer..heading('MEM')..': '..spacer..separator
wicked.register(memtextwidget, 'mem', function (widget, args) 
    -- Add extra preceding zeroes when needed
    if tonumber(args[1]) < 10 then args[1] = '0'..args[1] end
    if tonumber(args[2]) < 1000 then args[2] = '0'..args[2] end
    if tonumber(args[3]) < 1000 then args[3] = '0'..args[3] end
    return spacer..heading('MEM')..': '..args[1]..'% ('..args[2]..'/'..args[3]..')'..spacer..separator end)

-- }}}

-- {{{ Memory Graph Widget
memgraphwidget = widget.new({
    type = 'graph',
    name = 'memgraphwidget',
    align = 'right'
})

memgraphwidget.height = 0.85
memgraphwidget.width = 45
memgraphwidget.bg = '#333333'
memgraphwidget.border_color = '#0a0a0a'
memgraphwidget.grow = 'left'

memgraphwidget:plot_properties_set('mem', {
    fg = '#AEC6D8',
    fg_center = '#285577',
    fg_end = '#285577',
    vertical_gradient = false
})

wicked.register(memgraphwidget, 'mem', '$1', 1, 'mem')

-- }}}

-- {{{ Other Widget
spacerwidget = widget.new({ type = 'textbox', name = 'spacerwidget', align = 'right' })
spacerwidget.text = spacer..separator

-- }}}
end

if mode == 'laptop' or mode == 'all' then
-- {{{ Battery Widget
batterywidget = widget.new({
    type = 'textbox',
    name = 'batterywidget',
    align = 'right'
})

batterywidget.text = spacer..heading('Battery')..': n/a'..spacer..separator
wicked.register(batterywidget, 'function', function (widget, args)
    -- Read temp file created by battery script
    local f = io.open('/tmp/battery-temp')
    if f == nil then
        f:close()
        return spacer..heading('Battery')..': n/a'..spacer..separator
    end

    local n = f:read()

    if n == nil then
        f:close()
        return spacer..heading('Battery')..': n/a'..spacer..separator
    end

    out = ''
    f:close()

    if n ~= nil then
        out = spacer..heading('Battery')..': '..n..spacer..separator
    end
    return out
end, 30)

-- Start timer to read the temp file
awful.hooks.timer(28, function ()
    -- Call battery script to get batt%
    command = "battery"
    os.execute(command..' > /tmp/battery-temp &')
end, true)

-- }}}
end

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

    if mode == 'laptop' or mode == 'all' then
        mainstatusbar[s]:widget_add(batterywidget)
    end

    if mode ~= 'none' then
        mainstatusbar[s]:widget_add(mpdwidget)
        mainstatusbar[s]:widget_add(gmailwidget)
        mainstatusbar[s]:widget_add(loadwidget)
        mainstatusbar[s]:widget_add(cputextwidget)
        mainstatusbar[s]:widget_add(cpugraphwidget)
        mainstatusbar[s]:widget_add(spacerwidget)
        mainstatusbar[s]:widget_add(memtextwidget)
        mainstatusbar[s]:widget_add(memgraphwidget)
        mainstatusbar[s]:widget_add(spacerwidget)
    end

    mainstatusbar[s]:add(s)
    statusbar_status[s] = 1
end

-- }}}

---- {{{ Application Launchers
-- Alt+Q: Launch a new terminal
keybinding.new(k_a, "q", function () 
    awful.spawn(terminal) end):add()

-- Mod+K: Launch a new terminal with screen in it
keybinding.new(k_m, "k", function () 
    awful.spawn('urxvtc -e "fish" -c "exec screen -x main"') end):add()

-- Alt+W: Launch the menu application set before
keybinding.new(k_a, "w", function () 
    awful.spawn(menu) end):add()

-- Alt+E: Toggle music playing
keybinding.new(k_a, "e", function () 
    awful.spawn(music_toggle) end):add()

-- Mod+L: Lock the screen
keybinding.new(k_m, "l", function () 
    awful.spawn(lock) end):add()

-- Mod+O: Turn the screen off (DPMS)
keybinding.new(k_m, "o", function () 
    awful.spawn('sleep 1; xset dpms force off') end):add()

-- Alt+D: Spawn file manager in /data
keybinding.new(k_a, "d", function ()
    awful.spawn(filemanager..' /data"')
end):add()

-- Alt+A: Spawn file manager in ~
keybinding.new(k_a, "a", function ()
    awful.spawn(filemanager..' /home/archlucas"')
end):add()

-- Alt+S: Kill all notification messages on screen
-- Note: custom script
keybinding.new(k_a, "s", function ()
    awful.spawn('stopnotify')
end):add()

---- }}}

---- {{{ Multimedia keyboard keys/Volume shortcuts
keybinding.new(k_n, "#176", function ()
    awful.spawn(vol_up)
end):add()

keybinding.new(k_n, "#174", function ()
    awful.spawn(vol_down)
end):add()

keybinding.new(k_n, "#160", function ()
    awful.spawn(vol_mute)
end):add()

keybinding.new(k_a, "n", function ()
    awful.spawn(vol_up)
end):add()

keybinding.new(k_a, "b", function ()
    awful.spawn(vol_down)
end):add()

keybinding.new(k_a, "m", function ()
    awful.spawn(vol_mute)
end):add()

keybinding.new(k_ma, "b", function ()
    awful.spawn(vol_set..'50%')
end):add()

keybinding.new(k_ma, "n", function ()
    awful.spawn(vol_set..'100%')
end):add()

---- }}}

---- {{{ Client hotkeys
-- Alt+`: Close window
keybinding.new(k_a, "#49", function ()
    client.focus_get():kill() end):add()

-- Mod+`: Redraw window
keybinding.new(k_m, "#49", function ()
    redraw_client() end):add()

-- Mod+Shift+`: Redraw all windows
keybinding.new(k_ms, "#49", function ()
    redraw_all() end):add()

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

-- Mod+\: Alternative to Mod+#94 
keybinding.new(k_m, "#51", function ()
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

-- Mouse Button3 on root window: spawn terminal
awesome.mouse_add(mouse.new(k_n, 3, function ()
    awful.spawn(terminal) end))

---- }}}

---- {{{ Number keys
-- Mod+#: Switch to tag
-- Mod+Shift+#: Toggle tag display
-- Mod+Control+#: Move client to tag
-- Mod+Alt+#: Toggle client on tag
-- Alt+Shift+#: Switch to a tabbed client 
for i = 1, 9 do
    keybinding.new(k_m, i,
                function ()
                    local t = eminent.tag.getn(i, nil, true)
                    if t ~= nil then
                       awful.tag.viewonly(t) 
                    end
                end):add()
    keybinding.new(k_ms, i,
                function ()
                    local t = eminent.tag.getn(i, nil, true)
                    if t ~= nil then
                        t:view( not t:isselected() )
                    end
                end):add()
    keybinding.new(k_mc, i,
                function ()
                    local t = eminent.tag.getn(i, nil, true)
                    if t ~= nil then
                        awful.client.movetotag(t)
                    end
                end):add()
    keybinding.new(k_ma, i,
                function ()
                    local t = eminent.tag.getn(i, nil, true)
                    if t ~= nil then
                        client.focus_get():tag(t, not client.focus_get():istagged(t))
                    end
                end):add()
    keybinding.new(k_as, i,
                function ()
                    local index = tabulous.tabindex_get()
                    local t = tabulous.position_get(index, i)
                    if t ~= nil then
                        tabulous.display(index, t)
                    end
                end):add()
end

---- }}}

-- {{{ Hooks
function hook_focus(c)
    -- Skip over urxvtcnotify
    local name = c:name_get():lower()

    if name:find('urxvtcnotify') and awful.client.next(1) ~= c then
        awful.client.focus(1)
        return 0
    end

    -- Set border to active color
    c:border_set({ 
        width = border_width, 
        color = border_focus 
    })

    -- Raise the client
    c:raise()

    -- Set statusbar color
    local s = c:screen_get()

    if (last_s == nil or last_s ~= s) and statusbar_highlight_focus then
        mainstatusbar[c:screen_get()]:colors_set({
            bg = bg_sbfocus,
            fg = fg_sbfocus
        })

        if last_s then
            mainstatusbar[last_s]:colors_set({
                bg = bg_normal,
                fg = fg_normal
            })
        end
    end

    last_s = c:screen_get()
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

function hook_manage(c)
    -- Create border
    c:border_set({ 
        width = border_width, 
        color = border_focus 
    })

    -- Add mouse bindings
    -- Alt+Button1: Move window
    c:mouse_add(mouse.new(k_a, 1, function (c) c:mouse_move() end))

    -- Alt+Button3: Resize window
    c:mouse_add(mouse.new(k_a, 3, function (c)
        c:mouse_resize({ corner = 'bottomright' })
    end ))

    -- Make certain windows floating
    local name = c:name_get():lower()
    local class = c:class_get():lower()
    if  class:find('gimp') or
        name:find('urxvtcnotify')
    then
        c:floating_set(true)
    end

    if name:find('urxvtcnotify') then
        -- I got sick of libnotify/notification-daemon
        -- and their dependencies, so I'm using a little
        -- urxvtc window with some text in it as notifications :P
        -- This makes it appear at the correct place,
        -- feel free to remove the whole section, you probably
        -- won't need it.

        c:screen_set(3)
        c:coords_set({
            x = screen.coords_get(3)['x']+1400,
            y = 18,
            width = 276,
            height = 106
        })

        c:border_set({
            width = border_width,
            color = border_normal
        })

        for i,t in pairs(eminent.tags[3]) do
            if eminent.tag.isoccupied(3, t) then
                c:tag(t, true)
            end
        end

        return 0
    end

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
end

function hook_arrange(c)
    -- Warp the mouse
    mouse.warp()
end

-- Attach the hooks
awful.hooks.focus(hook_focus)
awful.hooks.unfocus(hook_unfocus)
awful.hooks.manage(hook_manage)
awful.hooks.mouseover(hook_mouseover)
awful.hooks.arrange(hook_arrange)


-- }}}

-- vim: set filetype=lua fdm=marker tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent nu:
