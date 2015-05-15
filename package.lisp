
;;; based on Planet of the Feebs (no license)

;;; About Planet of the Feebs:
;; Designed by Scott Fahlman
;; Written by Skef Wholey.
;; Modified by Scott Fahlman.
;; Modified by Dan Kuokka.
;; Modified by Jim Healy.
;;
;; also using ideas from The Feebs War  Gustavo Henrique Milaré GPLv3

(in-package :cl-user)

(defpackage  :feebs-base
  (:use :common-lisp
        :alexandria)
  (:export
   ;; parameters.lisp
   #:list-universe-parameter-settings
   ;; planet.lisp
   #:planet
   #:cycle
   #:game-number
   #:game-zero-timestamp
   #:maze-layout
   #:playing-feebs
   #:fireballs
   #:carcasses
   #:get-feeb-parm
   #:change-feeb-parm
   #:planet-archives
   #:archives
   #:planet-name
   #:defined-feebs
   #:play-is-active
   #:list-parameter-settings
   #:load-text-maze
   #:planet-capacity
   #:planet-private
   ;; things.lisp
   #:feeb
   #:make-feeb
   #:feeb-lisp-env
   #:thing-coordinates
   #:thing-heading
   #:thing-id
   #:feeb-name
   #:deadp
   #:planet-mushrooms
   #:feeb-energy
   #:feeb-score
   #:feeb-kills
   #:feeb-deaths
   #:remove-feeb
   #:feeb-peeking
   #:ready-to-fire
   #:current-square
   #:rear-square
   #:left-square
   #:right-square
   #:vision-ahead
   #:vision-right
   #:vision-left
   #:feeb-special-move
   #:bump-system-feeb
   #:place-feeb-in-maze
   #:line-of-sight
   #:feeb-last-move
   #:feeb-move-aborted
   ;;vision.lisp
   #:forward-dx
   #:forward-dy
   #:feeb-image-p
   #:feeb-image-name
   #:feeb-image-heading
   #:fireball-image-p
   #:fireball-image-shooter
   #:fireball-image-direction
   ;; print.lisp
   #:print-maze
   #:print-scoreboard
   
   #:*active-feeb*
   #:*planets*
   #:make-planet-name
   #:unique-feeb-name-p
   #:make-feeb-name
   #:feeb-leave-planet
   #:create-planet-with-feeb
   ;; maze-layouts.lisp
   #:*maze-layouts*
   #:get-maze
   #:list-maze-names
   ;; play.lisp
   #:initialize-simulation
   #:play
   #:test-feeb-brain
   #:play-one-cycle
   ;; history.lisp
   #:playing-feebs->alist
   ))


(defpackage  :feebs
  (:use :common-lisp
        :alexandria)
  (:export
   #:feeb-name
   #:ready-to-fire
   ))


