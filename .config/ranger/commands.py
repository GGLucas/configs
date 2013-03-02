from ranger.api.commands import *

# Tag only this file, watch it and mark it watched
class WatchMark(Command):
    def execute(self):
        cwd = self.fm.env.cwd
        sel = cwd.get_selection()

        self.fm.tag_toggle(cwd.filenames, False);
        self.fm.tag_toggle(sel[-1].path, True);

        self.fm.run(['watchmark']+[x.path for x in sel]);

# Tag only this file, watch it
class MarkOnly(Command):
    def execute(self):
        cwd = self.fm.env.cwd
        sel = cwd.get_selection()

        self.fm.tag_toggle(cwd.filenames, False);
        self.fm.tag_toggle(sel[-1].path, True);

        self.fm.run(['mplayer']+[x.path for x in sel]);
