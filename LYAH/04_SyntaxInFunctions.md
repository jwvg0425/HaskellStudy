# 함수에서의 구문

## 패턴 매칭

이번 단원에서는 Haskell의 멋진 구문 구조중 일부에 대해 다룰 거야. 우선 패턴 매칭으로 시작해보자. 패턴 매칭(pattern matching)은 어떤 데이터가 따라야 할 패턴을 명시하는 것과, 패턴이 있다면 데이터가 그 패턴을 따라 분해될 수 있는지 확인하는 과정으로 구성되어 있어.

함수를 정의할 때, 서로 다른 패턴에 대해 함수의 본체를 각각 따로 정의할 수 있어. 이건 굉장히 깔끔하고 가독성 높은 코드를 만들어내지. 패턴 매칭은 숫자, 문자, 리스트, 튜플, 기타 등등의 모든 종류의 데이터 타입에 대해 사용할 수 있어. 우리가 인자로 넘길 숫자가 7인지 아닌지 확인하는 정말 별 거 아닌 함수를 한 번 만들어보자.

```haskell
lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN!"
lucky x = "Sorry, you're out of luck, pal!"
```

`lucky` 함수를 호출하면, 패턴은 위에서부터 아래로 체크되면서 패턴에 부합하는 게 있는 지 확인하고, 해당 패턴에 부합되는 함수의 본체가 실행이 돼. 여기서 첫번 째 패턴에 부합될 수 있는 숫자는 `7`밖에 없지. 만약 `7`이 아니라면, 이건 두 번째 패턴으로 넘어가고, 이 패턴은 어떤 숫자든 매칭이 되고 그걸 `x`와 묶지(binding). 이 함수는 `if`문을 가지고도 구현될 수 있어. 하지만 만약 어떤 숫자가 `1`부터 `5`까지면 해당 숫자를 말하고, 그렇지 않다면 `"Not between 1 and 5"`라고 출력하는 함수를 만들고 싶다면 어떨까? 패턴 매칭이 없다면 `if then else` 트리로 이루이전 굉장히 난해한 코드를 만들어야 할거야. 하지만, 패턴매칭을 쓰면 이렇게 깔끔하게 해결되지.

```haskell
sayMe :: (Integral a) => a -> String
sayMe 1 = "One!"
sayMe 2 = "Two!"
sayMe 3 = "Three!"
sayMe 4 = "Four!"
sayMe 5 = "Five!"
sayMe x = "Not between 1 and 5"
```

만약 마지막 패턴(모든 것들이 매칭되는)을 맨 위로 옮긴다면, 이 함수는 항상 `"Not between 1 and 5"`라고 출력할 거라는 걸 명심해. 왜냐하면 이 경우에 첫번째 패턴이 모든 인자들을 다 매칭시켜버리니 두번째 이후 패턴을 검사할 기회 자체가 사라져버리거든. 

이전에 구현했던 팩토리얼 함수 기억나? 우린 `n!`을 `product [1..n]`으로 정의했어. 팩토리얼 함수는 재귀적으로도 정의 가능해. 이 방법은 수학 쪽에서 정의할 때 자주 이용되지. 팩토리얼을 재귀적으로 정의할 때 `0! = 1`이라고 정의하는 걸로 시작한 다음, 어떤 양수의 팩토리얼은 그 정수와 그 정수보다 1 작은 수의 팩토리얼의 곱으로 정의할 수 있어. 아래에 그걸 Haskell로 옮기면 어떻게 되는 지 나와 있어.

```Haskell
factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n - 1)
```

우린 지금 처음으로 함수를 재귀적으로 정의해봤어. Haskell에서 재귀는 중요하고, 우린 이걸 나중에 좀 더 자세히 살펴볼거야. 일단 우리가 `3!`를 구하려고 할 때 어떤 일이 일어나는지 간단하게 요약해보자. 먼저 이건 `3 * factorial 2`를 계산하려고 시도할거야. 그리고 `2!`은 `2 * factorial 1`이고, 이제 우리는 `3 * (2 * factorial 1)`을 계산하면 돼. `factorial 1`은 `1 * factorial 0`이야. 이제 `3 * (2 * ( 1* factorial 0))` 을 계산하면 되겠군. 그리고 여기 트릭이 있어. 우린 `factorial 0` 을 `1`로 정의했어. 이 패턴이 `factorial n`보다 위에 있으니 `factorial 0`은 첫 번째 패턴을 먼저 방문하게 될테고, 그 결과로 `1`을 리턴하겠지. 그래서 최종적으로 결과는 `3 * (2 * (1 * 1))`과 똑같아. 만약 두 번째 패턴을 맨 위에 썼다면, 이건 항상 `0`을 포함한 모든 숫자들과 매칭이 되기 때문에 계산이 끝나지 않을거야. 그래서 패턴을 명시할 땐 순서가 중요해. 그래서 가장 명확한 것에 대한 패턴을 앞에 두고, 일반적인 것들에 대한 패턴을 나중에 두는게 항상 좋은 방법이야.

