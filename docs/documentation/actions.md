# Actions

## Writing an Action

Each Action class should extend `Lantern\Features\Action` and there are several methods available.

**Example: Creating a Todo Item**

Let's illustrate with an example Action that creates a new todo item.

```php
<?php

namespace App\Features\Todos\Actions;

use App\Models\Todo;
use App\Services\TodoRepository;
use Illuminate\Support\Facades\Auth;
use Lantern\Features\Action;
use Lantern\Features\ActionResponse;
use Lantern\Features\AvailabilityBuilder;

class CreateTodoAction extends Action
{
    // Define a unique ID (optional, defaults to 'create-todo-action')
    const ID = 'todos:create';

    // Inject dependencies via the constructor
    public function __construct(private TodoRepository $todoRepository)
    {
    }

    // Define the main logic in the perform method
    public function perform(string $taskDescription): ActionResponse
    {
        // Example: Basic validation or authorization
        if (empty($taskDescription)) {
            return $this->failure('Task description cannot be empty.');
        }

        // Perform the core action
        $todo = $this->todoRepository->create([
            'user_id' => Auth::id(),
            'description' => $taskDescription,
            'completed' => false,
        ]);

        if ($todo) {
            return $this->success('Todo created successfully.', ['todo_id' => $todo->id]);
        } else {
            return $this->failure('Failed to create todo.');
        }
    }

    // Optional: Define availability checks
    protected function availability(AvailabilityBuilder $builder): void
    {
        // Example: Ensure the user is logged in (though Actions require login by default)
        $builder->mustBeAuthenticated();

        // Example: Check if the user has a specific permission (requires custom logic)
        // $builder->assert('user_can_create_todos', fn() => Auth::user()->can('create', Todo::class));
    }

    // Optional: Define data preparation logic
    public function prepare(): array
    {
        // Example: Return data needed for a form (e.g., categories)
        return [
            'available_categories' => ['Work', 'Personal', 'Urgent'],
        ];
    }
}
```

This example shows:
- Extending `Lantern\Features\Action`.
- Injecting a `TodoRepository` dependency.
- Defining the `perform` method with input (`$taskDescription`) and returning an `ActionResponse`.
- Optionally defining `availability` checks using `AvailabilityBuilder`.
- Optionally defining a `prepare` method to return data.
- Setting a custom `ID`.

### `perform`

The `perform()` method of your Action should contain the main task of the action and must return an ActionResponse, which is considered either `successful` or `unsuccessful`.

You should use the `$this->success()` and `$this->failure()` methods to return responses from your action. Both methods accept a message and optional data array.

Any controller or artisan command can respond appropriately based on what is returned.

```php
public function perform(/* ... parameters ... */): \Lantern\Features\ActionResponse
{
   // Your core logic here...

   // Return success with message and optional data
   return $this->success('Operation completed successfully', ['key' => 'value']);

   // Or return failure with message
   return $this->failure('Operation failed: reason');
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
