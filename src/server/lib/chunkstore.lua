-- savechunk.lua
-- XIndexed
-- 02/06/2022

type Chunk = Instance
type Namespace = string

local chunkstore = {}
chunkstore.__index = chunkstore
chunkstore._dbEnabled = true
local HTTPService = game:GetService("HttpService")

chunkstore.debmsgs = {
    CHUNKSTORECREATED = "[ChunkStore]: A new chunk with the namespace \"%s\" has been created!",
    NOCHUNKEXISTSINSTORE = "[ChunkStore]: No such chunk with the name \"%s\" exists in chunkstore namespace \"%s\"!",
    CHUNKDELETEDSUCCESS = "[ChunkStore]: Chunkstore \"%s\" has been deleted successfully!",
    CHUNKDELETEDFAIL = "[ChunkStore]: Chunkstore \"%s\" could not be deleted! \n TRACEBACK\n\n ======================= %s",
    LOG = "[ChunkStore]: %s"
}

local function formatmessage(str, ...)
    return string.format(str, ...)
end

local function dbmsg(...)
    if chunkstore._dbEnabled then
        print(formatmessage(...))
    end
end

function chunkstore.new(namespace: Namespace)
    local self = setmetatable({}, chunkstore)

    self._chunkdef = {}
    self._loadingPoints = {}
    self._chunkstore = Instance.new("Folder")
    self._chunkstore.Name = namespace
    self._chunkstore.Parent = game:GetService("ServerStorage")

    dbmsg(chunkstore.debmsgs.CHUNKSTORECREATED, namespace)

    return self
end

function chunkstore:SaveChunks(chunk: Chunk, chunkLoads: Chunk)
    for _, child in pairs(chunk:GetChildren()) do
        if ( child:IsA("Model") or child:IsA("Folder") ) then
            coroutine.wrap(function()
                child.Parent = self._chunkstore
                local GUID = HTTPService:GenerateGUID(false)
                
                self._chunkdef[GUID] = child.Name
                child:SetAttribute("ChunkKey", GUID)
                if ( chunkLoads:FindFirstChild(child.Name) ) then
                    self._loadingPoints[GUID] = chunkLoads:FindFirstChild(child.Name)
                    chunkLoads[child.Name]:SetAttribute("ChunkKey", GUID)
                end
            end)()
        end
    end

    print(self._chunkdef)
    
end

function chunkstore:GetChunk(chunkId: Namespace)
    if ( self._chunkdef[chunkId] ) then
        return self._chunkdef[chunkId]
    end
    return nil
end

function chunkstore:GetRegistry()
    return {
        Lib = self._chunkdef,
        Lod = self._loadingPoints
    }
end


return chunkstore