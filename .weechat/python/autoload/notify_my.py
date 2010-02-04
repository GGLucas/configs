import weechat
import sys
import os

SCRIPT_NAME = "notify"
SCRIPT_AUTHOR = "Lucas de Vries <lucas@tuple-typed.org>"
SCRIPT_VERSION = "1"
SCRIPT_LICENSE = "GPL3"
SCRIPT_DESC = "Call a notification on highlight or private message."

def nt_unload(*args):
    return True

def nt_highlight(*args):
    msg = args[2].replace("&", "&amp;").replace("'","`")
    subj, summ = msg.split("\t")

    os.system("notify-send '{0}' '{1}' &> /dev/null".format(subj, summ))

    return True

if __name__ == "__main__":
    if weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, 
                        SCRIPT_LICENSE, SCRIPT_DESC, "nt_unload", ""):

        weechat.hook_signal("weechat_highlight", "nt_highlight", "")
        #weechat.hook_signal("weechat_pv", "nt_highlight", "")
