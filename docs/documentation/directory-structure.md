# Directory Structure

We won't **force** you into using a directory structure against your will, however we do recommend following certain
guidelines in order to simplify your codebase, making it easier to reason about and return to your code.

This may feel wrong to you, that's ok. This is a particular expression of how to organise a project and will 
not be for everyone.

## Example file structure

::: vue
.
├── src/
│   ├── AppFeatures.php _(**The starting point for all your features**)_
│   │ 
│   ├── Features/
│   │   ├── ManagingUsers/
│   │   ├── TodoList/ 🔻 _(**All the actions within the feature**)_
│   │   │   ├── ListTodos.php
│   │   │   ├── AddTodo.php
│   │   │   ├── EditTodo.php
│   │   │   ├── MarkTodoComplete.php
│   │   │   ├── MarkTodoIncomplete.php
│   │   │   ├── ClearCompletedTodos.php
│   │   │   └── RemoveTodo.php
│   │   ├── ManagingUsersFeature.php
│   │   └── TodoListFeature.php _(**Declares the actions within this feature**)_
│   │ 
│   ├── Services/ _(**All the other services used by your actions**)_
│   │   ├── Events/
│   │   ├── Jobs/
│   │   ├── Models/
│   │   ├── Support/
│   │   └── ValueObjects/
:::

## Namespacing your project

Add a namespace to your `src/` directory, named after your application.

In your `composer.json` file:

```json
{    
    "autoload": {
        "psr-4": {
            "App\\": "app/",
            "Database\\Factories\\": "database/factories/",
            "Database\\Seeders\\": "database/seeders/",
            
            "MyTodos\\": "src/"
        }
    }
}
```

And then dump the autoloader again:

```bash
composer dumpautoload -o
```