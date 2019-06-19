# @todo Installation

::: tip
After installing
:::

## Install with composer

Install from the command line:

``` bash
composer require "lanternphp/lantern"
```

**or by adding the following to your ==composer.json== file:**

```json
{
    "require": {
        "lanternphp/lantern": "~1.0"
    }
}
```

## Configure the Service Provider

::: warning COMPATIBILITY NOTE
This is only required if your app uses Laravel <= 5.3 (@todo which one).

Beyond this, the Service Provider is loaded automatically. ==@todo verify this==
:::

Add the following to you ==config/app.php== file:

```php
'providers' => [
    // …
    Lantern\Support\LanternServiceProvider::class,
],
```