# Installation

## System requirements

- Laravel >= 5.5
- PHP >= 7.0.0

## Install with composer

Either install from the command line:

``` bash
composer require "lanternphp/lantern"
```

**Or** by add the following to your ==composer.json== file:

```json
{
    "require": {
        "lanternphp/lantern": "~1.0"
    }
}
```

And run:

```bash
composer update lanternphp/lantern
```


### Manual `Service Provider` registration

::: warning OPTIONAL
If you're running a recent version of Laravel, this is **not required**.
If you're sprinkling a little Lantern on a legacy codebase, you may need to manually register
Lantern's Service Provider.

Beyond this, the Service Provider is [loaded automatically](https://laravel.com/docs/5.5/packages#package-discovery).
:::

If you have decided to [opt-out of package discovery](https://laravel.com/docs/5.5/packages#package-discovery) , you will need to manually register Lantern's `Service Provider` 
via your ==config/app.php== file:

```php
'providers' => [
    // …
    Lantern\ServiceProvider::class,
],
```


## Set up

The starting point is the base feature group that will declare all other features and actions.

It can be named anything you want, but we'll call this `AppFeatures` (in ==src/AppFeatures.php==).

``` php
<?php 

use Lantern\Features\Feature;

class AppFeatures extends Feature
{
    const DESCRIPTION = 'Top-level feature';

    const FEATURES = [
        /* features will go in here */
    ];
}
```

This top-level Feature group will need to be declared to Lantern, typically from `AppServiceProvider` within the `boot` method

Lantern is configured by calling static methods on the `Lantern\Lantern` class. We use the `setup` method to declare the base feature group.

``` php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Lantern\Lantern;

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

## Directory path

By default, when Lantern searches for a binary on the command line, it will use:

``` php 
[
    base_path(), // the folder into which Laravel is installed
    base_path('vendor/bin'), // where composer's binaries are stored 
]
```

See the [Laravel documentation](https://laravel.com/docs/master/helpers#method-base-path) for more information on the `base_path()` method.

If your system requires a binary outside of these directories, then you will need to provide this location to Lantern in order to use that binary as a `constraint`. You can do this via the `pathDirs` method, which you should call before the `setup` method in `AppServiceProvider`

``` php 

<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Lantern\Lantern;

class AppServiceProvider extends ServiceProvider
{
    public function boot()
    {
        $this->setupLantern();
    }
    
    protected function setupLantern()
    {
        Lantern::pathDirs([
            '/usr/local/bin/',
            '/var/www/bin',
        ]);
        
        Lantern::setup(App\Features::class);
    }
}

```

::: warning Open Base Directory
NB: if you have configured [`open_basedir`](https://www.php.net/manual/en/ini.core.php#ini.open-basedir), then you cannot search directories outside of this path.
:::
