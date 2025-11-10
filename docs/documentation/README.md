# Introduction

## What is Lantern?

Lantern is a deeply integrated extension to your Laravel application.

Lantern offers a declarative coding convention for organising your domain model. It will allow you to more easily scan your code and understand your domain logic. It’s especially useful for large applications but will help in applications of any size.

## High-level overview

The starting point of Lantern's implementation of Feature Driven Development is the declaration of the Domain Model through `Features` & `Actions`.

A `Feature` groups multiple, related Actions together. Features are the tree and branches, Actions are the leaves. Features can be optionally nested in other Features which can be useful for large codebases.

An `Action` is a single, isolated piece of functionality provided by your system. It can contain the logic regarding its availability, any constraints for its use and what is needed to prepare for and perform that action.

System-level `Constraints` can be placed on a Feature or Action. Constraints are checked along with availability and it's a great way of switching off groups of actions or features depending on what the current system setup will support.

`Availability` determines if an Action can be performed. It's built into the heart of Lantern and provides one of the biggest benefits, colocating the logic around authorisation right there with the domain logic. For example, whether the given user has permission and/or if the state of the dependency allows for the `Action` to be performed.

The `perform` method on an Action must return an `ActionResponse`, which is considered either successful or unsuccessful.

If you need to `prepare` some data for an end-user before performing an Action, Lantern provides a place to do that.

In addition, Lantern hooks straight into Laravel’s authorisation system. For example, each action automatically registers an Authorisation Gate so you can easily check what the current user is able to do. 

Lantern projects follow these principles:

* Group the Actions of your web app into Features
* For a large codebase, you might find it useful to optionally nest your Features in other Features
* All external code used by an Action should be organised outside the Feature tree
* All the above should be organised separately from your framework code, e.g. Service Providers, Controllers

