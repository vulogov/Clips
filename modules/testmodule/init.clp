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
    (FUN
        (name "call_b")
        (sym  "call_b")
        (module "testmod")
        (retvalue "a")
        (params "a")
    )
    (FUN
        (name "print_params")
        (sym  "print_params")
        (module "testmod")
        (retvalue "a")
        (params "sidm")
    )
)


