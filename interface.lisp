(in-package :feebs)

(defun feeb-name ()
  (feebs-base:feeb-name  *active-feeb*))

(defun set-feeb-name (name)
  (when-let (pl (feebs-base:planet *active-feeb*))
    (when (member name (feebs-base:defined-feebs pl)
                  :key #'feeb-name :test #'string=)
      (error "The Planet already has a feeb with this name."))
    (when (feebs-base:play-is-active pl)
      (error "Cannot change name within an active game!")))
  (setf (feebs-base:feeb-name *active-feeb*) name))

(defun coordinates ()
  (copy-list (feebs-base:thing-coordinates *active-feeb*)))


(defun planet-name ()
  (feebs-base:planet-name  (ensure-planet)))



(defun feeb-peeking ()
  (feebs-base:feeb-peeking *active-feeb*))

(defun feeb-energy ()
  (feebs-base:feeb-energy *active-feeb*))

(defun line-of-sight ()
  (feebs-base:line-of-sight *active-feeb*))

(defun feeb-score ()
  (feebs-base:feeb-score *active-feeb*))

(defun feeb-kills ()
  (feebs-base:feeb-kills *active-feeb*))

(defun feeb-last-move ()
  (feebs-base:feeb-last-move *active-feeb*))

(defun move-aborted-p ()
  (feebs-base:feeb-move-aborted *active-feeb*))

(defun ready-to-fire-p ()
  (feebs-base:ready-to-fire *active-feeb*))


(defun current-square ()
  (feebs-base:current-square *active-feeb*))

(defun rear-square ()
  (feebs-base:rear-square *active-feeb*))

(defun left-square ()
  (feebs-base:left-square *active-feeb*))

(defun right-square ()
  (feebs-base:right-square *active-feeb*))


(defun vision-ahead ()
  (feebs-base:vision-ahead *active-feeb*))

(defun vision-right ()
  (feebs-base:vision-right *active-feeb*))

(defun vision-left ()
  (feebs-base:vision-left *active-feeb*))



(defun get-parm (parm)
  (feebs-base:get-feeb-parm (ensure-planet) parm))

(defun set-parm (parm value)
  (let ((planet (ensure-planet)))
    (if (feebs-base:play-is-active planet)
        (error "Cannot change parameters within an active game!")
        (feebs-base:change-feeb-parm planet parm value))))

(defun feeb-image-p (image)
  (feebs-base:feeb-image-p image))

(defun feeb-image-name (image)
  (feebs-base:feeb-image-name image))

(defun feeb-image-heading (image)
  (feebs-base:feeb-image-heading image))

(defun fireball-image-p (image)
  (feebs-base:fireball-image-p image))

(defun fireball-image-shooter (image)
  (feebs-base:fireball-image-shooter image))

(defun fireball-image-direction (image)
  (feebs-base:fireball-image-direction image))

(defun print-maze ()
  (let ((planet (ensure-planet)))
    (if (feebs-base:play-is-active planet)
        (error "Cannot print-maze within an active game!")
        (feebs-base:print-maze planet))))

(defun print-scoreboard ()
  (let ((planet (ensure-planet)))
    (if (feebs-base:play-is-active planet)
        (error "Cannot print-scorecard within an active game!")
        (feebs-base:print-scoreboard planet))))

(defun test-feeb-brain ()
  (if (feebs-base:play-is-active (ensure-planet))
      (error "Cannot test-feeb-move within an active game!")
      (feebs-base:test-feeb-brain *active-feeb*)))

(defun list-parameter-settings ()
  (mapcar (lambda (x) (list (first x) (second x)))
          (feebs-base:list-parameter-settings (ensure-planet))))

(defun move (move)
  (let ((planet (ensure-planet)))
    (when (feebs-base:play-is-active planet)
      (error "Cannot call move within an active game!"))
    (let ((sv (feebs-base:feeb-special-move *active-feeb*)))
      (setf (feebs-base:feeb-special-move *active-feeb*) move)
      (unwind-protect
           (feebs-base:play-one-cycle planet)
        (setf (feebs-base:feeb-special-move *active-feeb*) sv)))))

(defun play-cycle (&optional (count 1))
  (let ((planet (ensure-planet)))
    (when (feebs-base:play-is-active planet)
      (error "Cannot call play-cycle within an active game!"))
    (dotimes (i count (feebs-base:cycle planet))
      (feebs-base:play-one-cycle planet))))

(defun play-game ()
  (let ((planet (ensure-planet)))
    (when (feebs-base:play-is-active planet)
      (error "Cannot call play-cycle within an active game!"))
    (feebs-base:play planet)
    (feebs-base:cycle planet)))

(defun play-restart ()
  (let ((planet (ensure-planet)))
    (when (feebs-base:play-is-active planet)
      (error "Cannot call play-cycle within an active game!"))
    (feebs-base:initialize-simulation planet)
    (feebs-base:cycle planet)))

(defun maze-layouts ()
  (when (feebs-base:play-is-active (ensure-planet))
    (error "Cannot call maze-layouts within an active game!"))
  (feebs-base::list-maze-names))

(defun change-maze-layout (layout)
  (unless (typep layout 'symbol)
    (error "Parameter layout has to be a symbol!"))
  (let ((planet (ensure-planet)))
    (when (feebs-base:play-is-active planet)
      (error "Cannot call play-cycle within an active game!"))
    (if-let ((new-layout (feebs-base:get-maze layout)))
            (when (feebs-base:load-text-maze planet layout)
              (feebs-base:initialize-simulation planet)
              t)
            (error "Parameter layout has to be a symbol returned by (maze-layouts)!"))))

(defun planet-list ()
  (mapcar #'feebs-base:planet-name *planets*))

(defun planet-feebs (&optional planet-name)
  (if-let ((pl (if planet-name
                   (find planet-name *planets* :key #'planet-name :test #'string=)
                   (ensure-planet))))
    (mapcar #'feebs-base:feeb-name (feebs-base:defined-feebs pl))
    (error "There does not exists a planet with this name: ~a" planet-name)))



(defun planet-create (name &key private)
  (when (feebs-base:planet *active-feeb*)
    (error "Feeb is already a member of a planet. Use (planet-leave) first."))
  (when (member name *planets* :key #'feebs-base:planet-name :test #'string=)
    (error "Already exists a planet with this name: ~a" name))
  (create-planet-with-feeb name *active-feeb* :private private)
  name)

(defun planet-join (name)
  (when (feebs-base:planet *active-feeb*)
    (error "Feeb is already a member of a planet. Use (planet-leave) first."))
  (if-let ((pl (find name *planets* :key #'feebs-base:planet-name :test #'string=)))
    (let ((capacity (feebs-base:planet-capacity pl)))
      (when (feebs-base:planet-private pl)
        (error "Planet ~a is private. You cannot join." name))
      (when (>= (length (feebs-base:defined-feebs pl)) capacity)
        (error "Planet ~a is already at capacity. You cannot join." name))
      (when (member (feebs-base:feeb-name *active-feeb*)
                    (feebs-base:defined-feebs pl)
                    :key #'feeb-name :test #'string=)
        (error "Planet ~a already has a feeb with your name. You cannot join." name))
      (when (>= (length (feebs-base:playing-feebs pl)) capacity)
        (feebs-base:bump-system-feeb pl))
      (setf (feebs-base:planet *active-feeb*) pl)
      (push *active-feeb* (feebs-base:defined-feebs pl))
      (feebs-base:place-feeb-in-maze pl *active-feeb*)
      name)
    (error "There does not exists a planet with this name: ~a" name)))


(defun planet-leave ()
  (let ((planet (ensure-planet)))
    (when (feebs-base:play-is-active planet)
      (error "Cannot leave an active planet!"))
    (feeb-leave-planet planet *active-feeb*)
    t))



(defun publish-brain (closure)
  (let ((planet (ensure-planet)))
    (when (feebs-base:play-is-active planet)
      (error "Cannot publish brain in an active planet!"))
    (unless (feebs-base:feeb-publish *active-feeb*)
      (error "Cannot publish brain!"))
    (funcall (feebs-base:feeb-publish *active-feeb*) *active-feeb* closure)
    t)
  )