패턴 매칭은 실패할 수도 있어. 이렇게 함수를 짰다고 가정해보자.

```Haskell
charName :: Char -> String
charName 'a' = "Albert"
charName 'b' = "Broseph"
charName 'c' = "Cecil"
```

 그리고 우리가 예측하지 못한 입력값으로 이 함수를 호출하려고 시도한다면, 이런 일이 일어나.

```Haskell
ghci> charName 'a'  
"Albert"  
ghci> charName 'b'  
"Broseph"  
ghci> charName 'h'  
"*** Exception: tut.hs:(53,0)-(55,21): Non-exhaustive patterns in function charName 
```

이건 우리가 철저하지 못한 패턴(non-exhaustive patterns)을 갖고 있다고 항의하는 거고, 정말로 그렇지. 패턴을 만들 땐 반드시 모든 종류의 패턴이 매칭될 수 있게 해서 프로그램이 예측하지 못한 입력 때문에 터지는 일이 없도록 만들어야 돼.

패턴 매칭은 튜플에 대해서도 사용할 수 있어. 만약 2D 공간에서 두 개의 백터(페어의 형태를 갖고 있는)를 취해서 그 둘을 더하는 함수를 만들고 싶다면 어떻게 해야할까? 두 개의 벡터를 더하기 위해선 `x` 요소와 `y` 요소를 각각 더해야해. 여기 패턴 매칭을 모를 때 짤 수 있는 코드가 있어.

```Haskell
addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors a b = (fst a + fst b, snd a + snd b)
```

물론, 이 것도 잘 동작해. 하지만 더 좋은 방법이 있어. 이 함수를 패턴 매칭을 사용하도록 수정해보자.

```Haskell
addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)
```

짠! 더 나아졌어. 이건 이 자체로 모든 종류의 패턴과 매칭이 돼. `addVectors`는 두 케이스에서 모두 `addVectors :: (Num a) => (a,a) -> (a,a) -> (a,a)`이고, 따라서 항상 두 개의 페어를 인자로 받는게 보장이 되기 때문이지.

`fst`와 `snd`는 페어의 요소를 추출해 내. 하지만 트리플에서는 어떻게 하지? 음, 트리플에 대해선 제공되는 함수가 없지만 우리 스스로 만들어 쓸 수 있지.

```Haskell
first :: (a, b, c) -> a
first (x, _, _) = x

second :: (a, b, c) -> b
second (_, y, _) = y

third :: (a, b, c) -> c
third (_, _, z) = z
```

`_` 기호는 조건 제시형 리스트에서 썼던 것과 같은 의미를 갖고 있어. 해당 부분에 뭐가 오든 정말로 신경쓰지 않겠다고 의미하고 싶으면 그냥 `_`라고 쓰면 돼.

이 거 때문에 기억이 났는데, 패턴 매칭을 조건 제시형 리스트에서도 쓸 수 있어. 이걸 봐봐.

```Haskell
ghci> let xs = [(1,3), (4,3), (2,4), (5,3), (5,6), (3,1)]
ghci> [a+b | (a,b) <- xs]
[4,7,6,8,11,4]
```

패턴 매칭이 실패한다면, 이건 그냥 다음 원소로 넘어갈거야.

리스트는 그 자체로 패턴 매칭에 사용될 수 있어. 텅 빈 리스트 `[]`, 또는 `:` 연산자와 `[]`를 포함한 어떤 패턴이든 사용할 수 있어. `[1,2,3]`이 `1:2:3:[]`의 간단한 표현이기 때문에, 좀 더 형식화된 패턴도 사용할 수 있지. `x:xs` 같은 패턴은 리스트의 `head`를 `x`로, 그리고 나머지를 `xs`로 취급해. 만약 해당 리스트에 원소가 하나밖에 없다면 `xs`는 텅 빈 리스트가 되겠지.

> 주: `x:xs` 패턴은 자주 이용되고, 특히 재귀적인 함수에서는 더 그래. 하지만 `:` 연산자를 사용하는 패턴은 길이가 `1` 이상인 리스트에 대해서만 매칭이 된다는 걸 명심해.

