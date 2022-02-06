local Comm = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages").Comm)
local Communicator = Comm.ClientComm.new(game:GetService("ReplicatedStorage"), false, "ChunksExample")
local GetChunk = Communicator:GetSignal("GetChunk")
local ChunkReady = Communicator:GetSignal("ChunkReady")
local ChunkExit = Communicator:GetSignal("ChunkExited")

local loadedRoom = nil

for _, v in pairs(workspace.ChunkLoadingSections:GetChildren()) do
    v.Touched:Connect(function(obj)
        if obj and obj.Parent == game.Players.LocalPlayer.Character and obj == game.Players.LocalPlayer.Character.HumanoidRootPart then
            GetChunk:Fire(v:GetAttribute("ChunkKey"))
        end
    end)
    v.TouchEnded:Connect(function(obj)
        if obj and obj.Parent == game.Players.LocalPlayer.Character and obj == game.Players.LocalPlayer.Character.HumanoidRootPart then
            ChunkExit:Fire(v:GetAttribute("ChunkKey"))
            if loadedRoom ~= nil and loadedRoom.Name == v.Name then
                loadedRoom:Destroy()
                loadedRoom = nil
            end
        end
    end)
end

ChunkReady:Connect(function(chunkName)
    local ch = game:GetService("ReplicatedStorage"):WaitForChild("ChunksExample_loaded"):FindFirstChild(chunkName)
    if ch then
        local fch = ch:Clone()
        fch.Parent = workspace
        loadedRoom = fch
    end
end)