__author__ = 'Vladimir Ulogov'
import sys
sys.path.append("./build/lib.linux-x86_64-2.6")
import Clips
e = Clips.ENV()
s = e.SHELL()
print 'EVAL: (dl testmod ...)'
s.EXEC('(defglobal ?*handle* = (dl "testmod" "modules/testmodule/build/lib.linux-x86_64-2.6/testmod.so"))')
print "This is library handle"
s.EXEC('(printout t ?*handle* crlf)')
s.EXEC('(defglobal ?*fun* = (dlsym ?*handle* "get_clock"))')
print "This is the function address"
s.EXEC('(printout t ?*fun* crlf)')
print "Registering function (getclock ...) from dynamic library",
print s.EVAL('(dlregister ?*fun* "getclock" "" "d")')
print "Registering function (rtn_args...) from dynamic library",
s.EXEC('(defglobal ?*fun2* = (dlsym ?*handle* "get_number_of_params"))')
print s.EVAL('(dlregister ?*fun2* "rtn_args" "snn" "d")')
print "EVAL: (getclock)",s.EVAL('(getclock)')
print "Value from the Python into CLIPS context"
s.EXEC('(defglobal ?*clock* = (getclock))')
s.EXEC('(printout t "The ?*clock* is: " ?*clock* crlf)')
s.EXEC('(printout t "# params:"  crlf)')
s.EXEC('(printout t (rtn_args "boo" 3.14 42) crlf)')
print 'EVAL: (dlclose ...)',s.EVAL('(dlclose ?*handle*)')