처음 세 개의 원소를 변수로 지정하고 리스트의 나머지 부분을 별로의 변수로 지정하는 것도 `x:y:z:zs` 형태로 표기하면 가능해. 이건 길이가 `3`이상인 원소에 대해서만 대응되는 패턴이겠지.

이제 리스트에 대해 패턴 매칭하는 방법을 알아보자. `head` 함수를 직접 만들어볼거야.

```Haskell
head' :: [a] -> a
head' [] = error "Can't call head on an empty list, dummy!"
head' (x:_) = x
```

이게 잘 동작하는 지 확인해봐.

```Haskell
ghci> head' [4,5,6]
4
ghci> head' "Hello"
'H'
```

멋져! 만약 여러 개의 변수를 지정하고 싶다면(심지어 그 중 하나가 그냥 `_` 이고 실제로는 전부 변수로 지정되는게 아니라 할지라도), 우린 그것들을 소괄호로 둘러 싸줘야 돼. `error` 함수를 사용한 것도 눈여겨 봐. 이건 문자열을 인자로 받아서 런타임 에러를 방생시키고, 해당 문자열을 어떤 종류의 오류가 발생했는 지 알려주는 정보로 사용해. 이건 프로그램이 터지게 만들기 때문에 너무 많이 쓰는 건 좋은 방법이 아니야. 하지만 `head` 함수를 빈 리스트에 사용했을 때 프로그램이 터지는 거야 뭐 당연하지.

이제 이제 리스트의 처음 원소들을 (불)편한 영어 형태로 보여주는 간단한 함수를 한 번 만들어보자.

```Haskell
tell :: (Show a) => [a] -> String
tell [] = "The list is empty"
tell (x:[]) = "The list has one element: " ++ show x
tell (x:y:[]) = "The list has two elements: " ++ show x ++ " and " ++ show y
tell (x:y:_) = "This list is long. The first two elements are: " ++ show x ++ " and " ++ show y
```

이 함수는 텅 빈 리스트, 원소가 하나인 리스트, 두 개인 리스트, 그리고 두 개 이상의 리스트에 대해서 모두 확인하기 때문에 안전해. `(x:[])` 와 `(x:y:[])`는 `[x]`, `[x,y]`로도 쓸 수 있다는 것도 참고해(이건 간략한 표기법이기 때문에, 소괄호는 필요없어). `(x:y:_)`는 크기가 `2`이상인 모든 종류의 리스트에 대응되기 때문에 대괄호를 사용하는 표기법으로 바꿔쓸 수는 없어.

우린 이미 조건 제시형 리스트를 이용해 `length` 함수를 구현해봤지. 여기선 간단한 재귀와 패턴 매칭을 이용해 `length` 함수를 만들어볼거야.

```Haskell
length' :: (Num b) => [a] -> b
length' [] = 0
length' (_:xs) = 1 + length' xs
```

이 건 앞에서 쓴 팩토리얼 함수와 비슷해. 먼저 답이 알려진 입력(텅 빈 리스트)에 대한 결과를 정의해. 이건 경게 조건(edge condition)으로도 불려. 그러고 난 다음 두 번째 패턴에서 우리는 리스트를 머리와 꼬리로 분리하지. 이건 어떤 리스트의 `length`는 `1`과 그 리스트의 `tail`의 `length`를 더한 값과 같다는 걸 의미해. 리스트의 머리를 함수에서 사용하지 않으니까 이걸 `_` 기호를 사용해 표시했어. 또 이 함수가 리스트에서 가능한 모든 종류의 패턴을 다루고 있다는 것도 참고해. 첫번째 패턴은 텅빈 리스트와 매칭되고 나머지 하나는 텅빈 리스트가 아닌 모든 패턴에 대해 매칭돼.

이제 `sum` 함수를 구현해보자. 텅빈 리스트의 합이 0인 건 알고 있지. 이걸 아래쪽에 패턴으로 써놨어. 그리고 우린 어떤 리스트의 합(sum)은 그 머리의 값과 리스트의 나머지 부분의 합인 걸 알고 있지. 그것도 패턴으로 쓰면, 이런 결과가 나와.

```Haskell
sum' :: (Num a) => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs
```

