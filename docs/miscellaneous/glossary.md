---
sidebarDepth: 0
sidebar: auto
---

# Glossary

It's beneficial to become familiar with key concepts that you will encounter in the [documentation](/documentation/).

This section lists these common terms for easy access & learning.

In an attempt to add a little clarity, we will use the example of a web-based email client (like Gmail).

## Action

An ==action== is a single, isolated piece of functionality provided by your system.

### Actions by example

- `ShowInbox`
- `SendEmail`
- `SaveDraft`
- `ApplyLabelToConversation`

[Learn more about actions](/documentation/).

## Feature

A ==feature== groups multiple, related ==actions== together.

### Features by example

- `ComposingEmails` – which might have ==actions== like:
    - `WriteNewMessage`
    - `AttachFileToNewMessage`
    - `SendMessage`
    - `SendMessageLater`
    - `DeleteNewMessage`
- `ManageConversations` – which might have ==actions== like:
    - `ListConversations`
    - `MarkConversationsAsRead`
    - `ArchiveConversations`
    - `ReportConversationAsSpam`
    - `DeleteConversation`

[Learn more about features](/documentation/).

## Availability

==Availability== determines if an ==action== can be performed. It's built into the heart of Lantern and provides one of the biggest benefits.

You can configure when an action is available, and when it is not.

By default, an ==action== is available unless you configure it otherwise.

[Learn more about availability](/documentation/).

## Constraint

System-level ==constraints== can be placed on a ==feature== or ==action==.

==Constraints== are checked along with availability and it's a great way of switching off groups of ==actions==
or ==features== depending on what the current system setup will support.

[Learn more about constraints](/documentation/).

### Availability and constraints by example

Let's say your Gmail-like software has an ==action== allowing the user to `DownloadAllAttachments`.

You might configure your `DownloadAllAttachments` ==action== like this:

- ==availability== – only allow if the current message has 2 or more attachments (this is not a system constraint, since it changes based on the current message)
- ==constraint== – only allow if the `zip` binary is present on the current system
