# Installation

## System requirements

- Laravel >= 8
- PHP >= 7.3

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

This top-level Feature group will need to be declared to Lantern from `AppServiceProvider` within the `boot` method.

Lantern is configured by calling static methods on the `Lantern\Lantern` class. We use the `setUp()` method to declare the 
base feature group.

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
        Lantern::setUp(AppFeatures::class);
    }
}
```

## Directory path

By default, when Lantern searches for a binary on the command line, it will take either:

1. Your [`open_basedir`](https://www.php.net/manual/en/ini.core.php#ini.open-basedir) path if set, otherwise
2. The paths present in your `$PATH` environment variable

… and combine these paths with:

``` php 
[
    base_path(), // the folder into which Laravel is installed
    base_path('vendor/bin'), // where composer's binaries are stored 
]
```

See the [Laravel documentation](https://laravel.com/docs/master/helpers#method-base-path) for more information on the `base_path()` method.

If your system requires a executable outside these directories, then you will need to provide this location to Lantern 
in order to use that binary as a `constraint`. You can do this via the `pathDirs` method, which you should call 
before the `setup` method in `AppServiceProvider`.

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
        
        Lantern::setUp(App\Features::class);
    }
}

```

::: warning Open Base Directory
NB: if you have configured [`open_basedir`](https://www.php.net/manual/en/ini.core.php#ini.open-basedir), then you cannot search directories outside of this path.
:::