또 패턴들(patterns)이라고 불리는 게 있어. 이건 전체에 대한 이름을 유지하면서 그걸 패턴에 따라 분리해서 여러 개의 변수로 쓰고 싶을 때 유용한 방법이야. 패턴의 앞에 이름과 `@`를 붙이는 걸로 이 방법을 사용할 수 있어. 예를 들어서, 패턴 `xs@(x:y:ys)`가 있을 수 있지. 이 패턴은 정확히 `x:y:ys`와 같은 경우에 매칭되지만, 넌 함수 본체에서 리스트 전체에 대한 참조를 `x:y:ys`라고 반복적으로 치는 대신 `xs`라고 치는 걸로 간단히 얻을 수 있어. 여기 간단하고 더러운 예제가 있지.

```Haskell
capital :: String -> String
capital "" = "Empty string, whoops!"
capital all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]
```

```Haskell
ghci> capital "Dracula"
"The first letter of Dracula is D"
```

일반적으로 큰 패턴에 대해 매칭할 때 함수 본체에서 해당 개체 전체를 다시 쓸 필요가 있고, 그 때문에 그 패턴 전체를 다시 반복해서 쓰는 걸 피하고 싶을 때 패턴들(patterns)을 사용해.

한 가지 더. 패턴 매칭에서 `++`는 쓸 수 없어. 만약 `(xs ++ ys)`에 대응되는 패턴을 매칭하려고 한다면, 리스트의 어디서 어디까지가 `xs`고 `ys`인지 알 수 있겠어? 이건 말이 안되지. 이게 말이 되려면 `(xs ++ [x,y,z])`라고 쓰거나, 그냥 `(xs ++[x])`라고 써야겠지. 하지만 리스트의 특성때문에, 그렇게 할 수 없어.

## 가드, 가드!

패턴이 값을 특정 형태에 맞는지 확인하고 그걸 분해하는 방법인 반면에, 가드는 값의 특정 성질(들)이 참인지 혹은 거짓인지 판단하는 방법이야. 이건 `if`문과 비슷해보이고 실제로도 그래. 가드는 여러 개의 조건을 쓸 때 훨씬 가독성이 좋고 또 패턴과 같이 쓸 때 굉장히 멋져.

걔네들의 구문 구조를 설명하는 대신에, 우선 가드를 쓰는 함수를 한 번 만들어보자. 우린 네 BMI 지수(body mass index)에 따라 다르게 너를 질책하는 간단한 함수를 만들어볼거야. BMI 지수는 네 몸무게를 네 키의 제곱근으로 나눈것과 같아. 만약 네 BMI가 18.5보다 작다면, 넌 저체중이지. BMI 지수고 18.5에서 25사이라면 너는 정상인이야. 25에서 30은 과체중이고 30이상은 비만이야. 이에 따른 함수가 여기 있어(일단 BMI 계산은 지금 하지 않아, 이 함수는 단지 BMI 지수를 받아서 그 결과를 너한테 말해줄 뿐이야).

```Haskell
bmiTell :: (RealFloat a) => a -> String  
bmiTell bmi  
    | bmi <= 18.5 = "You're underweight, you emo, you!"
    | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
    | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"
    | otherwise   = "You're a whale, congratulations!"
```

가드는 함수 이름과 인자 다음에 다음에 파이프(`|`)를 이용해서 나타내. 보통 가드는 오른쪽으로 조금 인덴트(indent)를 준 다음 줄을 세워. 가드는 기본적으로 논리 표현식이야. 이게 `True`로 평가되면, 거기에 부합되는 함수의 본체가 사용되지. 만약 `False`라고 평가되면, 다음 가드로 이동해서 평가하고 그게 반복돼. 만약 우리가 이 함수를 `24.3`이라는 인자를 이용해 호출하면, 우선 이게 `18.5`이하인지 검사하고, 그게 `False`니까 다음 가드로 이동해서 평가하지. 두번째 가드에서의 검사는 `25` 이하인지가 조건이고 BMI가 `24.3`이니까, 두번째 가드의 문자열이 리턴되겠지.

이건 명령형 언어에서의 엄청 큰 `if else` 트리를 연상시켜. 이건 그냥 좀 더 낫고 가독성이 있을 뿐이야. 커다란 `if else` 트리가 눈살을 찌푸리게 하는 동안, 때때로 문제는 그거랑 상관없는 별개의 곳에서 발생하곤 하지. 가드는 이런 `if else` 트리의 좋은 대체품이야.

