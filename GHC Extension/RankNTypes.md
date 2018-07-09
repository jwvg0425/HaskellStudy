# Polymorphic function

Haskell에서는 다형적인 함수(Polymorphic function)가 굉장히 많이 사용됩니다. 정적인 타입 시스템을 가진 언어에서 일반적인 상황에 유용한 함수를 만들 수 있기 때문이죠. 아마 다형적인 함수의 가장 간단한 예제는 `length`일 겁니다.

```Haskell
length :: [a] -> Int
```

`length` 함수는 `a`라는 임의 타입의 리스트를 받아서 그 리스트의 길이를 돌려주는 함수죠. 이런 함수는 하나만 작성해도 모든 종류의 리스트에 대해 사용할 수 있기 때문에 굉장히 편리합니다. `length` 외에도 자주 사용되는 다형적인 함수는 굉장히 많죠.

```Haskell
map :: (a -> b) -> [a] -> [b]
fst :: (a,b) -> a
snd :: (a,b) -> b
```

 그리고 이런 다형적 함수들의 타입을 좀 더 명확하게 표현하면 아래와 같이 나타낼 수 있습니다.

```
length :: forall a. [a] -> Int
map :: forall a b. (a -> b) -> [a] -> [b]
fst :: forall a b. (a,b) -> a
```

여기서 `forall`은 수학에서 말하는 전칭 기호(universal quantifier, ∀)를 뜻합니다. 술어 논리에서 ∀xP(x)같은 표현을 쓸 때의 ∀와 의미가 유사하다고 생각하면 됩니다. 즉, `length :: forall a. [a] -> Int`는 의미를 따지자면 **`length` 라는 함수는 모든 종류의 타입 `a`에 대해 `a` 타입을 원소로하는 리스트를 인자로 받아 `Int` 타입의 값을 리턴한다** 라는 뜻이죠. `map`이나 `fst`, `snd` 등의 함수도 마찬가지입니다. `forall`을 앞에 명시해주는 것이 해당 함수의 타입을 좀 더 명확하게 표기해줄 수 있지요.

# Higher rank types

 이제 조금 더 복잡한 주제로 들어가 봅시다. 아래의 함수 `foo`는 과연 컴파일이 될까요?

```Haskell
foo :: ([a] -> Int) -> [b] -> [c] -> Bool
foo f x y = f x == f y
```

`foo`가 첫번째 인자로 받는 함수 `f`는 임의의 타입 `a`의 리스트를 인자로 받아 `Int`를 리턴하는 함수입니다. 그 `f`에 임의타입의 리스트 `x`,`y`를 넘겨 결과 값이 같은지 비교하고 있죠. 이 함수는 예를 들어 다음과 같은 방식으로 사용될 수 있을 겁니다.

```Haskell
foo length [1,2,3,4] ['a','b','c','d']
```

이러면 서로 다른 타입의 두 리스트 `[1,2,3,4]`와 `['a','b','c','d']`의 길이가 같은지 아닌지 검사하게 되겠죠. 하지만 아쉽게도 이 코드는 제대로 동작하지 않습니다. 왜 그런지 살펴보기 위해 `foo`의 타입을 좀 더 자세히 살펴봅시다. `foo`의 타입을 위에서 설명한 것처럼 `forall`을 이용해 명시적으로 나타내면 아래와 같은 타입이 됩니다.

```Haskell
foo :: forall a b c. ([a] -> Int) -> [b] -> [c] -> Bool
```

여기서 `forall a b c`가 타입 서명(type signature)에서 가장 바깥쪽에 있다는 사실이 문제입니다. 이 함수의 타입을 한 번 풀어서 읽어본다면, **`foo` 함수는 모든 임의의 타입 `a`,`b`,`c`에 대해 `[a]` 타입의 값을 인자로 받아 `Int`를 리턴하는 함수와 `[b]`,`[c]` 타입의 인자를 받아 `Bool` 타입의 값을 리턴한다** 가 될 것입니다. 즉, `a`,`b`,`c` 타입은 전체 타입 서명에서 하나의 명확한 타입으로 고정이 됩니다. 다시 위의 사용 예제 코드로 돌아가봅시다.

