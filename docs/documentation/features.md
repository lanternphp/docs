# Features

A Feature must contain other Features and/or Actions and should extend `Lantern\Features\Feature`

``` php
<?php

use Lantern\Features\Feature;

class ExampleFeature extends Feature
{
    // optionally override the ID automatically assigned
    const ID = null;

    // push your top-level feature onto a different stack
    const STACK = null;

    // An optional description of this feature
    const DESCRIPTION = '';

    const ACTIONS = [
        // declare this features actions here
    ];

    const FEATURES = [
        // declare any features attached to this feature here
    ];
}
```

**Example: Defining a Todos Feature**

Let's create a Feature to group all Actions related to managing Todo items.

```php
<?php

namespace App\Features\Todos; // Feature class namespace

use App\Features\Todos\CreateTodoAction; // Action class
use App\Features\Todos\UpdateTodoAction; // Action class
use App\Features\Todos\DeleteTodoAction; // Action class
use Lantern\Features\Feature;
use Lantern\Features\AvailabilityBuilder; // For feature-level availability
use Lantern\Features\ConstraintsBuilder; // For feature-level constraints
use Illuminate\Support\Facades\Config;

class TodosFeature extends Feature
{
    // Optional: A description for documentation or UI purposes
    const DESCRIPTION = 'Manages all Todo list functionality.';

    // List all Actions belonging directly to this Feature
    const ACTIONS = [
        CreateTodoAction::class,
        UpdateTodoAction::class,
        DeleteTodoAction::class,
        // ... other todo-related actions
    ];

    // Optional: List any nested Sub-Features
    const FEATURES = [
        // NestedFeature::class,
    ];

    // Note: Features do not support availability checks.
    // Only constraints are checked when determining if an Action is available.
    // If you need common availability logic, consider creating a base Action class
    // that your Actions can extend.

    // Define constraints for the entire Feature
    // These constraints are checked when determining if Actions within this Feature are available
    protected function constraints(ConstraintsBuilder $constraints)
    {
        // Example: Check if the convert binary is present
        // Note: The actual implementation doesn't accept error messages
        $constraints->extensionIsLoaded('convert');

        // Other examples:
        // $constraints->classExists('ZipArchive');
        // $constraints->executableIsInstalled('pdftk');
    }
}
```

Your Feature would then be declared in a parent Feature or in the base `AppFeatures` Feature (see [Setup](installation.html#set-up))

``` php

<?php

use Lantern\Features\Feature;

class AppFeatures extends Feature
{
    const DESCRIPTION = 'Top-level feature';

    const FEATURES = [
        ExampleFeature::class,
    ];
}

```

## Constraints

If a Feature relies on a system-level dependency, then you can declare this as a `constraint`.

If any declared constraints of a Feature fail to be met then all of its declared Actions will
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

It's a totally different way of handling the same problem, which leaves you looking more professional.

### Declaring Constraints

If your Feature has Constraints to declare, then you must add the following to your class:

```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints)
{
     //…
}
```

::: warning More info
Please note that constraints can also be declared in your [`Actions`](actions.html#constraints)

For info on the available methods of the `ConstraintsBuilder` see [Constraints](constraints.html).
:::

## Multiple Feature stacks

It's possible to work with multiple `Feature` stacks, thus giving you a way of splitting your `Actions` into groups.

To do this, simply specify a `const STACK = 'my-stack';` onto your top-most Feature.

This has two effects on your application:

1. You can now have multiple `Actions` with the same `ID`, as long as they're in different stacks
2. When checking authorisation, you must prefix the `Action` `ID` with the stack,<br>e.g. `@can('my-stack.add-todo') … @endcan'`

::: danger Do not declare a STACK on a sub-feature
If you specify an additional stack on a nested sub-feature, a `Lantern\LanternException` will be thrown.
:::
