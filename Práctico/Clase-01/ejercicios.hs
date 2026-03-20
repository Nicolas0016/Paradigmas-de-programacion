prod :: Int -> Int -> Int
prod x y = x * y

doble = prod 2
-- (.)
(.) :: (b -> c) -> (a -> b) -> a -> c
(.) f g x = f (g x)

-- flip
flip :: (a -> b -> c) -> b -> a -> c
flip f x y = f y x

-- ($)
($) :: (a -> b) -> a -> b
($) f x = f x

-- const
const :: a -> b -> a
const x y = x