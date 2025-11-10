# Authorisation

Lantern hooks straight in to Laravel’s authorisation system.

During the setup process, Lantern will register a [Laravel gate](https://laravel.com/docs/master/authorization#gates)
with the [id of each Action](/documentation/actions.html#id-of-an-action) that
has been [declared during set-up](/documentation/installation.html#set-up).

So, for example, let's say you have an `Action` called `UpdateProject`.
This will have an `id` of `update-project` which you can use with Laravel's built-in authorisation options.


:::warning Dependencies
Any dependencies declared in the `__construct()` method of your Actions must be passed through as
additional parameters whenever authorising using Laravel's built-in methods described below.
:::

::: tip Laravel Debugbar
If you have [Laravel Debugbar](https://github.com/barryvdh/laravel-debugbar) enabled,
you will see a tab called Authorisation that will output all of the different gates that are automatically made available by Lantern.
:::

## With middleware

Your Actions can be authorised using [Laravel's middleware authorisation](https://laravel.com/docs/master/authorization#via-middleware).

Any dependencies that are needed for your Action, will need to come through
[Laravel's Route Model Binding](https://laravel.com/docs/master/routing#route-model-binding).

<code-group>

<code-block title="Implicit model binding">
```php
// in your route file

Route::get('/{todolist}', function (\App\Models\TodoList $todolist) {
    return $todolist;
})->middleware('can:show-todo-list,todolist')->name('show-todo-list');
```

</code-block>

<code-block title="Explicit model binding">
```php
// in your RouteServiceProvider class
public function boot() {
    Route::model('todolist', \App\Models\TodoList::class);
}

// in your route file
Route::get('/{todolist}')
    ->middleware('can:show-todo-list,todolist')
    ->name('show-todo-list');
```
</code-block>

</code-group>

## With Blade

Your Actions can be authorised using [Laravel's Blade directives](https://laravel.com/docs/master/authorization#via-blade-templates).

```html
<ul>
@foreach($checklists as $list)
    @can('show-todo-list', $list)
        <li>
            <a href="{{ route('show-todo-list', ['todolist' => $list]) }}">
                {{ $list->name }}</a>
        </li>
    @endcan
@endforeach
</ul>
```


If you have multiple dependencies for your `Action`, the 2nd argument of `can()` should be an `array` if you need to pass in multiple dependencies, e.g.:

```perl
@can('show-company-todo-list', [$company, $list])
```

## Feature stacks

If you have provided a `Feature` stack name for your `Feature` graph, then that STACK name must be prefixed to the `Action` id
when checking for authorisation.

For example:

<code-group>

<code-block title="Features ">
```php

class ProjectFeatures extends Lantern\Features\Feature
{
    const STACK = 'projects';

    const ACTIONS = [
        UpdateProject::class,
    ];
}

```

</code-block>

<code-block title=" Action ">
```php
class UpdateProject extends Lantern\Features\Action
{
    public function __construct (Project $project) {
        // …
    }
}
```

</code-block>

<code-block title="Blade template">
```html
<h2>Projects</h2>

<ul>
@foreach($projects as $project)
    <li>
        {{ $project->name }}
        @can('projects.update-project', [$project])
        <a href="route('update-project', [$project])">Update</a>
        @endcan
    </li>
@endforeach
</ul>
```

</code-block>

</code-group>

## Further reading

Since Action Availability is handled through gates, you can use any of Laravel's
methods for authorising actions:

- [Gate Facade](https://laravel.com/docs/master/authorization#authorizing-actions-via-gates)
- [User model](https://laravel.com/docs/master/authorization#via-the-user-model)
- [Controller Helpers](https://laravel.com/docs/master/authorization#via-controller-helpers)
