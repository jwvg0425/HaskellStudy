# KMP Algorithm

## 참고 자료

[Formal derivation of a pattern matching algorithm](http://www.sciencedirect.com/science/article/pii/0167642389900361#)  
[Knuth-Morris-Partt in Haskell](http://www.twanvl.nl/blog/haskell/Knuth-Morris-Pratt-in-Haskell)

[Haskell 소스코드](kmp.hs)

## match

kmp 알고리즘에서 하고 싶은 것은 두 개의 리스트 `pattern`과 `text`가 있을 때, `text`가 `pattern`을 포함하고 있는지 효율적으로 확인하는 것이다. 예를 들어 `pattern`이 `"abc"`이고 `text`가 `"defabcdef"` 라면, `text`는 `pattern`을 중간에 포함하고 있으므로 우리의 알고리즘은 `True`를 리턴해주어야 한다. 반면 `pattern`이 `"abc"`인데 `text`가 `"aaabbbcccab"` 라면 내부에 `"abc"`를 포함하고 있지 않으므로 `False`를 리턴해주어야 한다.

그러면 이런 역할을 하는 함수의 이름을 `match`라고 해보자. `match` 함수는 다음과 같은 타입을 가지게 될 것이다.

```Haskell
match :: Eq a => [a] -> [a] -> Bool
match pattern text = undefined
```

서로 비교가 가능해야 포함 여부를 판별 가능하므로 `Eq` 타입 클래스에 속한 임의의 타입에 대해 사용 가능한 함수로 볼 수 있다. 이 함수를 어떻게 구현해야할까? 효율을 생각하지 않고 단순 무식하게 생각한다면 아래와 같은 구현이 가능할 것이다.

```Haskell
match pattern text = pattern `elem` segments text
```

여기서 `segments`함수는 모든 해당 리스트의 모든 부분 리스트를 취하는 함수라고 생각하면 된다.

```Haskell
segments :: [a] -> [[a]]
segments = concat . map tails . inits

>>> segments "abc"
["", "a", "ab", "abc", "b", "bc", "c"] -- 실제로는 빈 리스트가 여러 개 포함된다.
```

 이러면 `text`의 부분 리스트들 중에 `pattern`이 있는지를 확인하는 것이기 때문에 `match`함수는 정상적으로 작동한다. 하지만 `text`의 길이를 `n`, `pattern`의 길이를 `m`이라고 했을 때 `segments text` 함수의 호출에서 O(n^2) 만큼의 시간이 걸리고(모든 부분 리스트를 만들어야하므로), 그 각각에 대해 `pattern`과 일치하는지 검사하는데에 O(m)의 시간이 걸리니 총 O(n^2 * m) 만큼의 시간이 걸린다. 너무 비효율적인 구현이다. 

### 전략

다음의 등식을 이용해서 `match`함수를 좀 더 빠르게 만들 수 있다.

```Haskell
map (foldl f e) (inits xs) = scanl f e xs
```

식의 왼쪽과 오른쪽은 항상 결과가 같은데, 왜 그런지부터 일단 살펴보자. `inits`함수는 특정 리스트의 모든 prefix를 돌려준다고 생각하면 된다.

```Haskell
>>> inits [a,b,c]
[[], [a], [a,b], [a,b,c] ]
```

`foldl` 함수는 함수와 시작값을 받아서 그걸 리스트의 맨 왼쪽부터 순서대로 실행시켜 나간다.

```Haskell
foldl f e [a,b,c] = e `f` a `f` b `f` c
```

`scanl` 함수는 `foldl`을 중간 계산 결과를 저장하면서 나아가는 함수라고 생각하면 된다.

```Haskell
scanl f e [a,b,c] = [e, e `f` a, e `f` a `f` b, e `f` a `f` b `f` c]
```

그러면 `map (foldl f e) (inits [a,b,c])` 이 식의 결과는 어떨까?

```Haskell
map (foldl f e) (inits [a,b,c])
= map (foldl f e) [[], [a], [a,b], [a,b,c]]
= [foldl f e [], foldl f e [a], foldl f e [a,b], foldl f e [a,b,c]]
= [e, e `f` a, e `f` a `f` b, e `f` a `f` b `f` c]
```

즉 결과적으로 양쪽의 리턴 값은 같아진다는 것을 알 수 있다. 여기서 왼쪽 식의 경우 `inits`를 계산하고 거기에 `foldl f e`를 적용하기 때문에 리스트 xs의 길이 n에 대해 O(n^2)의 시간이 걸리는데, 오른쪽 scanl의 경우 함수를 수행한 중간 결과를 계속 리스트에 저장하면서 다음 스텝으로 나아가면 되기 때문에 O(n)의 시간이 걸린다. 같은 결과를 리턴하지만 수행 시간은 차이가 나게 되는 것이다. 이 변환을 통해 우리가 위에서 짠 `match` 함수를 좀 더 효율적으로 만들 수 있다.

일단 다시 `match` 함수의 구현으로 돌아가 보자.

```Haskell
match pattern text = pattern `elem` segments text
segments = concat . map tails . inits
```

두 개를 합치면 아래와 같은 형태가 된다.

```Haskell
match pattern = (pattern `elem`) . concat . map tails . inits
```

이걸 적절히 변형하면 아래와 같은 식을 얻을 수 있다.

```Haskell
match pattern = or . map ((pattern `elem`) . tails) . inits
```

segments를 먼저 만들고 거기에 `pattern`이 있는 지를 확인하는게 아니라, `inits`의 끝부분들 중에서 `pattern`이 있는지 확인한 다음 하나라도 `or`을 이용해서 그 중 하나라도 `pattern`이 있다면 `True`가 되게 하는 것이다. 함수의 적용 순서가 달라졌을 뿐 로직은 동일하다. 이 걸 좀 더 가독성 좋게 바꾸면 아래와 같은 형태가 된다.

```Haskell
match pattern = or . map (endswith pattern) . inits
endswith pattern text = pattern `elem` tails text
```

왜 이런 변형을 거쳤냐 하면, 위에서 언급한 등식

```Haskell
map (foldl f e) (inits xs) = scanl f e xs
```

을 이용하기 위해서이다. 변형된 `match` 함수의 구현에서, `map (endswith pattern) . inits` 부분을 잘 보자. 만약 `(endswith pattern)` 부분이 `foldl f e` 형태가 된다면, 우리는 해당 부분을 `scanl f e xs` 형태로 바꾸고 성능 상의 이득을 얻을 수 있다. 하지만 현재 `endswith`의 구현으로는 그런 변형이 불가능하다. 따라서 우리는 여기서 함수 구현을 약간 더 바꿀 필요가 있다. 

여기서 `endswith` 대신에 `overlap`이라는 함수를 생각해보자. `overlap pattern text`는 `text`의 부분 리스트 중에서 `pattern`으로 시작하는 가장 긴 부분 리스트를 반환한다. `pattern`으로 시작하는 `text`의 가장 긴 부분 리스트가 `pattern` 그 자체라면, `text`는 `pattern`으로 끝난다는 의미이다. 따라서 `overlap` 함수를 이용해 `endswith`의 구현을 바꿀 수 있다.

```Haskell
overlap pattern text = foldl getLong [] $ filter (starts pattern) $ tails text
starts pattern text = text `elem` inits pattern
getLong a b -- a, b 두 리스트중 길이가 더 긴 리스트를 반환. 길이가 같을 경우 a.
    | length a >= length b = a
    | otherwise = b

endswith pattern text = (pattern == overlap pattern text)
```

이제 이 함수를 기존의 `match`에 적용시켜 보자.

```Haskell
match pattern = or . map ((pattern ==) . overlap pattern) . inits
```

```Haskell
match pattern = or . map (pattern ==) . map (overlap pattern) . inits -- map (f.g) 는 map f . map g 와 동일하다
```

이제 `map (overlap pattern) . inits`를 `scanl` 형태로 바꿀 수 있다면 성능에서 많은 이득을 볼 수 있다.

### overlap

```Haskell
map (foldl f e) . inits = scanl f e
```

이 식을 `map (overlap pattern) . inits`에 활용하려면, `overlap pattern`을 `foldl f e`로 변환해야한다. 즉 `overlap pattern == foldl f e`인 적절한 함수 `f`와 시작값 `e`를 찾아내면 우리는 저런 변환을 할 수 있게 된다는 이야기이다. 그러면 위에서 만든 `overlap` 함수의 정의로부터 한 번 이 `f`와 `e`를 찾아보자.

우리가 찾는 함수 `f`와 값 `e`는 아래와 같은 성질을 만족해야 한다.

```Haskell
overlap pattern [] = e
overlap pattern (x++[a]) = overlap pattern x `f` a
```

두번째 배열이 빈 리스트일 때 결과가 `e` 여야한다는 것은 어찌보면 당연하다. `foldl`에서 시작값이기 때문이다. 그 아래줄 역시 비슷하다. `foldl`이 리스트의 원소에 대해 함수 `f`를 연속적으로 적용시켜나가는 것이라고 생각해보면, 결과적으로 그 `f`를 다 적용시켰을 때 결과가 `overlap pattern`과 같아야하니까.

