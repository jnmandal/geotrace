# Geotrace

A contrived example application for demoing erlang concurrency/distribution

Useful things

get the pid of your shell
```
self()
```

empty (and view contents of) your mailbox
```
flush()
```

get the name of your node
```
node()
```

boot a session that can be joined by other nodes
```
$ iex --name john@<ip address> --cookie wyzant -S mix
```

connect to another session
```
Node.connect(:"john@92.168.1.12")
```

view other nodes in the cluster
```
Node.list()
```

call the Geotrace Server
```
john = Node.list() |> List.first()
GenServer.call({GT, john}, :history) # see what everyone is tracing
GenServer.call({GT, john}, {:geocode, "The Acropolis"}) # perform a geocode call
```
