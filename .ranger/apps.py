from ranger.defaults.apps import CustomApplications as DefaultApps
from ranger.api.apps import *

class CustomApplications(DefaultApps):
    def app_zathura(self, c):
        c.flags += 'd'
        return tup('zathura', *c)

    def app_comix(self, c):
        c.flags += 'd'
        return tup('comix', *c)

    def app_default(self, c):
        f = c.file

        if f.extension in ('pdf'):
            return self.app_zathura(c)

        if f.extension in ('cbr', 'cbz'):
            return self.app_comix(c)

        return DefaultApps.app_default(self, c)
