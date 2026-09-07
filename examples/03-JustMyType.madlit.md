---
IO: IO
List: List
Just |: Maybe
---

Types are where Madlib really shines.

If you've worked in Haskell before, these are _mostly_ the same types you're used to. See [[Coming from Haskell]] for a brief overview of the differences. There is also a [[Coming From JavaScript]] page.

For the built-in types of [[Prelude]], there are a number of more specific pages you can peruse; for this document we'll primarily talk about custom / user-defined types, and aliases, which are effectively a shorthand for referencing types.

# Types

First we'll give a few examples of some custom type definitions to give you a feel for the versatility and expressiveness of this:

```madlib
type Whatever = Whatever
type Reference = Unknown | Known(String)
type Color = Hex(String) | RGB(Integer, Integer, Integer)
export Suit = Hearts | Diamonds | Spades | Clubs
export type Card = Card(Suit, Integer)
type Character a b = Character(String, String, List a, b)
```

Now we'll break down these examples:

## Syntax

Let's break down how we define a type.

1. A type can define a single constructor, which must start with a capital letter, e.g. `type TypeName = Constructor` defines a Constructor named constructor of type TypeName
2. A type can define multiple constructors, which must start with a capital letter, e.g. `type Critter = Bug | Creepy | Crawly` defines a type Critter which has three singleton constructors, "Bug", "Creepy" and "Crawly"
3. A type can contain other types. These can be [[literal types]], e.g. `type Receipt = Receipt(Integer)`
4. A type can contain other types. These can be type variables, e.g. `type Order a = Order(Integer, a)`
5. A type can contain other types, e.g. `type Order a = Order(Integer, List a)`. This includes custom types: `type Superorder = Superorder(Integer, List (Order a))`.
6. A type can optionally be exported, which makes it usable outside of the file it is defined in, using the `export` keyword, e.g. `export type Type = Constructor`

## Constructors

Constructors are formal values which represent a concrete type that the compiler understands.

## Singleton

A type constructor can have zero to many values within it. A type constructor with zero values is called a singleton. 

We can use a singleton to express something which might otherwise be a representative literal in other languages as a full type:

```madlib#singleton
type Cycle = Day | Night | Dusk
type Arachnid = Spider | Scorpion | Tick | Mite | Other
```

This allows us to express the types in [[type signatures]], such as:
```madlib
isSpider :: Arachnid -> Boolean
isSpider = where {
  Spider => true
  _ => false
}
```

Note that we're using the name of the type ("Arachnid") here rather than one of the constructors. The type should be used in signatures. The constructors should be used in code.


## Container types

Unlike a singleton, a container type constructor has values within it. Thus it can have many different instances. These interior values can be types or type variables. 

### Container types with literal values

```madlib
type Ingredient = Ingredient(String, Integer)
type Pizza = Pizza(String, List Ingredient)
```


We have to pass these values to the constructor in order to create the instance.

```madlib
redSauce = Ingredient("Tomato Sauce", 0.3)
pestoSauce = Ingredient("Pesto", 0.3)
cheese = Ingredient("Mozzarella Cheese", 0.5)
pepperoni = Ingredient("Pepperoni", 4)
corn = Ingredient("Corn", 0.23)
habanero = Ingredient("Habanero", 2)

pizzaCheese = Pizza("Cheese", [redSauce, cheese])
pizzaPesto = Pizza("Pesto Pie", [pesto, cheese])
pizzaHotPeppercorn = Pizza("Hot Peppercorn", [cheese, pepperoni, corn, habanero])
```

We can use `where` to access these interior values (or similar sugar).

```madlib
ingredientName :: Ingredient -> String
ingredientName = where {
  Ingredient(_name, _) => _name
}

ingredientCost :: Ingredient -> Integer
ingredientCost = where {
  Ingredient(_, _cost) => _cost
}

pizzaName :: Pizza -> String
pizzaName = where {
  Pizza(_name, _) => _name
}

pizzaIngredients :: Pizza -> List Ingredients
pizzaIngredients = where {
  Pizza(_, _ing) => _ing
}
```

### Container types with type variables

We can also define container types with a type variable, which allows us to define polymorphic types. (We can also constrain these variables, but that is beyond the scope of this document.)

```madlib
type Box a = Box(a)
type Relation a b = Orthogonal(b) | Related(a)
```

We can create instances like so:
```madlib
shipping = Box("balikbayan")
bento = Box("lunch")
unrelated = Orthogonal("Irrelevant")
unrelatedYear = Orthogonal(2020)
```

It is invalid to attempt to mix types. For instance, given the above
```madlib#_
list = [unrelated, unrelatedYear]
```

Will create a type error. This is because we've defined a value with a single value `b` for the Orthogonal constructor. It can either be a String or an Integer, but not both.  

However, because of how we've defined it, we _can_ have a list of values that are different type variables:

```madlib
list2 = [Orthogonal(200), Related("strongly")]
```

This is because, per the `Relation` type's definition, in `list2`, `b` is an Integer, and `a` is a String.

#### Challenge

Can you define a function named `pizzaCost` that leverages the above functions to get the cost of a pizza based on its ingredients?

```madlib
pizzaCost = pipe(
  pizzaIngredients,
  map(ingredientCost),
  List.reduce((a, b) => a + b, 0)
)
```



A commonly used type in Prelude is [[Maybe|Nothing]], which we use to express one of two possible / "maybe" values: `type Maybe a = Just(a) | Nothing`. [[Maybe|Nothing]] is a singleton. [[Maybe|Just]] is a container type.


## Summary
- Types
- Type Inference
- Literal Types
- Aliases
- Pipe & Curry
