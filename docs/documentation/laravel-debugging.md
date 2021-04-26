# Debugging / Exceptions

- [ ] Yet to be implemented

## The plan

- Record the recent history of ==Actions== performed by a user
- Integrate Lantern with Laravel's exception handling
- Ensure any Exceptions reported include a user's history to aid debugging
- Remove any sensitive data that may be included with the history 

### Laravel Debugbar

If you use Laravel Debugbar and run into issue with memory exhaustion, we recommend
you **disable** the `Gate` logging in Laravel Debugbar.
