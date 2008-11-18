""" User configuration file for IPython """
import os   

import IPython.ipapi
import ipy_defaults    

ip = IPython.ipapi.get()

def main():   
    import ipy_profile_sh
    
    # Default Imports
    import_all("os sys IPython.Extensions.InterpreterExec ipipe")

    # Editor
    import ipy_editors
    
    ipy_editors.install_editor("vim $file")

    # Options
    o = ip.options

    o.autocall = 1
    o.automagic = 1
    o.autoindent = 1
    o.banner = 0

    o.autoedit_syntax = 0

    o.readline = 1

    o.system_verbose = 0

    o.prompts_pad_left = 1

    o.object_info_string_level = 0

    o.xmode = "Context"

    o.multi_line_specials = 1

    o.confirm_exit = 0

    # Prompt
    o.prompt_in1 = r'\C_LightBluegglucas\C_LightGreen:\C_LightPurple\Y5\C_Normal> '
    o.prompt_in2 = r' > '
    o.prompt_out = r'[\#] '
    
    # For sane integer division that converts to float (1/2 == 0.5)
    o.autoexec.append('from __future__ import division')
    
    # For %tasks and %kill
    import jobctrl 
    
    # For autoreloading of modules (%autoreload, %aimport)    
    import ipy_autoreload
    
    # Tab completer that is not quite so picky
    import ipy_greedycompleter
    
    # Readline
    import readline
    readline.parse_and_bind('set completion-query-items 1000')
    readline.parse_and_bind('set page-completions on')
    readline.parse_and_bind('set visible-stats on')

    readline.parse_and_bind('"\C-l" clear-screen')
    readline.parse_and_bind('TAB menu-complete')

    # Aliases
    ip.magic("alias ls ls --color=auto -F")
    ip.magic("alias no ls")
    ip.magic("alias ne ls -la")

    ip.magic("env PAGER=vimpager")
    ip.magic("env EDITOR=vim")

    ip.set_hook("input_prefilter", directcd)

    ip.IP.log = lambda *args: True
    ip.runlines(["!clear"])
    

def directcd(self, cmd):
    """ Hook to autocd to directories. """
    sp = cmd.split(" ")
    nm = sp[0]

    if nm[0] == "!":
        nm = nm[1:]

    if nm[0] != "/":
        nm = os.getcwd()+"/"+nm

    if len(sp) == 1 and os.path.isdir(nm):
        ip.magic("cd "+nm)
        return ""
    else:
        return cmd
    
# Config helper functions
def import_all(modules):
    """ Usage: import_all("os sys") """ 
    for m in modules.split():
        ip.ex("from %s import *" % m)
        
def execf(fname):
    """ Execute a file in user namespace """
    ip.ex('execfile("%s")' % os.path.expanduser(fname))

main()
