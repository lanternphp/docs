# Examples

### Building a to-do list

If we were building to-do list functionality we would group all the features together in a `TodoListFeature`

``` php 
<?php

namespace MyTodos\Features;

use Lantern\Features\Feature;

class TodoListFeature extends Feature
{
    const DESCRIPTION = 'Feature for maintaining the to-do list';

    const ACTIONS = [
        TodoList\ListTodos::class,
        TodoList\AddTodo::class,
        TodoList\UpdateTodo::class,
        TodoList\MarkTodoComplete::class,
        TodoList\MarkTodoIncomplete::class,
        TodoList\ClearCompletedTodos::class,
        TodoList\RemoveTodo::class,
    ];
}
```

We would then declare the `TodoListFeature` in our main `AppFeatures` Feature like so

``` php 

<?php 

use MyTodos\Features\TodoListFeature
use Lantern\Features\Feature;

class TodoListFeature extends Feature
{
    const DESCRIPTION = 'Top-level feature';

    const FEATURES = [
        TodoListFeature::class,
        //… (other features of the system as required)
    ];
}

```

When we come to build the functionality to update a to-do item we might want to:

* check if the user has the correct permissions to view the form and make the change
* get the current text for the to-do item for the form

``` php 
<?php

namespace MyTodos\Features\TodoList;

use Lantern\Features\Action;
use Lantern\Features\ActionResponse;

class UpdateTodo extends Action
{
    protected Todo $todo;
    protected TodoList $list

    public function __construct(Todo $todo) {
        $this->todo = $todo;
        $this->list = $todo->list();
    }
    
    public function prepare(): ActionResponse
    {
        return $this->success([
            'listTitle' => $this->list->title,
            'todoText'  => $this->todo->text
        ]);
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
