# Availability

We can declare whether an Action or its associated Feature is available through the use of the `availability` method

When Lantern checks an Action's availability, it also checks the availability of its direct parent Feature.

This allows multiple `Actions` to inherit availability but introduces an important restriction:

:::warning Inheritance
The Feature of an Action must have a signature that will allow it to be instantiated without arguments
being passed to its `__construct()` method.
:::

## AvailabilityBuilder

When you declare the availabilty of an `Action` you will use the `AvailabilityBuilder`

```php
protected function availability(Lantern\Features\AvailabilityBuilder $builder) {
    //…
}
```

## Available methods

**Examples of Availability Checks**

Here are some examples of how you might define checks within the `availability` method of an Action or Feature, using the `$builder` object.

```php
<?php

namespace App\Features\Todos\Actions;

use App\Models\Todo;
use App\Services\TodoRepository;
use Lantern\Features\Action;
use Lantern\Features\ActionResponse;
use Lantern\Features\AvailabilityBuilder;

class UpdateTodoAction extends Action
{
    public function __construct(private TodoRepository $todoRepository, private Todo $todo)
    {
        // The specific Todo model is passed in
    }

    public function perform(string $newDescription): ActionResponse
    {
        // ... action logic ...
        return ActionResponse::successful('Todo updated.');
    }

    protected function availability(AvailabilityBuilder $builder): void
    {
        // 1. Ensure the user is authenticated (redundant if GUEST_USERS is false, but good practice)
        $builder->mustBeAuthenticated('User must be logged in to update todos.');

        // 2. Use Laravel Policy: Check if the user 'can' update the specific $todo model
        $builder->userCan('update', $this->todo, 'User does not have permission to update this specific todo.');

        // 3. Custom Logic: Check if the todo is not already completed
        $builder->assertFalse($this->todo->is_completed, 'Cannot update a completed todo.');

        // 4. Custom Logic: Check if the user owns the todo (alternative to policy)
        $builder->assertEqual($builder->user()->id, $this->todo->user_id, 'User must own the todo to update it.');

        // 5. Check Parent Feature: Ensure the parent 'TodosFeature' is available
        // Assuming TodosFeature exists and might have its own availability checks (e.g., subscription status)
        // $builder->featureAvailable(TodosFeature::class, 'Todo management is currently disabled.');
    }
}
```

**Explanation of Examples:**

1.  `mustBeAuthenticated()`: A built-in check ensuring a user is logged in. The string is the optional failure message.
2.  `userCan('update', $this->todo)`: Leverages Laravel's authorization. It checks if the `$builder->user()` (the current user by default) has the `update` ability for the provided `$this->todo` model instance, according to your `TodoPolicy`.
3.  `assertFalse($this->todo->is_completed)`: A generic assertion checking if the `is_completed` property of the todo is `false`.
4.  `assertEqual($builder->user()->id, $this->todo->user_id)`: Compares the current user's ID with the todo's `user_id`.
5.  `featureAvailable(TodosFeature::class)`: Checks if the specified parent Feature class passes its *own* availability checks. (This method might require adding it to your custom extended `AvailabilityBuilder` if not present in the base class, or it might be available in newer versions).

