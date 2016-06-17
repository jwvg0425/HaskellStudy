#BangPatterns

GHC에서 Bang Patterns 확장을 쓰고 싶다면 소스 파일의 맨 위에 아래 코드를 적어주시면 됩니다.

```Haskell
{-# LANGUAGE BangPatterns #-}
```

Bang Patterns는 쉽게 말하자면, **엄격한 패턴 매칭**에 대한 구문을 제공해주는 언어 확장입니다. 예를 들어 다음과 같은 함수가 있다고 합시다.

```Haskell
foo :: Bool -> String
foo test = "Bar"
```

이 함수는 자신의 인자로 넘어온 값이 뭔지 평가하지 않습니다. 지연 평가 전략에 의해 ```test``` 값이 함수 실행에 필요하지 않으므로 값을 평가하지 않고 결과값 ```"Bar"```만 돌려주기 때문이죠. 그래서 함수 실행시 아래와 같은 결과가 나옵니다.

```Haskell
ghci> foo True
"Bar"
ghci> foo False
"Bar"
ghci> foo undefined
"Bar"
```

원래 ```undefined``` 값은 평가될 때 예외를 발생시켜야하지만 지연 평가 전략 때문에 값이 평가되지 않아 예외를 발생시키지 않고 결과값 ```"Bar"```를 돌려주게 되죠. 반면에 함수가 아래와 같이 작성되어 있을 경우 결과는 달라집니다.

```Haskell
foo :: Bool -> String
foo True = "Bar"
foo False = "Bar"
```

인자로 넘어온 값에 대해 패턴 매칭을 수행했고, 그 패턴 매칭에 따라 다른 함수 구현부를 갖게 되므로 결과값을 얻기 위해선 인자로 넘어온 값이 뭔지도 반드시 평가를 해야합니다. 그래서 함수의 실행 결과는 아래와 같이 달라집니다.

```Haskell
ghci> foo True
"Bar"
ghci> foo False
"Bar"
ghci> foo undefined
*** Exception: Prelude.undefined
```

Bang Patterns는 패턴 매칭에서 특정 인자가 필요하든 필요하지 않든 WHNF 형태가 될 때까지 평가를 시키게 만들어주는 언어 확장입니다. 아래와 같이 Bang Patterns를 적용하고 싶은 인자에 대해 인자의 앞에 !를 붙여주면 됩니다.

```Haskell
foo :: Bool -> String
foo !test = "Bar"
```

이렇게 작성하면 Bool값 test가 WHNF형태, 즉 값 생성자 부분까진 평가를 해야하는데, bool값의 값 생성자는 True 또는 False죠. 따라서 이 함수에 undefined 같은 값을 넘기게 될 경우 예외를 발생시키게 됩니다. 엄격한 패턴 매칭을 쉽게 수행할 수 있게 도와주는 언어 확장이죠.