# Configuration

Lantern is configured by calling static methods on the `Lantern\Lantern` class.

## `pathDirs`

Use this method to set or get the current directories to be search by Lantern.

```php
/**
 * @param string[] an array of directories to search in addition to the defaults
 * @return array of paths that have been configured 
 */
Lantern::pathDirs(array $dirs = null): array
```

By default, when Lantern searches for a binary on the command line, it will use:

```php
/**
 * @see https://laravel.com/docs/master/helpers#method-base-path
 */
[
    base_path(), // the folder into which Laravel is installed
    base_path('vendor/bin'), // where composer's binaries are stored 
]
```

If your system requires a binary outside of these directories, then you will need to provide this 
location to Lantern in order to use that binary as a [==constraint==](/documentation/constraints-availability), 
i.e. a very good practice.

```php
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
    }
}
```

::: warning Open Base Directory
NB: if you have configured [`open_basedir`](https://www.php.net/manual/en/ini.core.php#ini.open-basedir), then you cannot search directories outside of this path. 
:::

Lantern is configured by calling static methods on the `Lantern\Lantern` class.



## `setup`

Setup Lantern with the base feature group that will declare all other features and actions.

```php
/**
 * @param string the fully-qualified class name of your app's base Feature class 
 * @return void
 */
Lantern::setup(string $appFeatures)
```

Tell Lantern where you've defined all of your ==Features== and ==Actions==:

```php
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

