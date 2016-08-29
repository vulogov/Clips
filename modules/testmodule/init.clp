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
)


