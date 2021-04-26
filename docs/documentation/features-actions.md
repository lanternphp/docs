# Features & Actions

## Overview

The starting point of Lantern's implementation of FDD is the expression & declaration of the Domain Model through Features & Actions.

A Feature groups Action together, as well as other smaller Features.

Lantern projects follow these principles:

1. Group the Actions of your web app into Features
2. For large a codebase, Features can be nested – Features are the tree and branches, Actions are the leaves
3. All external code used by an Action should be organised outside of the Feature tree
4. All the above should be organised separately from your framework code, e.g. Service Providers, Controllers

Take a look at [how we recommend organising your domain logic](/documentation/directory-structure.html).

## Declare your Features

A Feature must contain other Features and/or Actions.
  
The starting point is the top-level Feature of your app, let's call this `AppFeatures` (in `src/AppFeatures.php`), 
which declares all the features within your app.

```php
<?php 

namespace  MyTodos;

use Lantern\Features\Feature;
use MyTodos\Features\TodoListFeature;

class AppFeatures extends Feature
{
    const DESCRIPTION = ' Todo Features';

    const FEATURES = [
        TodoListFeature::class,
    ];
}
```

This top-level Feature group will need to be declared to Lantern, typically from `AppServiceProvider`:

```php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Lantern\Lantern;
use MyTodos\AppFeatures;

class AppServiceProvider extends ServiceProvider
{
    public function boot()
    {
        $this->setupLantern();
    }
    
    protected function setupLantern()
    {
        Lantern::setup(AppFeatures::class);
    }
}
```

Now, we declare the `TodoListFeature` class:

```php
<?php

namespace MyTodos\Features;

use Lantern\Features\Feature;

class TodoListFeature extends Feature
{
    const DESCRIPTION = 'Feature for maintaining a to-do list';

    const ACTIONS = [
        TodoList\ListTodos::class,
        TodoList\AddTodo::class,
        TodoList\EditTodo::class,
        TodoList\MarkTodoComplete::class,
        TodoList\MarkTodoIncomplete::class,
        TodoList\ClearCompletedTodos::class,
        TodoList\RemoveTodo::class,
    ];
}
``` 

## Writing an Action

An Action is a class that extends `Lantern\Features\Action` and declares a `perform()` method.

<code-group>
<code-block title="PHP 5">
```php
/**
 * @return \Lantern\Features\ActionResponse
 */
public function perform() {
   //…
}
```
</code-block>

<code-block title="PHP 7 +">
```php
public function perform(): \Lantern\Features\ActionResponse {
   //…
}
```
</code-block>
</code-group>

:::tip Passing data to your Action
When performing an Action, you will want to pass data into it, to be worked upon.

1. Dependencies – typically other classes, like `TodoList` (if you had multiple lists)
2. Input – data that typically comes from user input, e.g. the text of a todo item

Dependencies should be declared in the `__construct()` method of your Action.

Input should be part of your `perform()` method, e.g.:

```php
public function perform($todoText, $completed = false) {
    //…
}
```
:::

Beyond the `perform()` method, there are other changes you could make to your Action classes:

- `const ID = null;` – Overwrite this with your own custom ID if the default is not what you want
- `public function prepare()` – declare this method if you wish to be able to prepare data, perhaps for default form values in a view, prior to an Action being performed

### Returning a response

The `perform()` method of your Action must return an ActionResponse, which is considered either `successful` or `unsuccessful`.

Any controller or artisan command can respond appropriately based on what is returned.

<code-group>
<code-block title="Action class">
```php
<?php

namespace MyTodos\Features\TodoList;

use Lantern\Features\Action;
use Lantern\Features\ActionResponse;

class AddTodo extends Action
{
    protected TodoList $list;
    
    public function __construct(TodoList $list) {
        $this->list = $list;
    }
    
    public function perform($text): ActionResponse
    {
        if ($this->list->archived) {
            return $this->failure([403 => 'todo list is archived']);
        }

        // save new item in db
        $item = new TodoItem([
            'text' => $text,
            'completed' => false
        ]);
        
        $item->save();

        return $this->success(compact('item'));
    }
}
```
</code-block>

<code-block title="Calling from a controller">
```php
$response = AddTodo::make($todoList)->perform($textFromForm);

if ($response->unsuccessful()) {
    // handle failure
}

// handle success
```
</code-block>
</code-group>


### ID of an Action

Each action has an `id`, which must be **unique across the entire application**.

The `id` is used as a simple reference from across your Laravel application, e.g. when [authorising an Action](/documentation/authorisation.html).

By default, the `id` is a `dash-cased` representation of the class name without the namespace, so `ClearCompletedTodos` 
becomes `clear-completed-todos`.

:::tip Customise your id

The auto-generated `id` will probably be good enough for you. As long as you keep in mind that your class name must be
unique across your application, then it'll probably be just fine.

To override this default, simply declare a `const ID = ""` in your Action class.
:::

### Preparing data for an Action

Often, you will want to show some data to an end-user before performing an Action. Typically, when displaying data being
acted, e.g. in a form or for confirmation.

You don't necessarily want to have an Action just for this scenario (although you may), so you can define a 
`public function prepare()` method on your Action to handle this.

```php
public function prepare(): array {
    //…
}
```

## Calling an Action

You call an `Action` like this:

```php
MyAction::make(...dependencies)->perform(...methodParameters);
```

`make()` will instantiate your action using the arguments passed in, but return an instance of `\Lantern\Features\ActionProxy`.

The ActionProxy ensures that the Action is [available](/documentation/constraints-availability.html) to be performed within the current context. 

Use the same approach to call `prepare()` where needed:

```php
MyAction::make(...dependencies)->prepare();
```
