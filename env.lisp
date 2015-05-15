(in-package :feebs)

(defparameter *active-feeb* nil)
(defparameter *planets* nil)


(defun make-planet-name (base-name)
  (do* ((n  0 (1+ n))
        (name (format nil "~a-~a" base-name n)
              (format nil "~a-~a" base-name n)))
       ((not (member name *planets* :key #'planet-name :test #'string=))
        name)))

(defun unique-feeb-name-p (name)
  (not (find-if (lambda (pl)
                  (member name (feebs-base:defined-feebs pl)
                          :key #'feeb-name :test #'string=))
                *planets*)))

(defun make-feeb-name (base-name)
  (do* ((n  0 (1+ n))
        (name (format nil "~a-~a" base-name n)
              (format nil "~a-~a" base-name n)))
       ((unique-feeb-name-p name)
        name)))

(defun create-planet-with-feeb (planet-name feeb &key private)
  (let ((pl (make-instance 'feebs-base:planet
                           :name planet-name :private private)))
    (setf (feebs-base:planet feeb) pl)
    (push feeb (feebs-base:defined-feebs pl))
    (feebs-base:initialize-simulation pl)
    (push pl *planets*)
    pl))

(defun feeb-leave-planet (planet feeb)
  (feebs-base:remove-feeb planet feeb)
  (when (= 0 (length (feebs-base:defined-feebs planet)))
    (removef *planets* planet)))

(defun ensure-planet ()
  (let ((pl (feebs-base:planet *active-feeb*)))
    (if (typep pl 'feebs-base:planet)
        pl
        (error "Feeb is not a member of a planet!"))))


(defun feeb-heading ()
  (feebs-base:thing-heading *active-feeb*))


