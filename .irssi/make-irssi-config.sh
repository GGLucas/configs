#!/bin/sh -- 

CONF=~/.irssi/config

if [[ -f $CONF ]]; then
   mv -f $CONF ${CONF}.old
fi
echo -n > $CONF

(
   echo "servers = ("
   echo "  { address = 'irc.stealth.net'; chatnet = 'IRCNet'; port = '6668'; },"
   echo "  { address = 'irc.efnet.net'; chatnet = 'EFNet'; port = '6667'; },"
   echo "  { "
   echo "    address = 'irc.undernet.org';"
   echo "    chatnet = 'Undernet';"
   echo "    port = '6667';"
   echo "  },"
   echo "  { address = 'irc.dal.net'; chatnet = 'DALnet'; port = '6667'; },"
   echo "  { address = 'irc.openprojects.net'; chatnet = 'OPN'; port = '6667'; },"
   echo "  { address = 'irc.gnome.org'; chatnet = 'GIMPNet'; port = '6667'; },"
   echo "  { address = 'irc.ptlink.net'; chatnet = 'PTlink'; port = '6667'; },"
   echo "  { address = 'silc.pspt.fi'; chatnet = 'SILC'; port = '706'; }"
) >> $CONF

declare -a tags

echo -n "Enter new server (e.g. kern.srcf.ucam.org) (blank for none): "
read server
i=0;
while [[ "" != "$server" ]]; do
   echo ", { address = '$server';" >> $CONF
   echo -n "Enter short tag (e.g. kern): "
   read tag
   tags[$((i++))]=$tag;
   echo "   chatnet = '$tag'; port = '6667'; autoconnect = 'yes'" >> $CONF
   echo -n "Enter nick: "
   read nick
   echo " nick = '$nick'; }" >> $CONF
   echo -n "Enter new server (e.g. kern.srcf.ucam.org) (blank for none): "
   read server
done

(
   echo ');'
   echo ''
   echo 'chatnets = {'
   echo '  IRCNet = {'
   echo '    type = "IRC";'
   echo '    max_kicks = "4";'
   echo '    max_modes = "3";'
   echo '    max_msgs = "5";'
   echo '    max_whois = "4";'
   echo '    max_query_chans = "5";'
   echo '  };'
   echo '  EFNet = { '
   echo '    type = "IRC";'
   echo '    max_kicks = "4";'
   echo '    max_modes = "4";'
   echo '    max_msgs = "3";'
   echo '  };'
   echo '  Undernet = {'
   echo '    type = "IRC";'
   echo '    max_kicks = "4";'
   echo '    max_modes = "3";'
   echo '    max_msgs = "3";'
   echo '  };'
   echo '  DALNet = { '
   echo '    type = "IRC";'
   echo '    max_kicks = "4";'
   echo '    max_modes = "6";'
   echo '    max_msgs = "3";'
   echo '  };'
   echo '  OPN = { type = "IRC"; max_kicks = "4"; max_modes = "4"; max_msgs = "1"; };'
   echo '  GIMPNet = {'
   echo '    type = "IRC";'
   echo '    max_kicks = "4";'
   echo '    max_modes = "4";'
   echo '    max_msgs = "3";'
   echo '  };'
   echo '  PTLink = {'
   echo '    type = "IRC";'
   echo '    max_kicks = "1";'
   echo '    max_modes = "6";'
   echo '    max_msgs = "100";'
   echo '  };'
   echo '  SILC = { type = "SILC"; };'
) >> $CONF

i=0
while [[ "${tags[$i]}" != "" ]]; do  
  echo "${tags[$((i++))]} = { type = 'IRC'; };" >> $CONF
done

(
   echo '};'
   echo ''
   echo 'channels = ('
) >> $CONF

echo -n "Enter new channel (e.g. #srcf) (blank for none): "
read channel
while [[ "" != $channel ]]; do
   echo -n "Enter server tag (e.g. kern): "
   read tag
   echo "{ name = '$channel'; chatnet = '$tag'; autojoin = 'Yes'; }," >> $CONF
   echo -n "Enter new channel (e.g. #srcf) (blank for none): "
   read channel
