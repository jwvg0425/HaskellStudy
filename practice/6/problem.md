
# 1 - Direction & Position

4개의 방향을 나타내는 Direction 타입을 만들어봅시다. 그리고 2개의 숫자값으로 이루어진 Position 타입과, Direction 및 Position, 이동량 값을 받아 이동한 후의 좌표(Position)를 리턴하는 move 함수를 작성해봅시다.

> example

```
ghci> move (Position 5 3) L 2
Position 3 3
ghci> move (Position 0 0) U 5
Position 0 (-5)
ghci> move (Position 0 0) R 3
Position 3 0
ghci> move (Position 2 2) D 4
Position 2 6
```

# 2 - Direction & Position : typeclass

Direction, Position 타입에 대한 타입클래스를 작성해봅시다. 우선 Show 타입 클래스를 상속받아 해당 타입의 값을 적당한 형태의 문자열로 반환해주는 show 함수를 구현해봅시다.

그리고 두 개의 값이 같은지 다른지 판단하는 Eq 클래스도 상속받아봅시다.

> example

```
ghci> L == R
False
ghci> Position 3 3 == Position 3 3
True
ghci> show L
"Left Direction"
ghci> show $ Position 5 5
"(x = 5, y = 5)"
```