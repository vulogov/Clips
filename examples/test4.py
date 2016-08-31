import sys
sys.path.append("./build/lib.linux-x86_64-2.6")
import Clips
e = Clips.ENV()
s = e.SHELL()
dl = e.DL()
before = e.USAGE()
dl.WATCH("all")
dl.DL("./clips", "./clips/modules", "modules")
print "Testing ENV.DL():",dl
print "Testing our loaded and registered function"
s.EXEC('(defglobal ?*clock* = (getclock))')
s.EXEC('(printout t "The ?*clock* is: " ?*clock* crlf)')
print "Testing: Passing reference on Python object to CLIPS"
s.EXEC('(defglobal ?*a* = (makeA))')
s.EXEC('(printout t "The ?*a* is: " ?*a* crlf)')
print "Testing: calling function registered from the module passing Python object"
s.EXEC('(printout t (call_a ?*a*) crlf)')
print "Testing: calling function registered from the module passing Python object"
print "Testing inline argument passing functions"
s.EXEC('(printout t (call_b ?*a*) crlf)')
print "Testing getArgument():"
s.EXEC('(print_params 1 42 3.14 (create$ "hello" world ?*a*))')
print "Memory usage before:",before
print "Memory usage after:", e.USAGE()

