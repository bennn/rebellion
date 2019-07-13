#lang scribble/manual

@(require (for-label racket/base
                     racket/contract/base
                     rebellion/base/symbol
                     rebellion/base/variant
                     rebellion/streaming/reducer)
          (submod rebellion/private/scribble-evaluator-factory doc)
          scribble/example)

@(define make-evaluator
   (make-module-sharing-evaluator-factory
    #:public (list 'rebellion/streaming/reducer)
    #:private (list 'racket/base)))

@title{Reducers}
@defmodule[rebellion/streaming/reducer]

@defproc[(reducer? [v any/c]) boolean?]

@defproc[(reduce [red reducer?] [v any/c] ...) any/c]{

 @(examples
   #:eval (make-evaluator) #:once
   (reduce into-sum 1 2 3 4 5 6 7 8 9 10)
   (reduce into-product 2 3 5 7 11 13 17 19 23)
   (reduce into-count 'a 'b 'c 'd 'e))}

@defproc[(reduce-all [red reducer?] [vs sequence?]) any/c]{

 @(examples
   #:eval (make-evaluator) #:once
   (reduce-all into-sum (in-range 1 100))
   (reduce-all into-product (in-range 1 20))
   (reduce-all into-count (in-hash-values (hash 'a 1 'b 2 'c 3 'd 4))))}

@defthing[into-sum reducer?]
@defthing[into-product reducer?]
@defthing[into-count reducer?]

@section{Reducer Constructors}

@defproc[(make-fold-reducer
          [consumer (-> any/c any/c any/c)]
          [init-state any/c]
          [#:name name (or/c interned-symbol? #f) #f])
         reducer?]

@defproc[(make-effectful-fold-reducer
          [consumer (-> any/c any/c any/c)]
          [init-state-maker (-> any/c)]
          [finisher (-> any/c any/c)]
          [#:name name (or/c interned-symbol? #f) #f])
         reducer?]

@defproc[(make-reducer
          [#:starter starter
           (-> (variant/c #:consume any/c #:early-finish any/c))]
          [#:consumer consumer
           (-> any/c any/c (variant/c #:consume any/c #:early-finish any/c))]
          [#:finisher finisher (-> any/c any/c)]
          [#:early-finisher early-finisher (-> any/c any/c)]
          [#:name name (or/c interned-symbol? #f) #f])
         reducer?]

@section{Reducer Operators}

@defproc[(reducer-map [red reducer?]
                      [#:domain f (-> any/c any/c) values]
                      [#:range g (-> any/c any/c) values])
         reducer?]

@defproc[(reducer-filter [red reducer?] [pred predicate/c]) reducer?]
