### Scenario: User Login
 
  * returns the access token, used to identify the user on upcoming requests 
  * returns an error when user's password is incorrect 

### Scenario: Create messages
 
  * users can create messages in channels they are members 
  * users can create thread messages in channels they are members 
  * users can't send thread messages in channels they are not members 
  * users can't send messages in channels they are not members 
  * non-authenticated users can't create messages 

### Scenario: Fetch messages of a thread
 
  * returns the last 25 messages of a thread 
  * user must be a member of the channel to see thread messages 

### Scenario: Get current user's channels
 
  * returns channels that the user is a member of 
  * returns empty when the user has no channels 

### Scenario: Fetch a channel's messages
 
  * returns the last 50 messages of the channel 
  * user must be a member of the channel to see messages 

### Scenario: Add members to a channel
 
  * admins can add members 
  * non-admins can't add members 

### Scenario: Create a new channel
 
  * users can create a new private channel 
  * the channel creator is added as an admin member 

### Scenario: Edit messages
 
  * users can edit their own messages 
  * users can't edit others' messages 

### Scenario: Real-time channel messages
 
  * users receive new messages in real-time for their channels 