done

(
   echo ''
   echo ');'
   echo ''
   echo 'aliases = {'
   echo '  J = "join";'
   echo '  WJOIN = "join -window";'
   echo '  WQUERY = "query -window";'
   echo '  LEAVE = "part";'
   echo '  BYE = "quit";'
   echo '  EXIT = "quit";'
   echo '  SIGNOFF = "quit";'
   echo '  DESCRIBE = "action";'
   echo '  DATE = "time";'
   echo '  HOST = "userhost";'
   echo '  LAST = "lastlog";'
   echo '  SAY = "msg *";'
   echo '  WI = "whois";'
   echo '  WII = "whois $0 $0";'
   echo '  WW = "whowas";'
   echo '  W = "who";'
   echo '  N = "names";'
   echo '  M = "msg";'
   echo '  T = "topic";'
   echo '  C = "clear";'
   echo '  CL = "clear";'
   echo '  K = "kick";'
   echo '  KB = "kickban";'
   echo '  KN = "knockout";'
   echo '  BANS = "ban";'
   echo '  B = "ban";'
   echo '  MUB = "unban *";'
   echo '  UB = "unban";'
   echo '  IG = "ignore";'
   echo '  UNIG = "unignore";'
   echo '  SB = "scrollback";'
   echo '  UMODE = "mode $N";'
   echo '  WC = "window close";'
   echo '  WN = "window new hide";'
   echo '  SV = "say Irssi $J ($V) - http://irssi.org/";'
   echo '  GOTO = "sb goto";'
   echo '  CHAT = "dcc chat";'
   echo '  RUN = "SCRIPT LOAD";'
   echo '  SBAR = "STATUSBAR";'
   echo '  INVITELIST = "mode $C +I";'
   echo '};'
   echo ''
   echo 'statusbar = {'
   echo '  # formats:'
   echo '  # when using {templates}, the template is shown only if it's argument isn't'
   echo '  # empty unless no argument is given. for example {sb} is printed always,'
   echo '  # but {sb $T} is printed only if $T isnt empty.'
   echo ''
   echo '  items = {'
   echo '    # start/end text in statusbars'
   echo '    barstart = "{sbstart}";'
   echo '    barend = "{sbend}";'
   echo ''
   echo '    # treated "normally", you could change the time/user name to whatever'
   echo '    time = "{sb $Z}";'
   echo '    user = "{sb $cumode$N{sbmode $usermode}{sbaway $A}}";'
   echo ''
   echo '    # treated specially .. window is printed with non-empty windows,'
   echo '    # window_empty is printed with empty windows'
   echo '    window = "{sb $winref:$T{sbmode $M}}";'
   echo '    window_empty = "{sb $winref{sbservertag $tag}}";'
   echo '    prompt = "{prompt $[.15]T}";'
   echo '    prompt_empty = "{prompt $winname}";'
   echo '    topic = " $topic";'
   echo '    topic_empty = " Irssi v$J - http://irssi.org/help/";'
   echo ''
   echo '    # all of these treated specially, theyre only displayed when needed'
   echo '    lag = "{sb Lag: $0-}";'
   echo '    act = "{sb Act: $0-}";'
   echo '    more = "-- more --";'
   echo '  };'
   echo ''
   echo '  # theres two type of statusbars. root statusbars are either at the top'
   echo '  # of the screen or at the bottom of the screen. window statusbars are at'
   echo '  # the top/bottom of each split window in screen.'
   echo '  default = {'
   echo '    # the "default statusbar" to be displayed at the bottom of the window.'
   echo '    # contains all the normal items.'
   echo '    window = {'
   echo '      disabled = "no";'
   echo ''
   echo '      # window, root'
   echo '      type = "window";'
   echo '      # top, bottom'
   echo '      placement = "bottom";'
   echo '      # number'
   echo '      position = "1";'
   echo '      # active, inactive, always'
   echo '      visible = "active";'
   echo ''
   echo '      # list of items in statusbar in the display order'
   echo '      items = {'
   echo '        barstart = { priority = "100"; };'
   echo '        time = { };'
   echo '        user = { };'
   echo '        window = { };'
   echo '        window_empty = { };'
   echo '        lag = { priority = "-1"; };'
   echo '        act = { priority = "10"; };'
   echo '        more = { priority = "-1"; alignment = "right"; };'
   echo '        barend = { priority = "100"; alignment = "right"; };'
   echo '      };'
   echo '    };'
   echo ''
   echo '    # statusbar to use in inactive split windows'
   echo '    window_inact = {'
   echo '      type = "window";'
   echo '      placement = "bottom";'
   echo '      position = "1";'
   echo '      visible = "inactive";'
   echo '      items = {'
   echo '        barstart = { priority = "100"; };'
   echo '        window = { };'
   echo '        window_empty = { };'
   echo '        more = { priority = "-1"; alignment = "right"; };'
   echo '        barend = { priority = "100"; alignment = "right"; };'
   echo '      };'
   echo '    };'
   echo ''
   echo '    # we treat input line as yet another statusbar :) Its possible to'
   echo '    # add other items before or after the input line item.'
   echo '    prompt = {'
   echo '      type = "root";'
   echo '      placement = "bottom";'
   echo '      # we want to be at the bottom always'
   echo '      position = "100";'
   echo '      visible = "always";'
   echo '      items = {'
   echo '        prompt = { priority = "-1"; };'
   echo '        prompt_empty = { priority = "-1"; };'
   echo '        # treated specially, this is the real input line.'
   echo '        input = { priority = "10"; };'
   echo '      };'
   echo '    };'
   echo ''
   echo '    # topicbar'
   echo '    topic = {'
   echo '      type = "root";'
   echo '      placement = "top";'
   echo '      position = "1";'
   echo '      visible = "always";'
   echo '      items = {'
   echo '        barstart = { priority = "100"; };'
   echo '        topic = { };'
   echo '        topic_empty = { };'
   echo '        barend = { priority = "100"; alignment = "right"; };'
   echo '      };'
   echo '    };'
   echo '  };'
   echo '};'
   echo 'settings = {'
   echo '  core = {'
) >> $CONF 

