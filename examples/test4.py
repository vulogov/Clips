import sys
sys.path.append("./build/lib.linux-x86_64-2.6")
import Clips
e = Clips.ENV()
s = e.SHELL()
dl = e.DL()
dl.WATCH("all")
dl.DL("./clips", "./clips/modules", "modules")
print "Testing ENV.DL():",dl
print "Testing our loaded and registered function"
s.EXEC('(defglobal ?*clock* = (getclock))')
s.EXEC('(printout t "The ?*clock* is: " ?*clock* crlf)')
print "Testing: Passing reference on Python object to CLIPS"
s.EXEC('(defglobal ?*a* = (makeA))')
s.EXEC('(printout t "The ?*a* is: " ?*a* crlf)')
s.EXEC('(printout t (call_a ?*a*) crlf)')


