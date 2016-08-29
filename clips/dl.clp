;;
;; This is necessary templates for the dynamic libraryes load
;;

(deftemplate DYNPATH
    (slot path)
    (slot desc)
)

(deftemplate DYNMOD
    (slot name)
    (slot path)
    (slot handle)
    (slot desc)
)


(deftemplate FUN
    (slot name)
    (slot sym)
    (slot module)
    (slot params
        (type STRING)
        (default "")
    )
    (slot retvalue)
    (slot handle)
    (slot desc)
)

(defrule eliminate-bad-path
    ?dpath <- (DYNPATH (path ?path))
    (test (not (is_dir ?path)))
=>
    ; (printout t ?path " is not a directory" crlf)
    (retract ?dpath)
)

(defrule eliminate-module-without-definition
    ?dpath <- (DYNPATH (path ?path))
    (test (not (is_file (str-cat ?path "/init.clp"))))
=>
    ; (printout t ?path " do not have init module" crlf)
    (retract ?dpath)
)

(defrule load-the-module
    ?dpath <- (DYNPATH (path ?path))
    (test (is_file (str-cat ?path "/init.clp")))
=>
    (load (str-cat ?path "/init.clp"))
)

(defrule eliminate-non-existing-modules
    ?dmod <- (DYNMOD (path ?path) (name ?name))
    (or
        (not (test (is_dir ?path)))
        (not (test (is_file (str-cat ?path "/" ?name ".so"))))
    )
=>
    ; (printout t (str-cat ?path "/" ?name ".so") " not exists" crlf)
    (retract ?dmod)
)

(defrule open-the-dynamic-module
    ?dmod <- (DYNMOD (path ?path) (name ?name) (handle nil))
    (and
        (test (is_dir ?path))
        (test (is_file (str-cat ?path "/" ?name ".so")))
    )
=>
    ; (printout t "Preparing " (str-cat ?path "/" ?name ".so") " opening" crlf)
    (modify ?dmod
        (handle (dl ?name (str-cat ?path "/" ?name ".so")))
    )
)

(defrule locate-function
    ?fun <- (FUN
        (name ?name)
        (module ?modname)
        (sym ?sym)
        (params ?params)
        (retvalue ?retvalue)
        (handle nil)
    )
    (DYNMOD
        (name ?modname)
        (handle ?modhandle&~nil)
    )
=>
    ; (printout t "Locating " ?name crlf)
    (modify ?fun
        (handle (dlsym ?modhandle ?sym))
    )
)

(defrule register-function
    ?fun <- (FUN
        (name ?name)
        (module ?modname)
        (sym ?sym)
        (params ?params)
        (retvalue ?retvalue)
        (handle ?funhandle&~nil)
    )
    (DYNMOD
        (name ?modname)
        (handle ?modhandle&~nil)
    )
=>
    ; (printout t "Registering " ?name " " ?funhandle " " ?modhandle crlf)
    (dlregister ?funhandle ?name ?params ?retvalue)
)