대부분의 경우 맨 마지막 가드는 `otherwise`야. `otherwise`는 단순히 `otherwise = True`로 정의되어있고, 그래서 모든 경우를 잡아내. 이건 패턴이랑 정말 유사한데, 패턴 매칭이 주어진 입력이 패턴을 만족하는지 검사한다면 가드는 논리 조건식을 검사해. 만약 함수의 모든 가드가 `False`로 평가된다면(그리고 우리가 모든 경우를 잡아내주는 `otherwise` 가드를 만들 지 않았다면), 평가는 실패하고 다음 패턴으로 넘어가게 될거야. 이런 식으로 패턴과 가드는 서로 같이 잘 동작해. 만약 어떤 적합한 가드도 패턴도 없다면 에러가 발생해.

당연히 가드는 여러 개의 인자를 가진 함수에서도 쓸 수 있어. 함수를 부르기 전에 사용자가 BMI를 계산해서 넘기게 하지 말고, 함수를 수정해서 함수가 키와 몸무게를 입력받아서 BMI까지 계산하게 해보자.

```Haskell
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
    | weight / height ^ 2 <= 18.5 = "You're underweight, you emo, you!"
    | weight / height ^ 2 <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
    | weight / height ^ 2 <= 30.0 = "You're fat! Lose some weight, fatty!"
    | otherwise                 = "You're a whale, congratulations!"
```

내가 뚱뚱한 건지 한 번 봐봐..

```Haskell
ghci> bmiTell 85 1.90
"You're supposedly normal. Pffft, I bet you're ugly!"
```

와! 난 안 뚱뚱해! 하지만 Haskell은 나보고 못생겼다고 했어. 뭐 어때!

가드를 쓸 때 함수 이름과 인자 바로 옆에 `=`이 붙지 않는다는 것에 주의해. 많은 초보자들이 거기에 `=`을 집어넣어서 구문 오류를 발생시키곤 하지.

아주 간단한 또다른 예제가 있어. `max` 함수를 한 번 구현해보자. `max`함수는 비교될 수 있는 두 개의 인자를 받아서 그 중 더 큰 걸 돌려줘.

```Haskell
max' :: (Ord a) => a -> a -> a
max' a b 
    | a > b     = a
    | otherwise = b
```

가드는 한 줄에도 쓸 수 있어. 하지만 개인적으로는 이게 가독성이 떨어지기 때문에, 정말 짧은 함수가 아니라면 별로 권하고 싶지 않아. 만약 한 줄로 쓴다면 `max'` 함수는 아래처럼 되긴 할 거야.

```Haskell
max' :: (Ord a) => a -> a -> a
max' a b | a > b = a | otherwise = b
```

으윽! 정말 가독성이 떨어지는군.자, 다음으로 넘어가서, 이제 `compare` 함수를 가드를 이용해서 직접 구현해보자.

```Haskell
myCompare :: (Ord a) => a -> a -> Ordering
a `myCompare` b
    | a > b     = GT
    | a == b    = EQ
    | otherwise = LT
```

```Haskell
ghci> 3 `myCompare` 2
GT
```

