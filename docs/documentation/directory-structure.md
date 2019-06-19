# Directory Structure

We won't force you into using a directory structure against your will, however we do recommend following certain
guidelines in order to simplify your codebase, making it easier to reason about and return to your code.

This may feel wrong to you, that's ok. This is a particular expression of how to organise a project as will not be
for everyone.

## Guidelines

Lantern projects follow these principles:

1. The ==Actions== performed by your project should be grouped by ==Feature==
2. For large codebases, ==Features== can be nested – ==Features== are the tree, ==Actions== are the leaves
3. All external code used by an ==Action== should be organised outside of the ==Feature== tree
4. All of the above should be organised separately from your framework code, e.g. Service Providers, Controllers

## Example file structure

::: vue
.
└── src/
    ├── AppFeatures.php _(**The starting point for all your features**)_
    ├── Features/
    │   ├── ManagingProjects/
    │   ├── ManagingUsers/ 🔻 _(**All the actions within the feature**)_
    │   │   ├── AddUserToProject.php
    │   │   ├── CreateCompanyUser.php
    │   │   ├── CreateProjectUser.php
    │   │   ├── ListCompanyUsers.php
    │   │   ├── ListProjectUsers.php
    │   │   ├── RemoveUserFromProject.php
    │   │   ├── ResendSetupEmail.php
    │   │   └── UpdateCompanyUser.php
    │   ├── Reporting/
    │   ├── ManagingProjectsFeature.php
    │   ├── ManagingUsersFeature.php _(**Declares the actions within this feature**)_
    │   └── ReportingFeature.php
    │ 
    └── Services/ _(**All the other services used by your actions**)_
        ├── Events
        ├── Jobs
        ├── Models
        ├── Support
        └── ValueObjects
:::
