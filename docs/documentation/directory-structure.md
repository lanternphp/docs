# Directory Structure

We won't **force** you into using a directory structure against your will, however we do recommend following certain
guidelines in order to simplify your codebase, making it easier to reason about and return to your code.

This may feel wrong to you, that's ok. This is a particular expression of how to organise a project and will
not be for everyone.

## Example file structure

```
.
├── app/
│   ├── Features/
│   │   ├── AppFeatures.php (The starting point for all your features)
│   │   ├── ManagingUsers/
│   │   ├── TodoList/ 🔻 (All the actions within the feature)
│   │   │   ├── ListTodos.php
│   │   │   ├── AddTodo.php
│   │   │   ├── EditTodo.php
│   │   │   ├── MarkTodoComplete.php
│   │   │   ├── MarkTodoIncomplete.php
│   │   │   ├── ClearCompletedTodos.php
│   │   │   └── RemoveTodo.php
│   │   ├── ManagingUsersFeature.php
│   │   └── TodoListFeature.php (Declares the actions within this feature)
│   │
│   ├── Services/ (All the other services used by your actions)
│   │   ├── Events/
│   │   ├── Jobs/
│   │   ├── Models/
│   │   ├── Support/
│   │   └── ValueObjects/
```

## Namespacing your project

Use the standard Laravel `App\` namespace for your features.

In your `composer.json` file, the default Laravel autoloading configuration already includes:

```json
{
    "autoload": {
        "psr-4": {
            "App\\": "app/",
            "Database\\Factories\\": "database/factories/",
            "Database\\Seeders\\": "database/seeders/"
        }
    }
}
```

And then dump the autoloader again:

```bash
composer dumpautoload -o
```