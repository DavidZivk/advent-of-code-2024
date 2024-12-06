(require "asdf")
(ql:quickload "str")

(defun sum-differences ()
  (let* ((lines (uiop:read-file-lines "day1-input.txt"))
         (lefts (sort (mapcar (lambda (x) (parse-integer (car (str:split "   " x)))) lines) #'<))
         (rights (sort (mapcar (lambda (x) (parse-integer (car (cdr (str:split "   " x))))) lines) #'<)))
    (reduce #'+ (loop for left in lefts for right in rights collect (abs (- left right))))))

(format t "~A~%" (sum-differences))
