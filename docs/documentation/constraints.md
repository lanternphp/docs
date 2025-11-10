# Constraints

Constraints are system-level dependencies that must be met for a Feature or Action to be available. When Lantern checks an Action's availability, it also checks the constraints of its parent Feature.

**Important:** Feature constraints are the only aspect of a Feature that affects the availability of its Actions. If a Feature's constraints fail, all Actions within that Feature will be unavailable.

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

namespace App\Features\Reports;

use App\Services\PdfGeneratorService; // Assumed dependency
use Lantern\Features\Action;
use Lantern\Features\ActionResponse;
use Lantern\Features\ConstraintsBuilder;

class GeneratePdfReportAction extends Action
{
    // Action methods like __construct, perform, etc.
    // ...

    protected function constraints(ConstraintsBuilder $constraints)
    {
        // 1. Ensure the PDF generation service class exists
        // Note: The actual implementation doesn't accept error messages
        $constraints->classExists(PdfGeneratorService::class);

        // 2. Ensure the 'imagick' PHP extension is loaded (if needed for PDF generation)
        $constraints->extensionIsLoaded('imagick');

        // 3. Ensure the 'pdftk' executable is installed (if needed for advanced PDF manipulation)
        $constraints->executableIsInstalled('pdftk');
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

1.  `classExists(PdfGeneratorService::class)`: Checks if the `App\Services\PdfGeneratorService` class can be found and autoloaded. If not, the action/feature will be considered unavailable.
2.  `extensionIsLoaded('imagick')`: Verifies that the `imagick` PHP extension is installed and enabled in the current PHP environment.
3.  `executableIsInstalled('pdftk')`: Checks if the `pdftk` command-line tool is present in the system paths configured for Lantern (see [Installation](/documentation/installation.html#directory-path)).

**Important Note:** The actual implementation of these constraint methods in the `ConstraintsBuilder` class does not accept error messages as parameters. The methods only accept the name of the class, extension, or executable to check. Error messages shown in some examples are not supported by the core implementation.

If any of these constraints fail, the `GeneratePdfReportAction` will not be considered available, and attempting to call `perform()` on it (via the proxy) will result in an exception *before* the `perform` method's code is even executed.

Similarly, if these constraints were defined on a Feature, all Actions within that Feature would be unavailable if any constraint fails.

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
// Actual implementation in ConstraintsBuilder.php
public function classExists($fullyQualifiedClassName): self
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
// Actual implementation in ConstraintsBuilder.php
public function executableIsInstalled($executableName): self
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
// Actual implementation in ConstraintsBuilder.php
public function extensionIsLoaded($extensionName): self
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