(defpackage :feebs-system
  (:use :cl :asdf))

(in-package :feebs-system)

(defsystem feebs
  :description "Planet of the Feebs - Arvid Version."
  :version "0.1"
  :author "Andy Peterson <andy.arvid@gmail.com>"
  :license "none - public domain"
  :depends-on (#:alexandria)        
  :components
   ((:cl-source-file "package")
    (:cl-source-file "maze-layouts"  :depends-on ("package"))
    (:cl-source-file "parameters"  :depends-on ("package"))
    (:cl-source-file "planet"  :depends-on ("package" "maze-layouts" "parameters"))
    (:cl-source-file "things"  :depends-on ("package" "planet"))
    (:cl-source-file "vision"  :depends-on ("package" "planet" "things"))
    (:cl-source-file "print"  :depends-on ("package" "planet"))
    (:cl-source-file "history" :depends-on ("package" "planet" "things"))
    (:cl-source-file "env"
     :depends-on ("package" "planet" "things" "vision" "print"))
    (:cl-source-file "play"
     :depends-on ("package" "planet" "things" "vision" "env" "history"))
    (:cl-source-file "interface"
     :depends-on ("package" "env" "play"))))

