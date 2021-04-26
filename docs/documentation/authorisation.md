# Authorisation

Lantern hooks straight in to Laravel’s authorisation system.

During the setup process, Lantern will register a [Laravel gate](https://laravel.com/docs/master/authorization#gates) 
with the [id of each Action](/documentation/features-actions.html#id-of-an-action) that 
has been [declared during setup](/documentation/configuration.html#setup).

::: tip Laravel Debugbar
If you have [Laravel Debugbar](https://github.com/barryvdh/laravel-debugbar) enabled, 
you will see a tab called Authorisation that will output all of the different gates that are automatically made available by Lantern.
:::

So, for example, let's say you have an `Action` called `UpdateProject`.
This will have an `id` of `update-project` which you can use with Laravel's built-in authorisation options.

:::warning Dependencies
Any dependencies declared in the `__construct()` method of your Actions must be passed through as
additional parameters whenever authorising using Laravel's built-in methods described below.
:::

## With middleware

Your Actions can be authorised using [Laravel's middleware authorisation](https://laravel.com/docs/master/authorization#via-middleware).

Any dependencies that are needed for your Action, will need to come through 
[Laravel's Route Model Binding](https://laravel.com/docs/master/routing#route-model-binding).

<code-group>

<code-block title="Implicit model binding">
```php
// in your route file

Route::get('/{todolist}', function (\MyTodos\Services\Models\TodoList $todolist) {
    return $todolist;
})->middleware('can:show-todo-list,todolist')->name('show-todo-list');
```

</code-block>

<code-block title="Explicit model binding">
```php
// in your RouteServiceProvider class
public function boot() {
    Route::model('todolist', \MyTodos\Services\Models\TodoList::class);
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

:::tip Multiple dependencies

The 2nd argument of `can()` should be an `array` if you need to pass in multiple dependencies, e.g.:

```perl
@can('show-company-todo-list', [$company, $list])
```

:::

## Further reading

Since Action Availability is handled through gates, you can use any of Laravel's
methods for authorising actions:

- [Gate Facade](https://laravel.com/docs/master/authorization#authorizing-actions-via-gates)
- [User model](https://laravel.com/docs/master/authorization#via-the-user-model)
- [Controller Helpers](https://laravel.com/docs/master/authorization#via-controller-helpers)
