;;
;; This is test module
;;

(deffacts TESTMODULEMODS
    (DYNMOD (name "testmod") (path "./modules/testmodule"))
    (DYNMOD (name "module_not_exists") (path "./modules/testmodule"))
)

(deffacts TESTMODULEFUNS
    (FUN
        (name "getclock")
        (module "testmod")
        (sym "get_clock")
        (retvalue "d")
    )
    (FUN
        (name "makeA")
        (sym  "make_class")
        (module "testmod")
        (retvalue "a")
    )
    (FUN
        (name "call_a")
        (sym  "call_a")
        (module "testmod")
        (retvalue "a")
        (params "a")
    )
)


