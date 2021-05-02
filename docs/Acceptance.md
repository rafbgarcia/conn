### Scenario: User Login
 
  * returns the access token, used to identify the user on upcoming requests 
  * returns an error when user's password is incorrect 

### Scenario: Create messages
 
  * users can create thread messages in channels they are members 
  * users can't send messages in channels they are not members 
  * users can create messages in channels they are members 
  * non-authenticated users can't create messages 
  * users can't send thread messages in channels they are not members 

### Scenario: Fetch messages of a thread
 
  * returns the last 25 messages of a thread 
  * user must be a member of the channel to see thread messages 

### Scenario: Get current user's channels
 
  * returns channels that the user is a member of 
  * returns empty when the user has no channels 

### Scenario: Create a new channel
 
  * users can create a new private channel 
  * the channel creator is added as an admin member 

### Scenario: Add members to a channel
 
  * admins can add members 
  * non-admins can't add members 

### Scenario: Fetch a channel's messages
 
  * returns the last 50 messages of the channel 
  * user must be a member of the channel to see messages 

### Scenario: Edit messages
 
  * users can edit their own messages 
  * users can't edit others' messages 

### Scenario: Real-time channel messages
 
  * users receive new messages in real-time for their channels 