```Haskell
foo length [1,2,3,4] ['a','b','c','d']
```

`foo`함수가 위와 같이 호출이 될 경우 위의 `a`,`b`,`c` 타입은 각각 무엇으로 결정이 될까요? 대충 이야기하자면 `b` 타입은 `Int`, `c` 타입은 `Char`이 될 겁니다. 하지만 `a` 타입은 뭐라고 해야할까요? `a`는 `Int` 이면서 `Char`이어야하는데 `a` 라는 하나의 타입이 동시에 두 개의 타입을 나타낼 수는 없습니다. 이 문제는 전칭기호 `forall`이 타입서명의 맨 바깥쪽에 있기 때문에 생기는 문제입니다. `a` 타입과 `b`,`c` 타입이 모두 같은 레벨에 있기 때문에 `a`가 두 개의 타입을 동시에 나타낼 수 없게 되는 거죠. 이 문제를 해결하려면 `foo`의 타입을 다음과 같이 적어주어야합니다.

```
foo :: forall b c. (forall a. [a] -> Int) -> [b] -> [c] -> Bool
```
이 타입을 풀어서 읽으면 이렇게 될겁니다. **`foo` 함수는 모든 임의의 타입 `b`,`c`에 대해, 모든 임의의 타입 `a`의 리스트를 인자로 받아 `Int`를 리턴하는 함수와 `b`,`c` 타입의 리스트를 인자로 받아 `Bool` 타입의 값을 리턴한다.** 차이가 느껴지시나요? `b`,`c` 타입보다 `a` 타입에 대한 전칭 기호가 한 단계 안쪽에서 정의되기 때문에 이 함수가 어떤 타입의 값에 적용되느냐에 따라 한 함수 내에서 `a` 타입이 `Int`가 될 수도, `Char` 타입이 될 수도 있는 겁니다. 이 때 `foo` 함수와 `length`, `map` 등의 함수는 같은 다형적인 함수지만 타입에 분명히 차이가 있습니다. `length`, `map` 같이 `forall`이 모두 맨 바깥에 있는 경우 rank-1 타입이라고 하며, `foo`와 같이 최소 하나 이상의 rank-1 타입의 값을 인자로 받는 함수를 rank-2 함수라고 합니다. 이를 확장하면 rank-N 타입은 최소 하나 이상의 rank-(N-1) 타입의 값을 인자로 받는 함수라고 정의할 수 있지요.

Haskell에서 이런 타입을 사용하려면 `{-# LANGUAGE Rank2Types #-}` 또는 `{-# LANGUAGE RankNTypes #-}`를 소스 코드의 맨 위에 명시해주어야합니다.

그렇다면 Rank-N 타입은 상당히 유용한 것인데 왜 언어에서 기본적으로 제공해주지 않는 걸까요? 가장 큰 이유는 바로 Rank-N 타입을 허용할 경우 함수의 타입을 결정불가능(undecidable)하게 되기 때문입니다. 즉, 프로그래머가 직접 함수의 타입을 명시해주어야만 합니다. Haskell은 모든 함수의 타입을 추론 가능하기를 원했고 그 때문에 Rank-N Type을 기본적으로 사용할 수 없는 타입 시스템을 사용합니다.

# 참고 문서

[https://en.wikibooks.org/wiki/Haskell/Polymorphism](https://en.wikibooks.org/wiki/Haskell/Polymorphism)

[http://blog.mno2.org/posts/2012-04-06-what-is-rank-n-types-in-haskell.html](http://blog.mno2.org/posts/2012-04-06-what-is-rank-n-types-in-haskell.html)

[https://wiki.haskell.org/Rank-N_types](https://wiki.haskell.org/Rank-N_types)
