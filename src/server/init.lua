-- init.lua 
-- XIndexed
-- 02/06/2022


type Chunk = Instance
type Namespace = string

local chunkloaderservice = {}
chunkloaderservice.__index = chunkloaderservice
chunkloaderservice.ClassName = "ChunkLoaderService"

local savechunk = require(script:WaitForChild("lib").chunkstore)
local chunkloader = require(script:WaitForChild("lib").loadchunk)

function chunkloaderservice.new(namespace: Namespace)
    local self = setmetatable({}, chunkloaderservice)
    print("new chunloaderservice generated")
   
    self._chunksaver = savechunk.new(namespace)
    self._chunkloader = chunkloader.new(namespace)

    return self
end

function chunkloaderservice:StoreChunk(chunk: Chunk, loadingRegions: Chunk)
    print(chunk, loadingRegions)
    self._chunksaver:SaveChunks(chunk, loadingRegions)
    task.synchronize()
    self._chunkloader:Store(self._chunksaver:GetRegistry())
end


return chunkloaderservice