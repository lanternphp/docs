---
sidebar: auto
---

# FAQ

## Do I have to use Lantern for all of my domain code 

Nope.

We're confident you'll love the additional structure and clarity Lantern will give your application, and there's no
better way of testing this out than adding in 1 or 2 of your actions and seeing how it feels.

Lantern won't interfere with the rest of your app in the slightest, so you're free to continue hitting those eloquent models and repositories from
the rest of your controllers, it just won't feel as nice.

## Can't I just organise my Controllers using the Lantern way?

Sure, but Lantern is more than just code organisation. It uses the way ==Actions== are explicitly declared to
integrate more deeply into Laravel. For example, each action automatically registers an [Authorisation Gate](https://laravel.com/docs/master/authorization#gates)
so you can easily check what the current user is able to do. You can't do that with a controller.

Beyond this, it's also likely you'll have your own Artisan commands, or you organise your controllers using [resource controllers](https://laravel.com/docs/master/controllers#resource-controllers)
which do not reflect the entirety of your domain model.

## Can package developers use Lantern?

Yes, however please put your `Features` into a graph using your package name as the `STACK` to avoid collisions.

For more information, read [the section on Multiple Feature graphs](/documentation/features.html#multiple-feature-graphs).  

## What's on the horizon for Lantern?

We're always looking at ways of improving Lantern, and more deeply integrating with Laravel, so you get more 
out-of-the-box functionality for free.

If you have any ideas on how to improve Lantern, [let us know](https://github.com/lanternphp/lantern/issues/new).  