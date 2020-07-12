#| a normal haskell module looks like this:

-- pragmas
{-# LANGUAGE FooBar #-}

-- module
module Main (
  -- exports
  foo bar)

-- imports
import Foo
import qualified Bar.Baz as Baz
import Moo (moo1,moo2)

data ... = ...
type ... = ...

-- functions dont need keywords
func = let

func = bla
  where helper = baz

func = \x y -> x + y

main :: IO ()
main = do
  ...

functions should have type signatures
you can do stuff like specialize, inline, etc
|#

(defparameter *hs-positive-language-pragmas*
  '(bang-patterns arrows cpp data-kinds derive-generic empty-data-decls
    flexible-contexts gadts haskell98 haskell2010
    kind-signatures lambda-case type-families template-haskell
    overloaded-strings parallel-list-comp))

(defstruct (hs-pragma
            (:copier nil)
            (:constructor hs-pragma name))
  (name nil :type (or symbol string)))

(defstruct (hs-language-pragma
            (:include hs-pragma)))

(defstruct hs-function-signature
  ;; can be NIL
  type-classes
  ;; can be NIL, but arbitrary (currying)
  input-types
  ;; exactly one
  output-type)

(defstruct hs-operator
  (symbol nil :type symbol))

(defmethod print-object ((obj hs-operator) stream)
  (format stream "(~a)" (hs-operator-symbol obj)))

(defstruct hs-function-skeleton
  (name nil :type (or symbol string hs-operator))
  (signature nil :type (or symbol cons)))

(defmethod print-object ((obj hs-function-skeleton) stream)
  (format stream "~a :: ~{~a~^ -> ~}"
          (hs-function-skeleton-name obj)
          (hs-function-skeleton-signature obj)))

(defstruct hs-type-class
  name
  polymorphics
  (skeletons nil :type (simple-array hs-function-skeleton (*))
  minimal)

(defstruct hs-function
  (name (error "Function must have a name.") :type (or string symbol))
  (signature nil :type hs-function-signature)
  ;; can be just one of those at a time
  (body nil :type (or hs-do
                      hs-lambda
                      hs-let
                      hs-where))
  (inline nil :type boolean)
  (specialize nil :type cons))
