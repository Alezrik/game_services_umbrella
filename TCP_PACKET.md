# Tcp Message Packet Definitions

## Naming Convntion Header

* CMSG -> A message originating from game client
* SMSG -> A message originating from game server
* GMSG -> A message originating from game server

## Basic Structure

### Very Under Construction 0.2.0
```
8byte:  command id
32byte: message length
Xbytes: message params
```


## Command ID's

### CMSG_AUTHENTICATE_CHALLENGE

Beginning of Authentication Routine - client sends a request for a server secret

* ID: 1
* source: game client
* destination: tcp server

#### Message Params
```
8byte: name length
Xbytes: name
32byte: client challenge key
```

### SMSG_AUTHENTICATE_CHALLENGE

Server response to client challenge

* ID: 2
* source: tcp_server
* destination: game client or game server

#### Message Params

```
32byte: random 32bit integer server authentication id
8byte: salt len
Xbyte: salt
```

### GMSG_AUTHENTICATE_CHALLENGE

Game Server Authenticate Challenge

* ID: 3
* source: game server
* destination: tcp server

### Message Params

* TBD

### CMSG_AUTHENTICATE

Client requests to authenticate

* ID: 4
* source: game client
* destination: tcp server

### Message Params

```
Xbytes: hash result |> Base64.encode()
```

#### Hash Creation
"client_rand+server_rand+password+salt" as a string

### SMSG_AUTHENTICATE

Server responds to client authenticate

* ID: 5
* source: tcp server
* destination: game server or client

```
8byte: success(1 = true, 0 = false)
32byte: token length
Xbytes: token
```
