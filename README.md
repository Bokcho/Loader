# Chunk Loader

A chunk loader I designed for games with high amounts of details. This loader pulls parts from workspace and stores them in ReplicatedStorage.
When a part is needed, it is then cloned out of ReplicatedStorage and pasted into Workspace for only that client.
If a chunk is left unloaded by all players, the chunk will be deleted from ReplicatedStorage and stored into ServerStorage.  You must define loading areas.

## Requirements 
[Rojo](https://github.com/rojo-rbx/rojo)

