# Actions

## Writing an Action

Each Action class should extend `Lantern\Features\Action` and there are several methods available.

**Example: Creating a Todo Item**

Let's illustrate with an example Action that creates a new todo item.

```php
<?php

namespace App\Features\Todos;

use App\Models\Todo;
use App\Services\TodoRepository;
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
            // Note: success() only accepts data, not a message
            return $this->success(['message' => 'Todo created successfully.', 'todo_id' => $todo->id]);
        } else {
            // Note: failure() accepts errors and optional data
            return $this->failure('Failed to create todo.');
        }
    }

    // Optional: Define availability checks
    protected function availability(AvailabilityBuilder $builder)
    {
        // Always use the user from the builder since this may not be the logged in user
        // for example, in an admin panel listing users
        $user = $builder->user();
        
        $builder->assertTrue($user->hasActiveSubscription(), 'User must have an active subscription to create todos.');
    }

    // Optional: Define data preparation logic
    public function prepare(): ActionResponse
    {
        // Example: Return data needed for a form (e.g., categories)
        return $this->success([
            'available_categories' => ['Work', 'Personal', 'Urgent'],
        ]);
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

You should use the `$this->success()` and `$this->failure()` methods to return responses from your action:

- `$this->success($data = null)`: Returns a successful response with optional data
- `$this->failure($errors = null, array $data = [])`: Returns a failure response with optional errors and data

Any controller or artisan command can respond appropriately based on what is returned.

```php
public function perform(/* ... parameters ... */): \Lantern\Features\ActionResponse
{
   // Your core logic here...

   // Return success with data
   return $this->success(['message' => 'Operation completed successfully', 'key' => 'value']);

   // Or return failure with errors
   return $this->failure('Operation failed: reason');

   // Or return failure with errors and data
   return $this->failure('Operation failed: reason', ['additional' => 'context']);
}
```

### `prepare`

Often, you will want to show some data to an end-user before performing an Action. 
Typically, when displaying data being acted upon, e.g. in a form or for confirmation.

You don't necessarily want to have an Action just for this scenario (although you may), so you can define a
`public function prepare()` method on your Action to handle this.

```php
public function prepare(): ActionResponse
{
    // Prepare data for a form or confirmation
    $data = [
        'options' => ['Option 1', 'Option 2'],
        'defaults' => ['selected' => 'Option 1']
    ];

    return $this->success($data);
}
```

Like `perform()`, the `prepare()` method should return an `ActionResponse` using the `$this->success()` or `$this->failure()` methods.

### `availability`

By default, each Action is available. With Availability, you declare a set of checks that must be passed before an Action is deemed available.

E.g. you might want to check:
- current user has a specific privilege
- current user was the owner of a particular resource

This will be done, much like testing, by asserting the result of different operations that you declare.

Availability is `runtime`, and depends on the specific context of any given request.

```php
protected function availability(Lantern\Features\AvailabilityBuilder $builder)
{
    // Check if the user has permission to perform this action
    $builder->userCan('create', Todo::class);

    // Assert that a condition is true
    $builder->assertTrue($someCondition, 'Custom error message');

    // Check if values are equal
    $builder->assertEqual($builder->user()->id, $this->todo->user_id, 'User must own the todo');
}
```

Note that the `availability` method does not have a return type in the actual implementation, though you may add `: void` in your own code for clarity.

**Important:** When Lantern checks an Action's availability, it also checks the **constraints** of its parent Feature, but not the Feature's availability. This means that if a Feature's constraints fail, all Actions within that Feature will be unavailable.

For information on checking against availability in your code and the available methods within the  `AvailabilityBuilder` see [Availability.](availability.html)

### `constraints`

If an Action relies on a system-level dependency, then you can declare this as a Constraint.
The `constraints` method can be called from either a `Feature` or `Action`

For an illustration of in what way you may want to use this see
[Features - Constraints - An illustration](features.html#constraints)

```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints)
{
    // Check if a class exists
    $constraints->classExists('ZipArchive');

    // Check if a PHP extension is loaded
    $constraints->extensionIsLoaded('imagick');

    // Check if an executable is installed
    $constraints->executableIsInstalled('convert');
}
```

Note that the constraint methods in the actual implementation do not accept error messages as parameters, unlike what some examples might suggest. The constraint system is designed to check system-level dependencies, not to provide user-facing error messages.

Please note that constraints can also be declared on your [`Features`](/documentation/features.html)

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

### Understanding ActionProxy

The `ActionProxy` is a wrapper around your Action that provides several important functions:

1. It ensures that the Action is [available](/documentation/actions.html#availability) to be performed within the current context
2. It integrates with Laravel's Gate system for authorization
3. It handles checking constraints before allowing the action to be performed

When you call `perform()` or `prepare()` on an ActionProxy, it first checks if the action is available. If not, it throws a `LanternException`.

### Using prepare()

Use the same approach to call `prepare()` where needed:

```php
MyAction::make(...dependencies)->prepare();
```

### Checking Availability

You can explicitly check availability using the `available()` method on the `ActionProxy`:

```php
if ($action = MyAction::make()->available()) {
    // Action is available, so perform it
    $action->perform();
} else {
    // Action is not available
    // You can handle this case gracefully
}
```

The `available()` method returns the ActionProxy itself if the action is available, or `false` if it's not available.

### Working with ActionResponse

When you call `perform()` or `prepare()`, you get back an `ActionResponse` object. Here's how to work with it:

```php
$response = MyAction::make()->perform();

if ($response->successful()) {
    // Access data from the response
    $data = $response->data();

    // Or access a specific key using dot notation
    $specificValue = $response->data('some.nested.key');
} else {
    // Handle failure
    $errors = $response->errors();
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