echo  -n "Enter real name: "
read name
echo -n "Enter username: "
read user
echo -n "Enable logging [yes/no]? "
read log

(
   echo "real_name = '$name';"
   echo "user_name = '$user';"
   echo "nick = '$user';"
   echo ''
   echo '  };'
   echo '  "fe-common/core" = {'
   echo "autolog = '$log';"
   echo '    autolog_path = "~/irclogs/$tag/$0-%m%y.log";'
   echo '    show_nickmode_empty = "yes";'
   echo '    theme = "default";'
   echo '  };'
   echo '  "fe-text" = { colors = "yes"; autostick_split_windows = "yes"; };'
   echo '};'
   echo 'logs = { };'
   echo 'ignores = ( );'
   echo 'keyboard = ('
   echo '  { key = "meta-1"; id = "change_window"; data = "1"; },'
   echo '  { key = "meta-2"; id = "change_window"; data = "2"; },'
   echo '  { key = "meta-3"; id = "change_window"; data = "3"; },'
   echo '  { key = "meta-4"; id = "change_window"; data = "4"; },'
   echo '  { key = "meta-5"; id = "change_window"; data = "5"; },'
   echo '  { key = "meta-6"; id = "change_window"; data = "6"; },'
   echo '  { key = "meta-7"; id = "change_window"; data = "7"; },'
   echo '  { key = "meta-8"; id = "change_window"; data = "8"; },'
   echo '  { key = "meta-9"; id = "change_window"; data = "9"; },'
   echo '  { key = "meta-0"; id = "change_window"; data = "10"; },'
   echo ');'
   echo '   '
   echo 'windows = {'
   echo '  1 = { immortal = "yes"; name = "(status)"; level = "ALL"; };'
   echo '};'
   echo 'mainwindows = { 1 = { first_line = "1"; lines = "52"; }; };'
   echo ')'
) >> $CONF

echo "All Done. Start IRSSI and it should connect to everything automatically. Once you have moved things into the correct place (with /window move), then you can use /layout save to remember it for next time."
