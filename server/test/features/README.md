### User Actions tests

- Document the happy path of specific real-user actions
- Tests that don't inform the correct behavior should go in the `edge_cases` folder

### Example: Creating a Message test

#### Good

- Creates bookmarks for members based on preferences
- Sends notifications to other participants
- Sends new message to members
- Increases other participants' badges
- Sends updated badge to other members

#### Bad - these go in `edge_cases`

- Fails when user is not authenticated
- Returns an error when message's content is empty
- Returns an error channel_id is not given
