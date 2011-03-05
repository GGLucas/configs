# -*- coding:UTF -*-
#
# Copyright (c) 2009 by Yoann512 <yoann512@meeow.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# RSS aggregator for WeeChat.


import weechat
try:
    import feedparser
    import_ok = True
except:
    weechat.prnt(weechat.buffer_search_main(), "python-feedparser must be installed")
    import_ok = False
    
weechat.register("RSS", "Yoann512", "0.01", "GPL3", "RSS aggregator", "rss_shutdown", "")
weechat.hook_command(
                        "rss",
                        "RSS aggregator",
                        "",
                        "       set the delay between check (in ms) : /set plugins.var.python.rss.refresh_delay 300000\n"
                        "       set RSS flux (separated by a space) : /set plugins.var.python.rss.feed \"http://feed1.xml http://feed2.php ...\"\n"
                        "       display RSS news in weechat buffer : /set plugins.var.python.rss.display_weechat_buffer [on|off]\n"
                        "       display RSS news in current buffer : /set plugins.var.python.rss.display_current_buffer [on|off]\n",
                        "",
                        "",
                        "",
                    )

feed_list = ['']
feed_last = {}

def rss_shutdown():
    return weechat.WEECHAT_RC_OK


def rss_refresh_feed(data, remaining_calls):
    global feed_list, feed_last
    if feed_list == ['']:
        weechat.prnt(weechat.buffer_search_main(), "please set some feed : /set plugins.var.python.rss.feed \"http://feed1.xml http://feed2.php ...\"")
        return weechat.WEECHAT_RC_OK
    for feedname in feed_list:
        feed = feedparser.parse(feedname)
        if feedname in feed_last:
            if feed['items'][0]['link'] != feed_last[feedname]:
                for item in feed['items']:
                    if item['link'] == feed_last[feedname]:
                        feed_last[feedname] = feed['items'][0]['link']
                        break
                    else:
                        buf = weechat.info_get("irc_buffer", "slacked,#starruler");
                        weechat.prnt(buf, "%sForum\t%s%s" % (weechat.color("yellow,magenta"), weechat.color("red,black"), item['link']))
                else:
                    feed_last[feedname] = feed['items'][0]['link']
            else:
                feed_last[feedname] = feed['items'][0]['link']
        else:
            feed_last[feedname] = feed['items'][0]['link']
    return weechat.WEECHAT_RC_OK

def rss_config(data, config, value):
    global feed_list, feed_last
    if config == "plugins.var.python.rss.refresh_delay":
        weechat.hook_timer(int(value), 0, 0, 'rss_refresh_feed', '')
    elif config == "plugins.var.python.rss.feed":
        feed_list = value.split(" ")
    return weechat.WEECHAT_RC_OK
    
if import_ok:
    if weechat.config_get_plugin('refresh_delay') == "":
        weechat.config_set_plugin('refresh_delay', "300000")
    if weechat.config_get_plugin('feed') == "":
        weechat.config_set_plugin('feed', "")
    else:
        feed_list = weechat.config_get_plugin('feed').split(" ")
    weechat.config_set_plugin('display_weechat_buffer', "on")
    weechat.config_set_plugin('display_current_buffer', "on")
    weechat.hook_config('plugins.var.python.rss.*', 'rss_config', "")
    weechat.hook_timer(int(weechat.config_get_plugin('refresh_delay')), 0, 0, 'rss_refresh_feed', '')