:::tip Debugging availability
It is often helpful in development to see why an `Action` is failing the availability checks. With all the `assert…` methods below, you have the option of providing a `$failureMessage`. This can be inspected when using the `gate` collector of the [Laravel Debugbar](https://github.com/barryvdh/laravel-debugbar).
:::

### `user()`

Returns the user to use for your checks.

<code-group>

<code-block title="Usage">
```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $user = $availabilityBuilder->user();
}
```
</code-block>

<code-block title="Method signature">
```php
/**
 * @return mixed your User object
 */
public function user()
```

</code-block>

</code-group>


`Auth::user()` is used as the default user for checking availability and typically, you will want to check if a given Action is available to the current logged in user.

However, it can be useful to check the Availability of a different user.
E.g. if you list out the users belonging to a company in your app, and have certain Actions only
available to certain users.

In order to check the availablity for a different user in this way pass the user through as an argument to the `available` method

```php
if ($action = MyAction::make()->available($otherUser)) {
    $action->perform();
}
```

:::danger Auth::user()

As it is possible to check an Action against a user other than the logged in user you should
never get your user object from `Auth::user()` from within `protected function availability(){}`.

:::

### `userCan()`

Check [Laravel's authorisation policy](https://laravel.com/docs/master/authorization#via-the-user-model)
for a given ability.

<code-group>


<code-block title="Usage">
```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->userCan('access-company', $company);
}
```
</code-block>

<code-block title="Method signature">
```php
public function userCan($ability, $arguments = []): AvailabilityBuilder
```

</code-block>

</code-group>

### `userCannot()`

The opposite of `userCan()`.

<code-group>

<code-block title="Usage">
```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->userCannot('access-company', $company);
}
```
</code-block>

<code-block title="Method signature">
```php
public function userCannot($ability, $arguments = []): AvailabilityBuilder
```

</code-block>

</code-group>

### `assertTrue()`

Check if an expression is `true`.

<code-group>

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

<code-block title="Method signature">
```php
public function assertTrue(bool $value, $failureMessage = 'value passed to `assertTrue` is false')
```

</code-block>

</code-group>

### `assertFalse()`

Check if an expression is `false`.

<code-group>

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

<code-block title="Method signature">
```php
public function assertFalse(bool $value, $failureMessage = 'value passed to `assertFalse` is true')
```

</code-block>

</code-group>

### `assertNull()`

Check if an expression is `null`.

<code-group>

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

<code-block title="Method signature">

```php
public function assertNull($value, $failureMessage = 'value passed to `assertNull` is not null')
```

</code-block>

</code-group>

### `assertNotNull()`

Check if an expression is not `null`.

<code-group>

<code-block title="Usage">

```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->assertNotNull(
        $availabilityBuilder->user->photo
    );
}
```

</code-block>

<code-block title="Method signature">

```php
public function assertNotNull($value, $failureMessage = 'value passed to `assertNotNull` is null')
```

</code-block>

</code-group>

### `assertEmpty()`

Check if an expression is empty.

<code-group>

<code-block title="Usage">

```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->assertEmpty(
        $availabilityBuilder->user->settings
    );
}
```

</code-block>

<code-block title="Method signature">

```php
public function assertEmpty($value, $failureMessage = 'value passed to `assertEmpty` is not empty')
```

</code-block>

</code-group>

### `assertNotEmpty()`

Check if an expression is not empty.

<code-group>

<code-block title="Usage">

```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->assertNotEmpty(
        $availabilityBuilder->user->settings
    );
}
```

</code-block>

<code-block title="Method signature">

```php
public function assertNotEmpty($value, $failureMessage = 'value passed to `assertNotEmpty` is empty')
```

</code-block>

</code-group>

### `assertEqual()`

Check if 2 expressions are `equal` in value (`==` not `===`).

<code-group>

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

<code-block title="Method signature">

```php
public function assertEqual($expected, $other, $failureMessage = 'values passed to `assertEqual` are not equal')
```

</code-block>

</code-group>

### `assertNotEqual()`

Check if 2 expressions are not `equal` in value (`==` not `===`).

<code-group>

<code-block title="Usage">

```php
protected function availability(AvailabilityBuilder $availabilityBuilder)
{
    $availabilityBuilder->assertNotEqual(
        $availabilityBuilder->user()->id,
        $this->company->owner_user_id
    );
}
```

</code-block>

<code-block title="Method signature">

```php
public function assertNotEqual($expected, $other, $failureMessage = 'values passed to `assertNotEqual` are equal')
```

</code-block>

</code-group>

:::tip Authorisation

For more info on using these Availability checks in your app,
look at [the docs on authorisation](/documentation/authorisation.html).

:::

## Customising availability checks

:::details Since version 1.1.0

See [releases on Github](https://github.com/lanternphp/lantern/releases/tag/1.1.0)

:::

The base [`AvailabilityBuilder`](https://github.com/lanternphp/lantern/blob/master/src/Features/AvailabilityBuilder.php#L21)
offers only the rudimentary assertions you see above, but as you begin to flesh out your domain model
you will quickly want to add a little more meaning to your checks.

To achieve this, you can extend the `AvailabilityBuilder` with a child class of your own.


<code-group>

<code-block title="Configuration">

```php
Lantern\Lantern::useCustomAvailabilityBuilder(CustomAvailabilityBuilder::class);
```

</code-block>

<code-block title="Custom Availability Builder">

```php
<?php

use Illuminate\Auth\Access\Response;

class CustomAvailabilityBuilder extends \Lantern\Features\AvailabilityBuilder
{
    public function assertHappy($value, $failureMessage = 'value passed to `assertHappy` is sad'): self
    {
        $this->checks[] = function () use ($value, $failureMessage): Response {
            if ($value == 'happy') {
                return Response::allow();
            }

            return Response::deny($failureMessage);
        };

        return $this;
    }
}
```

</code-block>

<code-block title="Action">

```php
<?php

use \Lantern\Features\Action;
use \Lantern\Features\AvailabilityBuilder;

class ActionUsingCustomAvailabilityBuilder extends Action
{
    /**
     * @param CustomAvailabilityBuilder|AvailabilityBuilder $availabilityBuilder
     * @return void
     */
    protected function availability(AvailabilityBuilder $availabilityBuilder)
    {
        $availabilityBuilder->assertHappy('happy');
    }
}
```

</code-block>

</code-group>





