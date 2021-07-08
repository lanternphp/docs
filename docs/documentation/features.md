# Features

A Feature must contain other Features and/or Actions and should extend `Lantern\Features\Feature`

``` php 
<?php

use Lantern\Features\Feature;

class ExampleFeature extends Feature
{
    // optionally override the ID automatically assigned
    const ID = null;

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

## `constraints`

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
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints) {
     //…
}
```

::: warning More info
Please note that constraints can also be called from your [`Actions`](/actions.html)

For info on the available methods of the `ConstraintsBuilder` see [Constraints](constraints.html).
:::
