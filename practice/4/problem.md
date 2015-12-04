# 1 - isSorted

어떤 리스트 a가 주어졌을 때, 이 리스트가 오름차순으로 정렬되어있다면 True,아니면 False를 리턴하는 함수를 만들어봅시다.

> example

```
ghci> isSorted [1,2,3,4]
True
ghci> isSorted [1]
True
ghci> isSorted []
True
ghci> isSorted [3,2,1]
False
ghci> isSorted [1,3,2]
False
```

# 2 - contains

두 개의 리스트 a,b가 주어졌을 때, 리스트 a가 리스트 b의 모든 원소를 포함하고 있다면 True, 그렇지 않다면 False를 리턴하는 함수를 만들어봅시다.

> example

```
ghci> [1,2,3,4,5] `contains` [2,3,4]
True
ghci> [2,4,6] `contains` [1,2,3]
False
ghci> [1..9] `contains` [2..5]
True
```