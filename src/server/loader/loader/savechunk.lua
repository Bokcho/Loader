-- savechunk.lua
-- XIndexed
-- 02/06/2022
--[[
    savechunk.lua is used to save your world in segments.
--]]



local savechunk = {}
savechunk.__index = savechunk
savechunk.ClassName = "ChunkSaver"


savechunk.debugmessages = {
    R3CREATED = "Region3 defined for %s. Collection all instances withing Region3 for %s.",
    R3CFINISHED = "Chunk %s has been successfully saved."
}

function savechunk.new(chunkFileName: string)
    local self = setmetatable({
        _chunks = {}, -- A dictionary for faster lookup
        _chunkfile = Instance.new("Folder")
    }, savechunk)

    self._chunkfile.Parent = game:GetService("ServerStorage")
    self._chunkfile.Name = chunkFileName.."_Chunks" or game.Name.."_Chunks"

    return self
end

function savechunk:SaveChunks(chunkFolder: Instance?)
    assert(chunkFolder, "A chunk folder must be defined, with valid chunks. Please read the README file")
    for _, chunkBase in pairs(chunkFolder:GetChildren()) do
        -- Create a new thread so as to load faster
        --Region3.new(Part.Position-(Size/2),Part.Position+(Size/2))
        coroutine.wrap(function()
            local region = Region3.new(chunkBase.Position-(chunkBase.Size/2),chunkBase.Position+(chunkBase.Size/2))
            region.CFrame = chunkBase.CFrame
            self._chunks[chunkBase.Name] = {
                Region = region,
                ReferenceFolder = Instance.new("Folder")
            }
            self._chunks[chunkBase.Name].ReferenceFolder.Parent = game:GetService("ServerStorage")
            self._chunks[chunkBase.Name].ReferenceFolder.Name = chunkBase.Name

            print(string.format(savechunk.debugmessages.R3CREATED, chunkBase.Name))

            
        end)()
    end
end

return savechunk