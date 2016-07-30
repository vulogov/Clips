##
## Building CLIPS-PY Cython module
##

import os
import re
from glob import glob
from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

CLIPSPY_MAJOR="0"
CLIPSPY_MINOR="1"
CLIPSPY_VERSION="%s.%s"%(CLIPSPY_MAJOR, CLIPSPY_MINOR)


########### Internal functions and aliases   #####################

_p = os.path.join
# This retrieves the CLIPS version looking up headers
def get_clips_version(fn):
    li = open(fn).readlines()
    cre = re.compile(r"\#define\ VERSION_STRING\ \"([0-9]+\.[0-9]+)\"")
    vno = "unknown"
    for s in li:
        f = cre.search(s)
        if f:
            vno = f.groups(1)
            break
    return "%s" % vno


############ Build process ####################

ClipsLIB_dir = _p('.', 'clipssrc')
clips_version = get_clips_version(_p("clipssrc", "constant.h"))
print "Found CLIPS version: %s" % clips_version
maj, min = clips_version.split('.', 1)

TO_REMOVE = [
    'main.c',
    'userfunctions.c',
    ]

all_clipssrc = glob(_p(ClipsLIB_dir, '*.c'))
main_clipssrc = ['clipsmodule.c', 'clips_or.c']
for x in all_clipssrc:
    if os.path.basename(x) in TO_REMOVE:
        all_clipssrc.remove(x)
print len(all_clipssrc),"CLIPS files to compile"

CFLAGS = [
    '-DCLIPSPY',
    '-DCLIPS_MAJOR=%s' % maj,
    '-DCLIPS_MINOR=%s' % min,
    '-DPYCLIPS_MAJOR=%s' % CLIPSPY_MAJOR,
    '-DPYCLIPS_MINOR=%s' % CLIPSPY_MINOR,
    ]

setup(name="Clips",
      version="%s-clips_%s" % (CLIPSPY_VERSION, clips_version),
      ext_modules = cythonize([Extension("Clips",
                    ["src/Clips.pyx","src/clipsenv.c"]+all_clipssrc,
                    extra_compile_args=CFLAGS,
                    include_dirs=[ClipsLIB_dir]
                    )]
      )
)