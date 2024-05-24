local userInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local ShoulderCamera = {}

local camEnabled = false
local currentCameraOffset = Vector3.new(2.5,1,2)
local CameraTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local characterFaceCamera = true

local function onRenderStepped(dt)
	userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

	-- set camera cf
	local camDesiredCF = workspace.CurrentCamera.CFrame * CFrame.new(script.CameraOffset.Value)
	workspace.CurrentCamera.CFrame = camDesiredCF

	-- set hrp cf
	if characterFaceCamera then
		player.Character.Humanoid.AutoRotate = false
		local pos = player.Character.HumanoidRootPart.Position
		local lv = workspace.CurrentCamera.CFrame.LookVector
		local hrpDesiredCF = CFrame.lookAt(player.Character.HumanoidRootPart.Position, pos + Vector3.new(lv.X, 0, lv.Z))
		player.Character.HumanoidRootPart.CFrame = hrpDesiredCF--player.Character.HumanoidRootPart.CFrame:lerp(hrpDesiredCF,dt*10)
	end

end

function ShoulderCamera.setEnabled(value : boolean)
	if value == camEnabled then return end
	
	if value == true then
		camEnabled = true
		local CameraOffset = {Value = currentCameraOffset}
		local TweenCameraOffset = TweenService:Create(script.CameraOffset, CameraTweenInfo, CameraOffset)
		TweenCameraOffset:Play()
		RunService:BindToRenderStep("SmoothShoulderCamera", Enum.RenderPriority.Camera.Value + 1, onRenderStepped)
	else
		local CameraOffset = {Value = Vector3.new(0,0,0)}
		local TweenCameraOffset = TweenService:Create(script.CameraOffset, CameraTweenInfo, CameraOffset)
		TweenCameraOffset:Play()
		TweenCameraOffset.Completed:Connect(function()
			RunService:UnbindFromRenderStep("SmoothShoulderCamera")
			camEnabled = false
			userInputService.MouseBehavior = Enum.MouseBehavior.Default
			player.Character.Humanoid.AutoRotate = true
		end)

	end
end

function ShoulderCamera.setOffset(v3 : Vector3)
	currentCameraOffset = v3
	if camEnabled then
		local CameraOffset = {Value = currentCameraOffset}
		local TweenCameraOffset = TweenService:Create(script.CameraOffset, CameraTweenInfo, CameraOffset)
		TweenCameraOffset:Play()
	end
end

function ShoulderCamera.getOffset() : Vector3
	return currentCameraOffset
end

function ShoulderCamera.setCharacterFaceCameraDirection(value : boolean)
	characterFaceCamera = value
	if value == false then
		player.Character.Humanoid.AutoRotate = true
	end
end

return ShoulderCamera
