-- loadchunk.lua
-- XIndexed
-- 02/06/2022
type Namespace = string
type Store = table
local loadchunk = {}
loadchunk.__index = loadchunk

local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Comm = require(game:GetService("ReplicatedStorage").Packages.Comm)

function loadchunk.new(chunkstore: Namespace)


    local self = setmetatable({
        _storeKey = chunkstore,
        _lib = {},
        _loaded = false,
    }, loadchunk)

    self.globalLoader = Instance.new("Folder")
    self.globalLoader.Name = chunkstore.."_loaded"
    self.globalLoader.Parent = game:GetService("ReplicatedStorage")


    self.globalComm = Comm.ServerComm.new(game:GetService("ReplicatedStorage"), chunkstore)
    
    self.chunkReady = self.globalComm:CreateSignal("ChunkReady")
    self.chunkExit = self.globalComm:CreateSignal("ChunkExited")
    self.getChunk = self.globalComm:CreateSignal("GetChunk")

    self.getChunk:Connect(function(user, key)
        -- Thread saftey first
        if (  not user:GetAttribute("Room") == key or not user:GetAttribute("Room") and self._lib[key] and not self.globalLoader:FindFirstChild(self._lib[key]) ) then 
            print("Load room")
            user:SetAttribute("Room", key)
            local room = self._lib[key]
            local physicalChunk = game:GetService("ServerStorage")[chunkstore]:FindFirstChild(room)
            if ( physicalChunk and not self.globalLoader:FindFirstChild(physicalChunk.Name) ) then
                physicalChunk:Clone().Parent = self.globalLoader
                self.chunkReady:Fire(user, physicalChunk.Name)
            end
        elseif not user:GetAttribute("Room") == key or not user:GetAttribute("Room") and self.globalLoader:FindFirstChild(self._lib[key]) then
           self.chunkReady:Fire(user, self.globalLoader:FindFirstChild(self._lib[key]).Name)
           user:SetAttribute("Room", key)
        end
    end)


    self.chunkExit:Connect(function(user, key)
        if ( user:GetAttribute("Room") == key and self._lib[key] ) then
            user:SetAttribute("Room", nil)
            if ( self.globalLoader[self._lib[key]] ) then
                local canRemove = true
                for _, player in pairs(game.Players:GetPlayers()) do
                   if player:GetAttribute("Room") and player:GetAttribute("Room") == key then
                       canRemove = false
                   end 
                end
                task.synchronize()
                if canRemove then
                    self.globalLoader:FindFirstChild(self._lib[key]):Destroy()
                    print("Room removed")
                end
            end
        end
    end)

    return self
end

function loadchunk:Store(store: Store)
    assert(store, "Expected a store to be passed but got nothing")
    self._lib = store.Lib
    self._loaded = true
end

function loadchunk:PullChunk(chunkKey: Namespace) -- This method to be used if the chunk does not already exist in ReplicatedStorage. This expects the namespace given
    if self._loaded then
        if ( self._lib[chunkKey] ) then
            
        end
    end
end

return loadchunk