# Constraints

For more information on Constraints see [Features - Constraints](/documentation/features.html#constraints) and [Actions - Constraints](/documentation/actions.html#constraints)

If your Feature or Action has Constraints to declare, then you must add the following to your class:

```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints)
{
    //
}
```

## Available constraints

### `classExists()`

Ensure a specific class exists. 

_NB: This constraint will try to find the class with autoloading._

<code-group>

<code-block title="Usage">
```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints)
{
    $constraints->classExists('ZipArchive');
}
```
</code-block>

<code-block title="Method signature">
```php
public function classExists(string $fullyQualifiedClassName): ConstraintsBuilder
```

</code-block>



</code-group>


### `executableIsInstalled()`

Ensure a specific binary is present on your system.

<code-group>

<code-block title="Usage">
```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints)
{
    $constraints->executableIsInstalled('convert');
}
```
</code-block>

<code-block title="Method signature">
```php
public function executableIsInstalled(string $executableName): ConstraintsBuilder
```

</code-block>



</code-group>

:::tip Paths
When Lantern searches for an executable, it must search certain paths on the server.

These paths can be [configured in your AppServiceProvider](/documentation/configuration.html#pathdirs).
:::


### `extensionIsLoaded()`

Ensure a particular PHP extension is loaded.

<code-group>

<code-block title="Usage">
```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints)
{
    $constraints->extensionIsLoaded('zip');
}
```
</code-block>

<code-block title="Method signature">
```php
public function extensionIsLoaded(string $extensionName): ConstraintsBuilder
```

</code-block>

</code-group>

:::tip What extensions do you have?

To check the extensions loaded in your environment:
```bash
php -m
``` 
:::

## Constraint caching

When a `Constraint` is checked, the result of that check is cached. This is to avoid needlessly running the same check
over and over again.

The whole point of a `Constraint` check is to ensure the `Action` is available within the current environment, and that
environment is not expected to change within the same request.