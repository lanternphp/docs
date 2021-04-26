# Constraints & Availability

We can declare whether an Action or its associated Feature is available. 

This moves the `system` and `runtime` requirements closer to where they're needed.

By default, each Action and Feature is available. There are 2 methods we can override
enabling us to customise this behaviour:

- `constraints(ConstraintsBuilder $constraints)` – for any system-level constraints, e.g. checking for a required binary.
- `isAvailable($user)` – for any run-time checks, e.g. the current user has relevant permissions.

When Lantern checks an Action's availability, it also checks the availability of its direct parent Feature.

This allows multiple `Actions` to inherit availability but introduces an important restriction:

:::warning Inheritance
The Feature of an Action must have a signature that will allow it to be instantiated without arguments
being passed to its `__construct()` method.
:::

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

### Check availability for a different user

Typically, you will want to check if a given Action is available to the current logged in user.

However, it can be useful to check the Availability of a different user.
E.g. if you list out the users belonging to a company in your app, and have certain Actions only
available to certain users.

```php
if ($action = MyAction::make()->available($otherUser)) {
    $action->perform();
}
```

:::tip Authorisation

For more info on using these Availability checks in your app, 
look at [the docs on authorisation](/documentation/authorisation.html). 

:::

## Constraints

If a Feature or Action relies on a system-level dependency, then you can declare this as a
Constraint.

If any declared Constraints of a Feature fail to be met then all of its declared Actions will
become unavailable. 

### An illustration
Let us say that your app has a Feature that allows a profile picture to be uploaded and resized.
 
This Feature depends on the `convert` binary being present on the command line. 

Let's say that, during a server migration, a new server is set-up but ImageMagick is not installed
and `convert` is missing.

You're happy everything seems to have moved over well and appears to be working.

#### Scenario 1: without Constraints

1. Some time the next day, you get an email from a customer saying:
    > I'm seeing a server error in your app.
1. You investigate, go back & forth with the customer, trawl through your Laravel logs and realise your mistake.
1. You rush to fix the problem before more customers get the error.

#### Scenario 2: with Constraints

1. Some time the next day, you get an email from a customer saying: 
   > I can't find the button to upload my new profile picture.
1. You know the Constraint has failed, and realise immediately your mistake.
1. No errors or Exceptions, with a cool head you grab a coffee and set about fixing the problem.

------
It's a totally different way of handling the same problem, which leaves you looking more professional. 

## Declaring Constraints

If your Feature or Action has Constraints to declare, then you must add the following to your class:

```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints)
{
    //
}
```

### `executableIsInstalled()`

Ensure a specific binary is present on your system.

<code-group>

<code-block title="Method signature">
```php
public function executableIsInstalled($executableName): ConstraintsBuilder
```

</code-block>

<code-block title="Usage">
```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints)
{
    $constraints->executableIsInstalled('convert');
}
```
</code-block>

</code-group>

:::tip Paths
When Lantern searches for an executable, it must search certain paths on the server.

These paths can be [configured in your AppServiceProvider](/documentation/configuration.html#pathdirs).
:::


### `extensionIsLoaded()`

Ensure a particular PHP extension is loaded.

<code-group>

<code-block title="Method signature">
```php
public function extensionIsLoaded($extensionName): ConstraintsBuilder
```

</code-block>

<code-block title="Usage">
```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints)
{
    $constraints->extensionIsLoaded('zip');
}
```
</code-block>

</code-group>

:::tip What extensions do you have?

To check the extensions loaded in your environment:
```bash
php -m
``` 
:::

## Availability

With Availability, you declare a set of checks that must be passed before an Action is deemed available.

E.g. you might want to check:
- current user has a specific privilege
- current user was the owner of a particular resource

This will be done, much like testing, by asserting the result of different operations that you declare.

Availability is run-time, and depends on the specific context of any given request.

## Declaring Availability

If your Action has Availability restrictions to declare, and many will, then you must add the following to your class:

```php
<?php
namespace MyTodos\Features\TodoList;

use Lantern\Features\Action;
use Lantern\Features\ActionResponse;
use Lantern\Features\AvailabilityBuilder;

class AddTodo extends Action
{
    protected function availability(AvailabilityBuilder $availabilityBuilder)
    {
        //
    }

    // …
}
```

### `user()`

Returns the user to use for your checks.

<code-group>

<code-block title="Method signature">
```php
/**
 * @return mixed your User object
 */
public function user()
```

</code-block>

<code-block title="Usage">
```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $user = $availabilityBuilder->user();
}
```
</code-block>

</code-group>


:::danger Auth::user()

Although `Auth::user()` is used as the default user for checking availability, it is possible that
an Action is being checked against a different user.

For this reason, never get your user object from `Auth::user()` from within `protected function availability(){}`.

:::

### `userCan()`

Check [Laravel's authorisation policy](https://laravel.com/docs/master/authorization#via-the-user-model)
for a given ability. 

<code-group>

<code-block title="Method signature">
```php
public function userCan($ability, $arguments = []): AvailabilityBuilder
```

</code-block>

<code-block title="Usage">
```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->userCan('access-company', $company);
}
```
</code-block>

</code-group>

### `userCannot()`

The opposite of `userCan()`. 

<code-group>

<code-block title="Method signature">
```php
public function userCannot($ability, $arguments = []): AvailabilityBuilder
```

</code-block>

<code-block title="Usage">
```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->userCannot('access-company', $company);
}
```
</code-block>

</code-group>

### `assertTrue()`

Check if an expression is `true`. 

<code-group>

<code-block title="Method signature">
```php
public function assertTrue(bool $value)
```

</code-block>

<code-block title="Usage">
```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->assertTrue(
        $availabilityBuilder->user->isSuperUser
    );
}
```
</code-block>

</code-group>

### `assertFalse()`

Check if an expression is `false`.

<code-group>

<code-block title="Method signature">
```php
public function assertFalse(bool $value)
```

</code-block>

<code-block title="Usage">
```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->assertFalse(
        $availabilityBuilder->user->isSuspended
    );
}
```
</code-block>

</code-group>

### `assertNull()`

Check if an expression is `null`.

<code-group>

<code-block title="Method signature">
```php
public function assertNull($value)
```

</code-block>

<code-block title="Usage">
```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->assertNull(
        $availabilityBuilder->user->photo
    );
}
```
</code-block>

</code-group>

### `assertEqual()`

Check if 2 expressions are `equal` in value (`==` not `===`).

<code-group>

<code-block title="Method signature">
```php
public function assertEqual($expected, $other)
```

</code-block>

<code-block title="Usage">
```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->assertEqual(
        $availabilityBuilder->user()->id,
        $this->checklist->user_id
    );
}
```
</code-block>

</code-group>