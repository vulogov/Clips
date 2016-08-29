import sys
sys.path.append("./build/lib.linux-x86_64-2.6")
import Clips
e = Clips.ENV()
e.UNWATCH("all")
print "Testing ENV()",e
print "Testing ENV().isReady()",e.isReady()
s = e.SHELL()
print "Testing ENV().CLEAR()",e.CLEAR()
print "Testing ENV().LOAD()",e.LOAD("clips/dl.clp")
print "Testing ENV().LOAD()",e.LOAD("clips/modules/modules.clp")

print 'Testing is_dir("/etc"):',s.EVAL('(is_dir "/etc")')
print 'Testing is_dir("/no_such_dir"):',s.EVAL('(is_dir "/no_such_dir")')
print 'Testing is_file("/etc/passwd"):',s.EVAL('(is_file "/etc/passwd")')
print 'Testing is_file("/etc/no_such_file"):',s.EVAL('(is_file "/etc/no_such_dir")')
e.RESET()
s.RUN()
e.RESET()
s.RUN()

print "Testing our loaded and registered function"

s.EXEC('(defglobal ?*clock* = (getclock))')
s.EXEC('(printout t "The ?*clock* is: " ?*clock* crlf)')
