# Getting started

## Overview

Lantern offers you, a Laravel developer, a framework for organising your domain model.

By writing your domain model using a declarative coding convention, you will:

1. Be able to scan you code and see where your domain logic resides.
1. Have more secure code.
1. Get functionality for free, with deep integration into Laravel.

You'll love returning to an app you haven't looked at for 3 months and seeing exactly what it does.

## System requirements

- Laravel >= 5.5
- PHP >= 7.0.0

## Installation

### Install with composer

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

And running:

```bash
php composer update lanternphp/lantern
```


#### Manual `Service Provider` registration

::: warning OPTIONAL
If you're running a recent version of Laravel, this is **not required**.
If you're sprinkling a little Lantern on a legacy codebase, you may need to manually register
Lantern's Service Provider.

Beyond this, the Service Provider is [loaded automatically](https://laravel.com/docs/5.5/packages#package-discovery).
:::

You will need to manually register Lantern's `Service Provider` if:

1. You're using ==Laravel 5.4== or earlier
1. Or, you have decided to [opt-out of package discovery](https://laravel.com/docs/5.5/packages#package-discovery) 😭

If either of these is the case for you, then you'll need to
add the following to you ==config/app.php== file:

```php
'providers' => [
    // …
    Lantern\ServiceProvider::class,
],
```
