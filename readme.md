`sudo npm install -g elm elm-test elm-format`

`elm repl` opens up an interactive programming session

https://frontendmasters.com/courses/intro-elm/

https://guide.elm-lang.org/

https://www.reddit.com/r/elm/comments/g1nonf/is_it_still_useful_to_learn_elm/fngpizy?utm_source=share&utm_medium=web2x&context=3

https://www.reddit.com/r/elm/comments/g1nonf/is_it_still_useful_to_learn_elm/fngpz49?utm_source=share&utm_medium=web2x&context=3

---

# Introduction to Elm, v2

## Introduction

There are several languages which compile to JS. CoffeeScript, Babel, TypeScript, Elm, ... 

Some of these are syntactically similar to JS. Elm is not.

## Costs & Benefits

**Costs**

- Not a cousin of JS - new syntax to learn
- Smaller ecosystem (no npm)
- Fewer web APIs have 1st class support

**Benefits**

Measurable technical advantages

- Bundles down small (preact, svelte, raw JS territory) vs. heavy frameworks like React, Angular, Vue
- Fewer runtime exceptions. Good compiler.

Makes hiring easier

- ???

Cohesive, high-quality ecosystem

- JS projects require a lot of hard decisions: Which dialect of React? - JS or TS, Babel? Which UI framework? - React, Vue, vanilla JS? What about state? Utilities? etc. Is it all compatible?
- Elm has a single ecosystem to handle everything

## Workshop Structure 

https://github.com/gothinkster/realworld

https://github.com/rtfeldman/elm-0.19-workshop/tree/master/intro

`Main.elm` compiles to `elm.js`

`elm make Main.elm --output elm.js` 

## Functions & if expressions

A fn in JS:

```js
let pluralize = 
    (sinular, plural, quantity) => {
        if (quantity === 1){
            return singular;
        } else {
            return plural;
        }
    };
```

Equivalent fn in Elm:

```elm
pluralize singular plural quantity =
	if quantity == 1 then
		singular
		
	else 
		plural
```

## Nested Function Expressions

Using the `pluralize` function in Elm:

```Elm
main = -- this is an inline comment
	text (pluralize "leaf" "leaves" 1)
```

parenthesis are used to disambiguate 

## Smart Compile Errors

Elm, like TS, catches a lot of errors at compile time.

Elm has type inference running everywhere. Really, everywhere! There's no `<any>` escape hatch that we have in TS!

## Virtual DOM

HTML describes the DOM structure.

e.g.

```html
<ul class="languages">
    <li>Elm</li>
    <li>JS</li>
</ul>
```

= this DOM tree:

<img src="img/image-20210316144334336.png" alt="image-20210316144334336" width="200" />

in Elm, we do it all with functions calls:

```elm
ul [ class "languages" ] 
  [ li [] [ text "Elm" ] 
  ,	li [] [ text "JS" ] -- commas on the left 
]
```

`elm-format` will do it like this!

## Intro Review + Q&A

**todo - get my tryElm working**

## Rendering a Page Exercise

[part1 exercise](./elm-0.19-workshop/intro/part1)

## Strings 

```elm
"foo" ++ "bar" -> "foobar" -- concatenation
```

`String.fromInt` to convert integers to strings 

```elm
String.fromtInt quantity ++ " " ++ singular
```

## let Expressions

```elm
pluralize singular plural quanity = 
	let
		quantityStr = 
			String.fromtInt quantity
			
		prefix = 
			quantityStr ++ " "
	in
	if quantity == 1 then
		prefix ++ singular
		
	else
		prefix ++ plural
```

^ indentation matters in Elm

## Lists

```elm
[ 1, 2, 3 ] -- under the hood it's an immuatable linked list 
```

```elm
[ "foo", 65 ] -- will not compile in Elm
```

One data type only. Stops problems like this in JS:

```js
["pow", "zap", "blam", 500].map(
	(str) => { return str.toUpperCase() + "!" }
)
// [ "POW!", "ZAP!", "BLAM!" ] for first 3 elements, then error!
// toUpperCase exists only for strings
```

## Anonymous Functions

```elm
List.map (\str -> String.toUpper str ++ "!")
	[ "pow", "zap", "blam" ]
-- [ "POW!", "ZAP!", "BLAM!" ]
```

## Partial Application

```elm
List.map (pluralize "leaf" "leaves") [ 0, 1, 2 ] -- forget the 3rd arg "num"

-- Elm returns this:
(\num -> pluralize "leaf" "leaves" num)

-- An anonymous fn with num to be provided once we have it
```

## Render a List to a View

<img src="img/image-20210316162307762.png" alt="image-20210316162307762" width=600 />

## Manipulating Values Exercise

[part2 exercise](./elm-0.19-workshop/intro/part2)

## Records

https://frontendmasters.com/courses/intro-elm/records/

```elm
record =
	{ name = "foo", x = 1, y = 3 }
-- same as JS except '=' instead of ':'

record.name -- ---> "foo"
record.x -- ---> 1
-- etc.
```

no prototypes, no **this**, no mutating - records hold plain, immutable data.

