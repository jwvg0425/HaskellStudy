# 1 - fibonacci

숫자 n이 주어졌을 때 n번째 피보나치 숫자를 구하는 함수를 만들어봅시다. 0번째 피보나치 수는 1, 1번째 피보나치 수도 1, 2이상의 n번째 피보나치 수는 n-1번째 피보나치 수와 n-2번째 피보나치 수를 더한 것으로 정의합니다.

> example

```
ghci> fibonacci 1
1
ghci> fibonacci 3
3
ghci> fibonacci 6
13
```

# 2 - minThree

세 개의 숫자 a,b,c를 인자로 받아 그 중 가장 작은 숫자를 리턴하는 함수를 만들어봅시다.

> example

```
ghci> minThree 1 2 3
1
ghci> minThree 5 2 6
2
ghci> minThree 6 9 0
0
```