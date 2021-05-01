### LoginMutation
  * fails for invalid password 
  * returns access token 

### CreateMessageMutation
  * checks that message's channel and given channel are the same 
  * creates a message that points to another message 
  * fails if user has no access to the channel 
  * fails when for unauthorized users 
  * Creates a message for the current user in a given channel 

### ChannelsQuery
  * returns empty when the user has no channels 
  * returns channels that the user is a member of 

### CreateChannelMembersMutation
  * non-admins can't add members 
  * admins can add members 

### CreateChannelMutation
  * adds the owner as a member 
  * creates a private channel 

### NewMessageSubscription
  * new messages can be subscribed to 

### EditMessageMutation
  * Edits a message 

### MessagesQuery
  * fetch thread messages sorted by most recent 
