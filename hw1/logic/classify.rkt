#lang rosette
(require rackunit)

(provide (all-defined-out))

; Takes as input a propositional formula and returns
; * 'TAUTOLOGY if every interpretation I satisfies F;
; * 'CONTRADICTION if no interpretation I satisfies F;
; * 'CONTINGENCY if there are two interpretations I and I′ such that I satisfies F and I' does not.
; if false, if true contignent else contradiction else always true
(define (classify F)
  (if (sat? (solve (assert (! F))))
      (if (sat? (solve (assert F)))
          "CONTINGENCY"
          "CONTRADICTION"
          ) "TAUTOLOGY"))

(define-symbolic* p q r boolean?)

; (p → (q → r)) → (¬r → (¬q → ¬p))
(define f0 (=> (=> p (=> q r)) (=> (! r) (=> (! q) (! p)))))

; (p ∧ q) → (p → q)
(define f1 (=> (&& p q) (=> p q)))

; (p ↔ q) ∧ (q → r) ∧ ¬(¬r → ¬p)
(define f2 (&& (<=> p q) (=> q r) (! (=> (! r) (! q)))))

(check-equal? (classify f0) "CONTINGENCY")
(check-equal? (classify f1) "TAUTOLOGY")
(check-equal? (classify f2) "CONTRADICTION")
