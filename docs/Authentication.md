### How it works

Token-based. Client request token with a GraphQL mutation

```gql
mutation {
  login($serverId: String!, $login: String!, $password: !String) {
    token
  }
}
```

And use the received token in the `authorization` header on upcoming requests.
