# Tcp Message Packet Definitions

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
1byte: username len
Xbyte: username
4byte: random 32bit integer client authentication id
```

