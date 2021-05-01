### LoginMutation
  * returns access token 
  * fails for invalid password 

### CreateMessageMutation
  * creates a message that points to another message 
  * fails if user has no access to the channel 
  * Creates a message for the current user in a given channel 
  * checks that message's channel and given channel are the same 
  * fails when for unauthorized users 

### ChannelsQuery
  * returns channels that the user is a member of 
  * returns empty when the user has no channels 

### CreateChannelMembersMutation
  * admins can add members 
  * non-admins can't add members 

### CreateChannelMutation
  * creates a private channel 
  * adds the owner as a member 

### NewMessageSubscription
  * new messages can be subscribed to 

### EditMessageMutation
  * Edits a message 

### MessagesQuery
  * fetch thread messages sorted by most recent 
