# Constraints

For more information on Constraints see [Features - Constraints](/documentation/features.html#constraints) and [Actions - Constraints](/documentation/actions.html#constraints)

If your Feature or Action has Constraints to declare, then you must add the following to your class:

```php
protected function constraints(\Lantern\Features\ConstraintsBuilder $constraints)
{
    // Add your constraint checks here
}
```

**Example: Defining Constraints**

Let's say you have an Action that generates PDF reports using a specific library and potentially an external tool like `pdftk`.

```php
<?php

namespace App\Features\Reports\Actions;

use App\Services\PdfGeneratorService; // Assumed dependency
use Lantern\Features\Action;
use Lantern\Features\ActionResponse;
use Lantern\Features\ConstraintsBuilder;

class GeneratePdfReportAction extends Action
{
    // Action methods like __construct, perform, etc.
    // ...

    protected function constraints(ConstraintsBuilder $constraints): void
    {
        // 1. Ensure the PDF generation service class exists
        $constraints->classExists(
            PdfGeneratorService::class,
            'The required PdfGeneratorService class is missing.'
        );

        // 2. Ensure the 'imagick' PHP extension is loaded (if needed for PDF generation)
        $constraints->extensionIsLoaded(
            'imagick',
            'The Imagick PHP extension is required for report generation.'
        );

        // 3. Ensure the 'pdftk' executable is installed (if needed for advanced PDF manipulation)
        $constraints->executableIsInstalled(
            'pdftk',
            'The pdftk executable needs to be installed on the server.'
        );
    }

    public function perform(): ActionResponse
    {
        // This code only runs if all constraints pass
        // ... logic to generate the PDF report ...
        return ActionResponse::successful('Report generated.');
    }
}
```

**Explanation:**

1.  `classExists(PdfGeneratorService::class, ...)`: Checks if the `App\Services\PdfGeneratorService` class can be found and autoloaded. If not, the action/feature will be considered unavailable, and the provided message can help diagnose the issue.
2.  `extensionIsLoaded('imagick', ...)`: Verifies that the `imagick` PHP extension is installed and enabled in the current PHP environment.
3.  `executableIsInstalled('pdftk', ...)`: Checks if the `pdftk` command-line tool is present in the system paths configured for Lantern (see [Installation](/documentation/installation.html#directory-path)).

If any of these constraints fail, the `GeneratePdfReportAction` will not be considered available, and attempting to call `perform()` on it (via the proxy) will result in an exception *before* the `perform` method's code is even executed.

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

These paths can be [configured in your AppServiceProvider](/documentation/installation.html#directory-path).
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