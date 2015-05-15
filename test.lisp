(in-package :smackfeebs)


(defvar pl (make-instance 'planet))

(defvar andy  (make-feeb  pl "andy" ))

(defvar arvid (make-instance 'feeb
                             :name "arvid"))

(defun transport-feeb (feeb x y)
  (let ((maze (planet-maze (planet feeb)))
        (x0 (car (thing-coordinates feeb )))
        (y0 (cdr (thing-coordinates feeb ))))
    (when (and (<= 0 x)
               (< x (array-dimension maze 0))
               (<= 0 y)
               (< y (array-dimension maze 1))
               (not (member :rock (aref maze x y))))
      (removef (aref maze x0 y0) feeb)
      (push feeb (aref maze x y))
      (setf (thing-coordinates feeb ) (cons x y)))))


(defun show-feeb-errors (pl)
  (let ((l nil))
    (dolist (f (playing-feebs pl))
      (when (eq :error (feeb-last-move f))
        (push f l)))
    (when l
      (format t "Errors: ~a~%" l))
    l))
(defun play-print (pl)
  (play-one-cycle pl)
  (show-feeb-errors pl)
  (print-maze pl)
  )


(initialize-simulation pl)

(defun kill-random-feebs (pl ratio)
  (dolist (f (playing-feebs pl))
    (when (and (not (deadp f))
               (planet-chance pl ratio))
      (kill-feeb f))))

(defun shoot-fireball (feeb)
  (push (make-instance 'fireball :planet (planet feeb)
                       :shooter feeb
                       :heading (thing-heading feeb)
                       :coordinates (thing-coordinates feeb))
        (fireballs (planet feeb))))

(defun survival-probabilities (ratio)
  (do* ((i 1 (incf i))
        (l nil (push p l))
        (p  (expt (- 1 ratio) i)
            (expt (- 1 ratio) i)))
       ((or (>= i 100)
            (<= p 1/100))
        (mapcar (lambda (n) (round (* 100 n))) (reverse l)))))

(defun chance ( ratio)
  (< (random  (denominator ratio))
     (numerator ratio)))

(defun survival-distribution (ratio &optional (times 100))
  (let ((v (make-array 100 :initial-element 0 :adjustable t)))
   (dotimes (i times)
     (do ((n 0 (1+ n)))
         ((chance ratio)
          (when (>= n (array-dimension v 0))
            (adjust-array v (1+ n) :initial-element 0))
          (incf (aref v n)))))
    (do ()
        ((< 0 (aref v (1- (array-dimension v 0)))))
      (adjust-array v (1- (array-dimension v 0))))
    v))

(defun test-gauss (planet mu sigma min max times)
  (let ((v (make-array (1+ (- max min)) :initial-element 0 :adjustable t)))
   (dotimes (i times)
     (incf (aref v (- (round (planet-gaussian-random planet mu sigma min max))
                      min))))
    v))


#|(defun repl ()
  (princ "> ")
  (loop 
    (shiftf /// // /
            (multiple-value-list (eval (setf - (read)))))
    (shiftf +++ ++ + -)
    (shiftf *** ** * (car /))
    (format t "~{~a~%~}>" /)))|#

(defun feeb-load (feeb file)
  (let ((smacklisp::*smack-symbols* (feeb-lisp-env feeb)))
    (smacklisp::load-file file)))

#|(defun planet-mushrooms (planet)
  (let ((shrooms nil))
    (dolist (s (mushroom-sites planet) shrooms)
      (appendf shrooms
               (remove-if-not #'mushroomp  (aref (planet-maze planet)
                                                 (car s)
                                                 (cdr s)))))))|#


(let (once)
  (remove-if (lambda (x)
               (and (eq x 'g)
                    (or once (and (setf once t) nil))))
             '(a b h g g k l o p g b b b)))

(remove-duplicates '(a b h g g k l o p g b b b)
                   :from-end t
                   :test (lambda (x y) (and (eq x 'g) (eq y 'g))))

(defun my-remove-duplicates (filter list)
  (let (once)
    (remove-if (lambda (x)
                 (and (member x filter)
                      (or (member x once) (and (push x once) nil))))
               list)))

(defun my-remove-duplicates (filter list)
  (remove-duplicates list
                     :from-end t
                     :test (lambda (x y) (and (eq x y) (member x filter)))))