```elm
newRecord = 
	{ name = "bar" 
	, x = 1 
	, y = 3
	}
-- define using vertical layout with commas at start 
```

## Record Iteration

|             | **iteration** | **mixed entries** |
| ----------- | ------------- | ----------------- |
| **lists**   | supported     | unsupported       |
| **records** | unsupported   | supported         |

## Booleans

`True`, `False` - capitalised

```elm
x == y
not (x == y) -- ! in JS
x /= y -- also !=
x || y
x && y
```

## Boolean Operations

```elm
List.member 1 [ 1, 2, 3 ] -- is 1 a member of this list?
	True
	
List.member 9 [ 1, 2, 3 ]
	False
```

```elm
-- trying $ elm repl
> l = [ 1, 2, 3 ]
[1,2,3] : List number
> isKeepable num = 
l       :exit   :help   :quit   :reset
> isKeepable num =
|   num > 1
<function> : number -> Bool
> isKeepable
<function> : number -> Bool
> List.filter isKeepable l
[2,3] : List number
```

```elm
-- or inline with an anonymous fn
List.filter (\num -> num > 1 ) [ 1, 2, 3 ]
-- [2, 3]
```

## The Elm Architecture

<img src="img/image-20210317095729051.png" alt="image-20210317095729051" width=600 />

This runtime is bundled into the output JS everytime `make` is run.

<img src="img/image-20210317095955343.png" alt="image-20210317095955343" width=600 />

## The Elm Architecture: Update

```elm
update msg model = 
	{ model | selectedTag = "elm" }
-- keep model the same, but update selectedTag
```

```elm
-- e.g. of a msg
msg = {
	description = "ClickedTag"
	, data = "elm"
	}
```

```elm
-- update msg model
button
	[ onClick
    	{ description = "ClickedTag" 
    	, data = "elm"
    	}
	]
	[ text "elm" ]
```

## Interaction Exercise

[part 3 exercise](./elm-0.19-workshop/intro/part3)

`elm install <package name>`

## Type Annotation Overview

```elm
username : String
username = "rtfeldman"
```

Considered best practice to use them at least for your top-level declarations.

## Primitives & Records

```elm
totalPages : Int
totalPages = 5

isActive : Bool
isActive = True
```

```elm
add : Int -> Int -> Int
add a b =
    a + b
```

```elm
-- ":" is for types
searchResult : { name : String, stars: Int }
-- "=" is for values
searchResult = { name = "blah", starts = 215 }
```

## Parameters

```elm
names : List Strings -- names is a list of strings
-- Lists are a parameterized type. Lists need a type!
names = [ "Sam", "Casey", "Pat" ]

names : List Float
names = [ 1.1, 2.2, 3.3 ]

-- etc.
```

## Aliases

```elm
type alias Article = 
	{ title : String
	, tags : List String
	, body : String
	}
	
type alias Model = 
	{ selectedTag : String
	, articles : List Article
	}
	
-- more concise than writing a nested obj
```

## HTML Msg

```elm
view model = 
	button
		[ onClick 
			{ description = "ClickedClear" 
			, data = "ALL"
			}
		]
		[ text "X" ]
```

We don't have to pass a record message. It can be simplified to:

```elm
view : Model -> Html String
view model = 
	button [ onClick "ClickedClear" ] [ text "X" ]
```

as long as you are consistent with your format, e.g. `Html String`.

## Functions

```elm
type alias Msg =
	{ description : String
	, data : String
	}

view : Model -> Html Msg
view model = 


update : Msg -> Model -> Model
update msg model = 
```

## Type Annotations Exercise

[part 4 exercise](./elm-0.19-workshop/intro/part4)

## Case Expressions 

```elm
case model.tab of
	"YourFeed" -> 
		-- show Your Feed
	"GlobalFeed" ->
		-- show Global Feed
	_ ->
		-- show Tag Feed
```

## Variants & Booleans

```elm
type Tab =
	YourFeed | GlobalFeed | TagFeed -- custom type
```

could be implemented like:

```elm
yours : Tab
yours = 
	YourFeed
	
global : Tab
global = 
	GlobalFeed

tag : Tab
tag =
	TagFeed
```

Bool is actually a custom type:

```elm
type Bool
	= True
	| False
```

## Custom Types in Case Expressions

```elm
case model.tab of
	YourFeed -> 
		-- show your feed
	GlobalFeed ->
		-- show global feed
	TagFeed ->
		-- show tag feed
	
	-- no default case is better in Elm
```

## Containers

```elm
type Tab
	= YourFeed
	| GlobalFeed
	| TagFeed String
```

```elm
yours : Tab
yours =
	YourFeed
	
happiness : Tab
happiness = 
	TagFeed "happiness" -- must pass string now
```

```elm
case model.tab of
	YourFeed -> 
		-- show your feed
	GlobalFeed ->
		-- show global feed
	TagFeed selectedTag -> -- e.g. passing in "happiness"
		-- show tag feed
```

Now `Tab` is a container that situation-ally holds information (when on TagFeed).

