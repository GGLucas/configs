from ranger.api.commands import *

# Tag only this file, watch it and mark it watched
class WatchMark(Command):
    def execute(self):
        cwd = self.fm.env.cwd
        sel = cwd.get_selection()

        self.fm.tag_toggle(cwd.filenames, False);
        self.fm.tag_toggle([x.path for x in sel], True);

        self.fm.run(app='watchmark', files=sel);

# Tag only this file, watch it
class MarkOnly(Command):
    def execute(self):
        cwd = self.fm.env.cwd
        sel = cwd.get_selection()

        self.fm.tag_toggle(cwd.filenames, False);
        self.fm.tag_toggle([x.path for x in sel], True);

        self.fm.run(app='mplayer', files=sel);
