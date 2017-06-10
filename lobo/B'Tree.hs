module B'Tree where

import Cp

-- (1) Datatype definition -----------------------------------------------------

data B'Tree a = Nil | Block { leftmost :: B'Tree a , block :: [(a, B'Tree a)]}
    deriving (Show , Eq )

outB'Tree :: B'Tree a -> Either () (B'Tree a , [(a, B'Tree a)]) 
outB'Tree Nil = i1 ()
outB'Tree (Block t l) = i2 (t, l)

inB'Tree  :: Either () (B'Tree a , [(a, B'Tree a)]) -> B'Tree a
inB'Tree = either (const Nil) (uncurry Block)

-- (2) Ana + cata + hylo -------------------------------------------------------

recB'Tree ::  (a -> b) -> Either () (a , [(d, a)]) -> Either () (b , [(d, b)])
recB'Tree f = id -|- (f >< (map (id >< f)))

cataB'Tree :: ((Either () (b , [(a, b)])) -> b) -> B'Tree a -> b
cataB'Tree g = g . (recB'Tree (cataB'Tree g)) . outB'Tree

anaB'Tree :: (a -> Either () (a , [(b , a)])) -> a -> B'Tree b
anaB'Tree g = inB'Tree . (recB'Tree (anaB'Tree g)) . g

hyloB'Tree :: ((Either () (c , [(b, c)])) -> c) -> (a -> Either () (a , [(b , a)])) -> a -> c
hyloB'Tree h g = cataB'Tree h . anaB'Tree g 