> 주: 백틱(\`) 기호를 이용해서 함수를 중위(infix)에서 호출할 수 있을 뿐만 아니라, backtick을 이용해서 얘네들을 중위(infix)에서 정의할 수도 있어. 때론 이게 더 가독성이 좋아.

## Where!?

이전 섹션에서, 우리는 BMI 계산 함수를 정의했고 그건 아래처럼 우리를 질책했지.

```Haskell
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
    | weight / height ^ 2 <= 18.5 = "You're underweight, you emo, you!"
    | weight / height ^ 2 <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
    | weight / height ^ 2 <= 30.0 = "You're fat! Lose some weight, fatty!"
    | otherwise                   = "You're a whale, congratulations!"
```

여기서 우린 똑같은 걸 세 번이나 반복했어. 프로그래밍에서 이런 걸 세번 씩이나 반복해서 쓰겠다는 발상은 머릿속에서 쫓아내야돼. 여기서 같은 표현식이 세 번이나 반복되니까, 한 번만 계산한 다음에 여기에 이름을 붙여서 표현식 대신에 사용하는 게 이상적일거야. 좋아, 우리는 함수를 이런식으로 수정할 수 있어.

```Haskell
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
    | bmi <= 18.5 = "You're underweight, you emo, you!"
    | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
    | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"
    | otherwise   = "You're a whale, congratulations!"
    where bmi = weight / height ^ 2
```

키워드 `where`을 가드 뒤에 붙였어(보통 `where`은 `pipe`의 인덴트와 동일한 만큼 인덴트를 주는게 가장 좋아). `where` 절에서 여러 개의 이름이나 함수를 정의할 수 있어. 이 이름들은 가드 전체에서 쓸 수 있고 똑같은 걸 반복하도 되지 않게 해주지. 만약 BMI를 조금 다른 방식으로 계산하고 싶다면, 그냥 `where` 뒤에 있는 공식을 한 번만 바꿔주면 돼. 또 이건 특정한 개체에 이름을 붙임으로써 가독성을 높이고, `bmi` 같은 변수가 단 한 번만 계산되게 함으로써 프로그램의 속도도 빠르게 만들어줘. 조금 더 나아가서 우리 함수를 이런식으로 표현할 수 있어.

```Haskell
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
    | bmi <= skinny = "You're underweight, you emo, you!"
    | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"
    | bmi <= fat    = "You're fat! Lose some weight, fatty!"
    | otherwise     = "You're a whale, congratulations!"
    where bmi = weight / height ^ 2
          skinny = 18.5
          normal = 25.0
          fat = 30.0
```

어떤 함수의 `where` 절에서 정의된 이름들은 그 함수 내에서만 나타날 수 있어. 따라서 이게 다른 함수들의 이름 공간(`namespace`)을 어지럽히진 않을까 걱정하지 않아도 돼. 모든 이름들이 같은 줄에 맞춰서 정렬되어 있다는 걸 명심해. 이걸 적절하게 같은 줄에 맞추지 않으면, Haskell은 어디서 어디까지가 같은 블록의 일부인지를 알 수 없어서 혼란스러워하게 돼.

`where` 절은 함수의 서로 다른 패턴에까지 공유되지는 않아. 만약 한 함수의 여러 개의 패턴에서 공유되는 이름을 만들고 싶다면, 이건 전역적인 공간에서 정의해야만 해.

`where` 절에서도 패턴 매칭을 이용할 수 있어! 우린 위의 함수의 `where`절은 아래처럼 쓸 수 있지.

```Haskell
...
where bmi = weight / height ^ 2
      (skinny, normal, fat) = (18.5, 25.0, 30.0)
```

사람의 성과 이름을 받아서 그 이니셜을 돌려주는 정말 간단한 함수를 한 번 만들어보자.

```Haskell
initials :: String -> String -> String
initials firstname lastname = [f] ++ ". " ++ [l] ++ "."
    where (f:_) = firstname
          (l:_) = lastname
```

우린 이 패턴 매칭을 함수의 인자에서 직접적으로 수행할 수 있어(이게 더 짧고 직관적이야). 하지만 이건 그냥 `where`에서도 패턴 매칭이 잘 동작한다는 걸 보여주기 위한 예제일 뿐이야.

`where` 절에서 상수를 정의한 것처럼, 함수도 정의할 수 있어. 우리의 건강한 프로그래밍 테마에 맞춰서, 몸무게와 키쌍(pair)의 리스트를 받아서 BMI의 리스트를 돌려주는 함수를 만들어보자.

```Haskell
calcBmis :: (RealFloat a) => [(a, a)] -> [a]
calcBmis xs = [bmi w h | (w, h) <- xs]
    where bmi weight height = weight / height ^ 2
```

이게 다야! 이 예제에서 `bmi`를 함수로 소개한 이유는, 우리가 함수의 인자로부터 하나의 BMI를 계산해낼 수는 없기 때문이야. 우린 함수에서 넘어온 인자를 조사해서 모든 페어에 대해 서로 다른 BMI들을 각각 계산해야만 하지.

`where` 절도 중첩해서 사용할 수 있어. 함수를 만들 땐 관용적으로 도우미 함수(helper function)를 그 함수의 `where` 절에 만들고, 이 도우미 함수가 잘 동작하기 위한 도우미 함수를 다시 그 함수의 `where` 절에 정의할 수 있지.

## Let it be

`where` 절은 `let` 절과 굉장히 비슷해. `where` 절은 함수의 맨 마지막에서 변수를 묶을 수 있고(bind) 그걸 모든 가드를 포함한 전체 함수 정의에서 쓸 수 있는 구문론적 구조야. `let` 절은 어디서든 표현식과 변수를 묶을 수 있게 해주지만, 굉장히 지역적이고 따라서 가드 전체에서 쓰거나 하지는 못 해. Haskell에 있는 값을 그 이름과 묶기 위한 용도로 사용되는 다른 구조들과 마찬가지로, `let` 바인딩은 패턴 매칭을 위해 사용될 수 있어. `let` 절이 어떻게 동작하는 지 살펴보자! 아래는 원기둥의 겉넓이를 그 높이와 반지름을 이용해서 구하는 함수를 정의한 거야.

```Haskell
cylinder :: (RealFloat a) => a -> a -> a
cylinder r h =
    let sideArea = 2 * pi * r * h
        topArea = pi * r ^2
    in  sideArea + 2 * topArea
```

기본적인 형태는 `let <bindings> in <expression>` 이야. `let` 부분에서 정의한 이름은 `in` 이후 부분에서 나오는 표현식에서 사용가능해. 보이다시피, 이건 `where` 절을 이용해서도 구현할 수 있어. 이름들이 같은 줄에 맞춰서 정렬되어 있다는 것도 참고해. 그래서, `where` 절과 `let` 절 둘의 차이가 뭘까? 지금은 그냥 `let` 절은 값과 변수를 묶는 작업을 먼저 하고 그걸 쓰는 표현식이 나중에 나오는 반면 `where` 절은 그거랑 순서가 반대인 걸로만 보이지.

둘의 차이점은, `let` 절은 그 자체로 표현식이라는 거야. `where` 절은 단지 구문론적인 구조일 뿐이고. `if` 구문을 설명할 때 `if` 구문은 표현식이기 때문에 이걸 거의 어디서든 쓸 수 있다고 했던 거 기억나?

```Haskell
ghci> [if 5 > 3 then "Woo" else "Boo", if 'a' > 'b' then "Foo" else "Bar"]
["Woo", "Bar"]
ghci> 4 * (if 10 > 5 then 10 else 0) + 2
42
```

`let` 절에서도 이거랑 거의 똑같은 게 가능해.

```Haskell
ghci> 4 * (let a = 9 in a + 1) + 2
42
```

이건 지역적인 범위에서 쓰이는 함수를 만들 때에도 사용돼.

```Haskell
ghci> [let square x = x * x in (square 5, square 3, square 2)]
[(25,9,4)]
```

만약 한 줄에 여러 개의 변수를 묶고 싶다면, 당연히 줄을 맞추지 않아도 돼. 대신에 세미콜론(`;`)으로 구분하지.

```Haskell
ghci> (let a = 100; b = 200; c = 300 in a*b*c, let foo="Hey "; bar = "there!" in foo ++ bar)
(6000000,"Hey there!")
```

마지막 바인딩 뒤에는 세미콜론을 붙일 필요가 없지만, 붙이고 싶다면 붙여도 상관은 없어. 앞에서 말했던 것 처럼 `let` 바인딩과 함께 패턴 매칭을 사용할 수 있어. 이건 튜플을 그 원소들로 빠르게 분해해서 분해해서 이름을 붙이는 것 같은 작업에 굉장히 유용해.

```Haskell
ghci> (let (a,b,c) = (1,2,3) in a+b+c) * 100
600
```
`let` 절은 조건 제시형 리스트에서도 사용할 수 있어. 몸무게와 높이 페어의 리스트를 받아서 `bmi`를 계산하는 이전 예제를 `where` 절에서 보조 함수를 정의해서 쓰는 대신 조건 제시형 리스트 안에서 `let` 절을 이용하도록 고쳐보자.

```Haskell
calcBmis :: (RealFloat a) => [(a, a)] -> [a]
calcBmis xs = [bmi | (w, h) <- xs, let bmi = w / h ^ 2]
```

`let` 절을 조건 제시형 리스트에 술어를 쓰듯이 포함시킬 수 있어. 다만 이건 리스트를 필터링하진 않아. 이건 단지 이름과 값을 묶는 역할을 하지. 조건 제시형 리스트 내부의 `let` 절에서 정의된 이름들은 출력함수(파이프| 전의 부분)와 해당 바인딩(`let` 절) 이후에 오는 섹션들, 술어들에서만 사용할 수 있어. 따라서 이 함수가 뚱뚱한 사람들의 BMI만 리턴하도록 만들 수도 있어.

```Haskell
calcBmis :: (RealFloat a) => [(a, a)] -> [a]
calcBmis xs = [bmi | (w, h) <- xs, let bmi = w / h ^ 2, bmi >= 25.0]
```

`bmi` 라는 이름을 `(w,h) <- xs` 부분에서는 쓸 수 없어. 왜냐하면 얘네들은 `let` 절보다 앞에서 정의됐거든.

`let`절을 조건 제시형 리스트에서 쓸 때는 해당 이름이 사용되는 범위가 이미 정의되어 있기 때문에(리스트 내부로) `in` 부분을 빼먹어도 상관없어. 하지만, 술어에서 `let in` 절을 사용할 수도 있고, 이렇게 하면 `let` 절에서 정의된 이름들은 해당 술어부에서만 사용할 수 있지. `in` 파트는 GHCi에서 함수나 상수를 직접 정의할 때도 빼먹을 수 있어. 그렇게 하면, 이 이름들은 전체 상호작용 세션 내내 사용가능하게 되지.

```Haskell
ghci> let zoot x y z = x * y + z
ghci> zoot 3 9 2
29
ghci> let boot x y z = x * y + z in boot 3 4 2
14
ghci> boot
<interactive>:1:0: Not in scope: `boot'
```

`let`절이 정말 멋지다면 왜 `where` 절을 쓰는 걸까? 전부 `let`절을 쓰면 될텐데. 라고 물었어? 음, `let` 절은 표현식이고 굉장히 지역적이기 때문에, 모든 가드 내에서 통용해서 쓸 수 없어. 몇몇 사람들은 `where` 절이 이름을 쓰는 부분이 그걸 정의하는 부분보다 함수에서 앞에 있기 때문에 `where` 절을 더 선호해. `where`절을 쓰면, 함수의 본체가 함수의 이름과 타입 선언에 더 가까워지고 그게 어떻게 보면 더 가독성이 있거든.


## 케이스 표현식(case expressions)

많은 명령형 언어(C, C++, Java, 기타 등등)는 `case` 구문을 갖고 있고, 네가 한 번도 그걸로 프로그래밍해본 적이 없다해도 그게 뭔지는 대충 알 거야. `case` 구문은 어떤 변수를 취해서, 아마 케이스에 포함되지 않는 모든 값들에 대해 수행하는 코드 블록도 포함하면서, 해당 변수의 특정한 값에 대해 수행하는 코드 블록들을 만들어 놓은 것이지.

Haskell은 이 개념을 받아서 한 단계 업그레이드 시켰어. 그 이름이 암시하는 것처럼, 케이스 표현식은 `if else` 표현식이나 `let` 절과 마찬가지로 표현식이야. 값의 가능한 경우에 기반해서 평가하는 표현식일 뿐만 아니라, 패턴 매칭도 할 수 있어. 흠, 변수를 취해서, 패턴 매칭을 하고, 그 값에 따라서 코드 조각을 평가하고. 어디서 들어본 것 같지 않아?  그래, 함수 정의에서 인자에 따라 패턴 매칭을 하는 거랑 똑같아! 음, 이건 사실 실제로는 케이스 표현식의 간략화된 표현일 뿐이야. 이 두 조각의 코드는 완전히 똑같고 서로 바꿔쓸 수 있어.

```Haskell
head' :: [a] -> a
head' [] = error "No head for empty lists!"
head' (x:_) = x
```

```Haskell
head' :: [a] -> a
head' xs = case xs of [] -> error "No head for empty lists!"
                      (x:_) -> x
```

보다시피, 케이스 표현식의 구문은 굉장히 단순해.

```Haskell
case expression of pattern -> result
                   pattern -> result
                   pattern -> result
                   ...
```

`expression`은 패턴에 대응해서 매칭돼. 패턴 매칭은 예측한 것 그대로 동작해. 첫번째 패턴이 표현식과 매칭되는지 확인하고, 그게 실패하면 두 번째, 세번째... 하나도 맞는 패턴이 없다면 런타임 에러가 발생하겠지.

함수 인자에서의 패턴 매칭이 함수를 정의하는 것에만 사용될 수 있는 반면에, 케이스 표현식은 정말 거의 어디에서든 사용할 수 있어. 예를 들어보자.

```Haskell
describeList :: [a] -> String
describeList xs = "The list is " ++ case xs of [] -> "empty."
                                               [x] -> "a singleton list." 
                                               xs -> "a longer list."
```

이건 표현식의 중간쯤에서 어떤 것에 대해 패턴 매칭을 하고 싶을 때 유용해. 함수 정의에서의 패턴 매칭이 케이스 표현식의 간략화된 표현이기 때문에, 우린 이걸 아래처럼도 정의할 수 있어.

```Haskell
describeList :: [a] -> String
describeList xs = "The list is " ++ what xs
    where what [] = "empty."
          what [x] = "a singleton list."
          what xs = "a longer list."
```

 - 이전 챕터 : [03 - 타입과 타입클래스](03_TypesAndTypeclasses.md)
 - 다음 챕터 : [05 - 재귀](05_Recursion.md)