(use-modules 
  (srfi srfi-64)
  (hello))

(test-begin "harness")

(test-equal "test-hello"
 "hello world\n"
 (hi))

(test-equal "test-named-hello"
 "hello nice person\n"
 (hi "nice person"))

(test-end "harness")
