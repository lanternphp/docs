# Availability

We can declare whether an Action or its associated Feature is available through the use of the `availability` method 

When Lantern checks an Action's availability, it also checks the availability of its direct parent Feature.

This allows multiple `Actions` to inherit availability but introduces an important restriction:

:::warning Inheritance
The Feature of an Action must have a signature that will allow it to be instantiated without arguments
being passed to its `__construct()` method.
:::

# AvailabilityBuilder

When you declare the availabilty of an `Action` you will use the `AvailabilityBuilder`

```php
protected function availability(Lantern\Features\AvailabilityBuilder $builder) {
    //…
}
```

### Available methods

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
public function assertTrue(bool $value)
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
public function assertFalse(bool $value)
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
public function assertNull($value)
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
public function assertEqual($expected, $other)
```

</code-block>

</code-group>

:::tip Authorisation

For more info on using these Availability checks in your app,
look at [the docs on authorisation](/documentation/authorisation.html).

:::





