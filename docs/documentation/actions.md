# Actions

## Writing an Action

Each Action class should extend `Lantern\Features\Action` and there are several methods available.

### `perform`

The `perform()` method of your Action should contain the main task of the action and must return an ActionResponse, which is considered either `successful` or `unsuccessful`.

Any controller or artisan command can respond appropriately based on what is returned.

```php
public function perform(): \Lantern\Features\ActionResponse 
{
   //…
}
```

### `prepare`

Often, you will want to show some data to an end-user before performing an Action. Typically, when displaying data being
acted, e.g. in a form or for confirmation.

You don't necessarily want to have an Action just for this scenario (although you may), so you can define a
`public function prepare()` method on your Action to handle this.

```php
public function prepare(): array 
{
    //…
}
```

### `availability`

By default, each Action and Feature is available. With Availability, you declare a set of checks that must be passed before an Action is deemed available.

E.g. you might want to check:
- current user has a specific privilege
- current user was the owner of a particular resource

This will be done, much like testing, by asserting the result of different operations that you declare.

Availability is `runtime`, and depends on the specific context of any given request.

```php
protected function availability(Lantern\Features\AvailabilityBuilder $builder) 
{
    //…
}
```

For information on checking against availability in your code and the available methods within the  `AvailabilityBuilder` see [Availability.](availability.html)

### `constraints`

If an Action relies on a system-level dependency, then you can declare this as a Constraint. 
The `constraints` method can be called from either a `Feature` or `Action`

For an illustration of in what way you may want to use this see
[Features - Constraints - An illustration](features.html#constraints)

```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints) 
{
     //…
}
```

Please note that constraints can also be called from your [`Features`](/features.html)

For info on the available methods of the `ConstraintsBuilder` see [Constraints](constraints.html).

### ID of an Action

Each action has an `id`, which must be **unique across the `Feature` graph**.

The `id` is used as a simple reference from across your Laravel application, e.g. when [authorising an Action](/documentation/authorisation.html).

By default, the `id` is a `dash-cased` representation of the class name without the namespace, so `ClearCompletedTodos`
becomes `clear-completed-todos`.

The auto-generated `id` will probably be good enough for you. As long as you keep in mind that your class name must be
unique across your application, then it'll probably be just fine.

To override this default, simply declare a `const ID = ""` in your Action class:

```php
const ID = "my-new-action-name";
```


### Passing data to your Action
When performing an Action, you will want to pass data into it, to be worked upon.

1. Dependencies – typically other classes
2. Input – data that typically comes from user input

Dependencies should be declared in the `__construct()` method of your Action.
Input should be part of your `perform()` method, e.g.:

```php
public function perform($todoText, $completed = false) 
{
    //…
}
```

## Calling an Action

You call an `Action` like this:

```php
MyAction::make(...dependencies)->perform(...methodParameters);
```

`make()` will instantiate your action using the arguments passed in, but return an instance of `\Lantern\Features\ActionProxy`.

The ActionProxy ensures that the Action is [available](/documentation/actions.html#availability) to be performed within the current context.

Use the same approach to call `prepare()` where needed:

```php
MyAction::make(...dependencies)->prepare();
```


You can check availability using the `ActionProxy`, for example:

```php
if ($action = MyAction::make()->available()) {
    $action->perform();
}
```

:::danger Exceptions
The availability will be checked behind the scenes anyway, when you call `perform()`.

If `perform()` is called without checking availability and fails the check, a `Lantern\LanternException` will be thrown.
:::

## Guest users

By default, all Users are expected to be logged in to perform an `Action`.

If your `Action` is to be accessible to Guest Users, then you must flag this on the `Action`.

```php
const GUEST_USERS = true;
```