"Custom types are the most important feature of Elm"
	-- The creator of Elm

## Custom Types in Messages

```elm
type alias Msg = 
	{ description : String
	, stringData : String
	, intData : Int
	}
	
	{ description : "ClickedTag"
	, stringData : "cars"
	, intData : -1 -- need to set to sth like -1 because we don't need it
	}
	
	{ description : "ClickedPage"
	, stringData : "" -- need to set to "" because we don't need it
	, intData : 2
	}
```

^ This is what happens when you use records as messages in Elm. You end up fudging the record so it interacts properly.

Consider this, instead:

```elm
type Msg
	= clickedTag String
	| clickedPage Int
```

^ We clicked *either* a tag or a page.

```elm
update msg model = 
	case msg of
		ClickedTag selectedTag ->
			-- use tag here
		ClickedPage page ->
			-- use page here
```

Custom types work great with messages!

 ```elm
type Msg
	= clickedTag String
	| clickedPage Int
	
pageButton : Int -> Html Msg
pageButton pageNumber = 
	button [ onClick (ClickedPage pageNumber) ] [ text (String.fromInt pageNumber) ]
 ```

## Custom Types Exercise 

[part 5 exercise](./elm-0.19-workshop/intro/part5)

`elm make src/Main.e
lm --output ../server/public/elm.js`

run server from `/intro/server` :

```
npm install
npm start
```

## Maybe Overview

consider this JS snippet:

```js
> first = (users) => {
... return users[0];
... }
[Function: first]
> first(["Sam", "Jess"])
'Sam'
> first([])
undefined

> const newUsers = ["Sam", "Jess"]
undefined
> first(newUsers).length
3
// but if newUsers = [], we'd get an error: Uncaught TypeError: Cannot read property 'length' of undefined
```

and in Elm:

```elm
> first users = List.head users
<function> : List a -> Maybe a
> first ["Sam", "Jess"]
Just "Sam" : Maybe String
> first []
Nothing : Maybe a

> newUsers = ["Sam", "Jess"]
["Sam","Jess"] : List String
> case first newUsers of
|   Just user ->
|       String.length user
|   Nothing ->
|       0
3 : Int
-- or 0 when newUsers = []
-- because we define the [] case, we don't get an error like in JS
```

```elm
> List.head [ "Sam", "Jess" ]
Just "Sam" : Maybe String
> List.head [ 3.14, 7.77 ]
Just 3.14 : Maybe Float
> List.head [ True, False ]
Just True : Maybe Bool
> -- what type is List.head ???
List.head : List elem -> Maybe elem
```

`elem` is a **Type Variable**

```elm
-- e.g.
List.reverse : List item -> List item
List.reverse   [ 1, 2, 3 ] -> [ 3, 2, 1 ]
```

what is the type of Maybe?

```elm
type Maybe val -- val is a type variable
	= Just val
	| Nothing
```

^ this allows us to have Maybes of different types

## Pipelines & Review

```elm
-- e.g.
> List.reverse (List.filter (\x -> x < 5) [ 2, 4, 6 ])
[4,2] : List number

-- or in pipeline style:
> [ 2, 4, 6 ] 
	|> List.filter(\x -> x < 5) 
	|> List.reverse
[4,2] : List number
```

^ esepcially with big pipelines, sometimes assigning intermediate values and breaking a pipeline up is better!

## Maybe & Pipelines Exercise

[part 6 exercise](./elm-0.19-workshop/intro/part6)

## Decoding

in JS:

```js
parseInt "42" --> 42
parseInt "hi" --> NaN
```

in Elm:

```elm
case String.toInt str of
	Just num ->
		num * 10
	
	Nothing ->
		0
```

```elm
String.toInt "42" --> Just 42
String.toInt "hi" --> Nothing
--
type Maybe val
	= Just val
	| Nothing
```

## Pipeline Decoding:

Consider this JSON:

```json
{
    "user_id": 27,
    "first_name": "Al",
    "last_name": "Kai"
}
```

```elm
type alias User =
	{ id : Int 
	, firstName : String
	, lastName : String
	}
```

Field names don't need to match `user_id --> id` etc.

Types don't need to map too. Can be mapped to a custom type, for example.

Let's write a JSON decoder:

```elm
user : Decoder User
user =
	Json.Decode.succeed User -- if decoding succeeds, use this fn to build the result
		|> required "user_id" int -- Json.Decode.Int
		|> required "first_name" string -- Json.Decode.String
		|> required "last_name" string -- Json.Decode.String
```

## Optional & Nullable

consider this:

```json
{
    "user_id": 27,
    "name": null
}
```

```elm
type alias User =
	{ id : Int
	, name : Maybe String
	, email : String
	}
```

```elm
user : Decoder User
user = 
	Json.Decode.succeed User
		|> required "user_id" int -- null not OK! --> we want to fail
		|> required "name" (nullable string) -- here we say that it can be null, that's OK
		|> optional "email" string "me@foo.com" -- if not present, fallback on default
```

## Decoding JSON Exercise

[part 7 exercise](./elm-0.19-workshop/intro/part7)











