- [Requirements](#requirements)
- [Specification](#specification)
- [Past problems](#past-problems)

## Requirements

- Offline users should have a bookmark with badge when they login
- All user's devices must be kept in synch
- Don't display too many bookmarks

## Specification

### _Unread_ Section

An unread item, when clicked, hides itself and opens up the channel.

### User-defined sections

When Sections are collapsed, only bookmarks that have unread messages show up.

Closing a bookmark causes it to be removed from the section.

Users can drag'n drop bookmarks in these sections.

Bookmarks can be repeated in different sections as users wish.

### _Ungrouped_ section

Solves the [too many bookmarks problem](#too-many-bookmarks-problem).

Bookmarks in this section are ephemeral. The section is always empty when a user loads the app.

New bookmarks go in this section.

#### Reasoning behind it

- Users will group only the channels that are important to them
- All other bookmarks only need to show up when a new message arrives

#### How it works

The _Ungrouped_ section is empty at startup

When a user receives a message from an ungrouped channel, it appears in the _Unread_ section.

If the user clicks to open the channel, it apperas in the _Ungrouped_ section and stays there until either the app loads again or the user closes the bookmark.

### Example

Legend:

`<` means collapsed.
`>` means expanded.

```
> Unread
  - Tim (1)
  - Wade (3)
  - Rebels Team Room (12)
  - Carlos, Gabriel (1)
< Rebels
  - Rebels Team Room (12)
  - Carlos, Gabriel (1)
  - (I have more bookmarks here but they don't show up because the section is collapsed)
> Dev
  - Nitro Dev Discuss
  - Ben Langfeld
< Bots
< Ungrouped
  - Tim (1)
  - Wade (3)
  - Joshua Graves (I don't have Josh in my groups, but I received a message from him and read it. Now his bookmark stays here until the app loads again)
  -
```

## Past problems

### Too many bookmarks problem

We had a problem with people having 700+ bookmarks that would cause clients to become slow and unresponsive.

## Other ideas

### Sorting bookmarks last message

It will be annoying for people that receive many messages to see bookmarks dancing around all the time.

It's also tricky to keep track of the last message. Clients don't fetch messages for all channels on startup. It's hard to keep track of it in the server too.
