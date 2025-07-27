(use-modules 
  (srfi srfi-64)
  (hello))

(test-begin "harness")

(test-equal "test-hello"
 "hello world\n"
 (hi))

(test-equal "test-named-hello"
 "hello bitch\n"
 (hi "bitch"))

(test-end "harness")
