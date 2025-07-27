(define-module (hello))

(define GREETING_PREFIX "hello")
(define GREETING_SUFFIX "\n")
(define DEFAULT_ADDRESSEE "world")

(define-public hi
  (lambda* (#:optional name) 
           (string-append GREETING_PREFIX " " (addressee name) GREETING_SUFFIX)))

(define addressee (lambda (name) (if name name DEFAULT_ADDRESSEE)))
(display "hello\n")
