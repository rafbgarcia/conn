### Scenario: User Login

  * returns access token
  * fails for invalid password

### Scenario: Create messages

  * creates a message that points to another message
  * fails if user has no access to the channel
  * creates a message for the current user in a given channel
  * checks that message's channel and given channel are the same
  * fails when for unauthorized users

### Scenario: Get current user's channels

  * returns channels that the user is a member of
  * returns empty when the user has no channels

### Scenario: Add members to a channel

  * admins can add members
  * non-admins can't add members

### Scenario: Create a new channel

  * creates a private channel
  * adds the owner as a member

### Scenario: Real-time channel messages

  * new messages can be subscribed to

### Scenario: Edit messages

  * Edits a message

### Scenario: Fetch a channel's messages

  * fetch thread messages sorted by most recent
