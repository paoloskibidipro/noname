-- ============================================================================
-- 👻 KILLER HUB - MM2 ADVANCED VISUAL SUITE (ENGLISH ULTRA-OPTIMIZED V4.0)
-- ============================================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local fileName = "KillerHubMM2VisualConfig.json"
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Fast Local Cache
local pairs = pairs
local ipairs = ipairs
local type = type
local pcall = pcall
local tonumber = tonumber
local tostring = tostring
local math_floor = math.floor
local math_abs = math.abs
local Vector3_new = Vector3.new
local Vector2_new = Vector2.new
local Color3_fromRGB = Color3.fromRGB
local ColorSequence_new = ColorSequence.new
local ColorSequenceKeypoint_new = ColorSequenceKeypoint.new
local Instance_new = Instance.new
local UDim2_new = UDim2.new
local CFrame_new = CFrame.new
local playersGetPlayers = Players.GetPlayers

-- Default Game Roles Colors
local DefaultColors = {
    Murderer = Color3_fromRGB(180, 55, 55),
    Sheriff  = Color3_fromRGB(35, 102, 204),
    Hero     = Color3_fromRGB(230, 188, 62),
    Innocent = Color3_fromRGB(26, 171, 81),
    Dead     = Color3_fromRGB(115, 115, 115),
    GunDrop  = Color3_fromRGB(255, 0, 0)
}

local BlackColor = Color3_fromRGB(0, 0, 0)

-- [1] CONFIGURATION TABLE
local Config = { 
    Highlight = false, 
    HighlightTrans = 50,
    HighlightRoles = {["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, ["Dead/None"] = false},
    
    Box = false, 
    BoxRoles = {["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, ["Dead/None"] = false},
    
    Name = false, 
    NameRoles = {["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, ["Dead/None"] = false},
    
    Tracer = false,
    TracerPosition = "Bottom Center", -- English Options: "Bottom Center", "Top Center", "Middle Left", "Middle Right", "Center Screen"
    TracerRoles = {["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, ["Dead/None"] = false},

    LimbChams = false,
    LimbChamsTrans = 50,
    LimbChamsRoles = {["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, ["Dead/None"] = false},

    -- MY ESP INDIVIDUAL CONFIGURATION
    MyESP = {
        Highlight = false,
        HighlightTrans = 50,
        HighlightColorActive = false,
        HighlightColorRGB = {255, 255, 255},

        LimbChams = false,
        LimbChamsTrans = 50,
        LimbChamsColorActive = false,
        LimbChamsColorRGB = {255, 255, 255},

        Box = false,
        BoxColorActive = false,
        BoxColorRGB = {255, 255, 255},

        Name = false,
        NameColorActive = false,
        NameColorRGB = {255, 255, 255},

        Skeleton = false,
        SkeletonColorActive = false,
        SkeletonColorRGB = {255, 255, 255},

        CameraFOV = false,
        CameraFOVValue = 70,

        StretchedCam = false,
        StretchedCamValue = 0.67
    },

    GunCham = false,    
    GunName = false,    
    GunTracer = false, 
    NameSize = 13,      
    GunNameSize = 14,
    MaxDistance = 400,
    
    CustomColorsActive = {["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, ["Dead/None"] = false, ["GunDrop"] = false},
    CustomColorsRGB = {
        ["Murderer"] = {180, 55, 55},
        ["Sheriff"]  = {35, 102, 204},
        ["Hero"]     = {230, 188, 62},
        ["Innocent"] = {26, 171, 81},
        ["Dead/None"]= {115, 115, 115},
        ["GunDrop"]  = {255, 0, 0}
    }
}

-- [2] LOCAL STORAGE SYSTEM
local function saveConfig()
    if writefile then
        pcall(function()
            writefile(fileName, HttpService:JSONEncode(Config))
        end)
    end
end

if isfile and isfile(fileName) and readfile then
    pcall(function()
        local loaded = HttpService:JSONDecode(readfile(fileName))
        if type(loaded) == "table" then
            for k, v in pairs(loaded) do
                if k == "MyESP" and type(v) == "table" then
                    for subK, subVal in pairs(v) do
                        Config.MyESP[subK] = subVal
                    end
                elseif type(v) == "table" then
                    for subKey, subVal in pairs(v) do
                        if Config[k] then Config[k][subKey] = subVal end
                    end
                else
                    Config[k] = v
                end
            end
        end
    end)
end

-- [3] GRAPHICAL INTERFACE (ENGLISH)
local KillerHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Paolo0109/KillerHUB/refs/heads/main/InterfazBase.lua"))()

local VisualsTab = KillerHub:CreateTab("Visuals", "rbxassetid://6523858394")
local PagePlayers = VisualsTab:CreatePage("Players ESP", "Eye")
local PageMyESP   = VisualsTab:CreatePage("My ESP", "Player")

-- ==========================================
-- PAGE 1: PLAYERS ESP
-- ==========================================
PagePlayers:CreateSection("Player ESP")

local ToggleHighlight = PagePlayers:CreateToggleSlider("EspHighlight", "EspHighlightTrans", "Highlight ESP", 0, 100, 
    function(val) Config.Highlight = val; saveConfig() end,
    function(val) Config.HighlightTrans = math_floor(val); saveConfig() end
)
PagePlayers:CreateMultiDropdown("HighlightFilters", "Roles", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.HighlightRoles) do Config.HighlightRoles[r] = flags[r] == true end; saveConfig()
end)

local ToggleLimbChams = PagePlayers:CreateToggleSlider("EspLimbChams", "EspLimbChamsTrans", "Cham ESP", 0, 100, 
    function(val) Config.LimbChams = val; saveConfig() end,
    function(val) Config.LimbChamsTrans = math_floor(val); saveConfig() end
)
PagePlayers:CreateMultiDropdown("LimbChamsFilters", "Roles", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.LimbChamsRoles) do Config.LimbChamsRoles[r] = flags[r] == true end; saveConfig()
end)

local ToggleBox = PagePlayers:CreateToggle("EspBox", "Box ESP", function(val) Config.Box = val; saveConfig() end)
PagePlayers:CreateMultiDropdown("BoxFilters", "Roles", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.BoxRoles) do Config.BoxRoles[r] = flags[r] == true end; saveConfig()
end)

local ToggleName = PagePlayers:CreateToggle("EspName", "Name ESP", function(val) Config.Name = val; saveConfig() end)
PagePlayers:CreateMultiDropdown("NameFilters", "Roles", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.NameRoles) do Config.NameRoles[r] = flags[r] == true end; saveConfig()
end)

local ToggleTracer = PagePlayers:CreateToggle("EspTracer", "Tracer ESP", function(val) Config.Tracer = val; saveConfig() end)
PagePlayers:CreateDropdown("EspTracerPos", "Tracer Position", {"Bottom Center", "Top Center", "Middle Left", "Middle Right", "Center Screen"}, function(sel)
    Config.TracerPosition = sel
    saveConfig()
end, Config.TracerPosition or "Bottom Center")

PagePlayers:CreateMultiDropdown("TracerFilters", "Roles", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.TracerRoles) do Config.TracerRoles[r] = flags[r] == true end; saveConfig()
end)

local DropHighlight = KillerHub.Elements["HighlightFilters"]
local DropLimbChams = KillerHub.Elements["LimbChamsFilters"]
local DropBox       = KillerHub.Elements["BoxFilters"]
local DropName      = KillerHub.Elements["NameFilters"]
local DropTracer    = KillerHub.Elements["TracerFilters"]

PagePlayers:CreateSection("Dropped Gun ESP")
local ToggleGunCham = PagePlayers:CreateToggle("EspGunCham", "Gun Cham", function(val) Config.GunCham = val; saveConfig() end)
local ToggleGunName = PagePlayers:CreateToggle("EspGunName", "Gun Name", function(val) Config.GunName = val; saveConfig() end)
local ToggleGunTracer = PagePlayers:CreateToggle("EspGunTracer", "Gun Tracer", function(val) Config.GunTracer = val; saveConfig() end)

PagePlayers:CreateSection("Role Colors Customization")
local function createRoleColorPicker(roleKey, visualName)
    local defaultRGB = Config.CustomColorsRGB[roleKey]
    local defaultColor3 = Color3_fromRGB(defaultRGB[1], defaultRGB[2], defaultRGB[3])
    
    PagePlayers:CreateToggleColorPicker(
        "CP_Active_" .. roleKey, "CP_Color_" .. roleKey, visualName, defaultColor3,
        function(estado) Config.CustomColorsActive[roleKey] = estado; saveConfig() end,
        function(colorSeleccionado)
            Config.CustomColorsRGB[roleKey] = {math_floor(colorSeleccionado.R * 255), math_floor(colorSeleccionado.G * 255), math_floor(colorSeleccionado.B * 255)}
            saveConfig()
        end
    )
end
createRoleColorPicker("Murderer", "Murderer")
createRoleColorPicker("Sheriff", "Sheriff")
createRoleColorPicker("Hero", "Hero")
createRoleColorPicker("Innocent", "Innocent")
createRoleColorPicker("Dead/None", "Dead / Spectators")
createRoleColorPicker("GunDrop", "Dropped Gun")

PagePlayers:CreateSection("Settings & Performance")
local DistanceInput = PagePlayers:CreateInput("EspMaxDistance", "Max Render Distance (Studs)", "400", function(val)
    local num = tonumber(val)
    if num then Config.MaxDistance = math_abs(num); saveConfig()
    else KillerHub:NotifyWarn("Invalid Input", "Please enter numbers only.", 3) end
end)
local NameSizeSlider = PagePlayers:CreateSlider("EspNameSize", "Name Size", 10, 30, function(val) Config.NameSize = math_floor(val); saveConfig() end)
local GunNameSizeSlider = PagePlayers:CreateSlider("EspGunNameSize", "Gun Name Size", 10, 30, function(val) Config.GunNameSize = math_floor(val); saveConfig() end)

-- ==========================================
-- PAGE 2: MY ESP
-- ==========================================
PageMyESP:CreateSection("Self ESP Features")

local ToggleMyHighlight = PageMyESP:CreateToggleSlider("MyEspHighlight", "MyEspHighlightTrans", "Highlight ESP", 0, 100,
    function(val) Config.MyESP.Highlight = val; saveConfig() end,
    function(val) Config.MyESP.HighlightTrans = math_floor(val); saveConfig() end
)

local ToggleMyLimbChams = PageMyESP:CreateToggleSlider("MyEspLimbChams", "MyEspLimbChamsTrans", "Cham ESP", 0, 100,
    function(val) Config.MyESP.LimbChams = val; saveConfig() end,
    function(val) Config.MyESP.LimbChamsTrans = math_floor(val); saveConfig() end
)

local ToggleMyBox = PageMyESP:CreateToggle("MyEspBox", "Box ESP", function(val) Config.MyESP.Box = val; saveConfig() end)
local ToggleMyName = PageMyESP:CreateToggle("MyEspName", "Name ESP", function(val) Config.MyESP.Name = val; saveConfig() end)
local ToggleMySkeleton = PageMyESP:CreateToggle("MyEspSkeleton", "Skeleton ESP", function(val) Config.MyESP.Skeleton = val; saveConfig() end)

PageMyESP:CreateSection("Self Custom Colors")

local function createMyESPColorPicker(featureKey, featureName)
    local defaultRGB = Config.MyESP[featureKey .. "ColorRGB"]
    local defaultColor3 = Color3_fromRGB(defaultRGB[1], defaultRGB[2], defaultRGB[3])
    
    PageMyESP:CreateToggleColorPicker(
        "CP_Active_My_" .. featureKey, "CP_Color_My_" .. featureKey, featureName .. " Color", defaultColor3,
        function(estado) Config.MyESP[featureKey .. "ColorActive"] = estado; saveConfig() end,
        function(colorSeleccionado)
            Config.MyESP[featureKey .. "ColorRGB"] = {math_floor(colorSeleccionado.R * 255), math_floor(colorSeleccionado.G * 255), math_floor(colorSeleccionado.B * 255)}
            saveConfig()
        end
    )
end

createMyESPColorPicker("Highlight", "Highlight")
createMyESPColorPicker("LimbChams", "Cham")
createMyESPColorPicker("Box", "Box")
createMyESPColorPicker("Name", "Name")
createMyESPColorPicker("Skeleton", "Skeleton")

PageMyESP:CreateSection("Camera Features")

local ToggleCamFOV = PageMyESP:CreateToggleSlider("MyEspCamFOV", "MyEspCamFOVVal", "Camera FOV", 30, 120,
    function(val) 
        Config.MyESP.CameraFOV = val
        if not val then Camera.FieldOfView = 70 end
        saveConfig() 
    end,
    function(val) 
        Config.MyESP.CameraFOVValue = math_floor(val)
        saveConfig() 
    end,
    Config.MyESP.CameraFOV, Config.MyESP.CameraFOVValue
)

local ToggleStretchedCam = PageMyESP:CreateToggleSlider("MyEspStretchedCam", "MyEspStretchedCamVal", "Stretched Camera", 1, 100,
    function(val) Config.MyESP.StretchedCam = val; saveConfig() end,
    function(val) Config.MyESP.StretchedCamValue = val / 100; saveConfig() end,
    Config.MyESP.StretchedCam, math_floor((Config.MyESP.StretchedCamValue or 0.67) * 100)
)

-- [4] APPLY SAVED CONFIGURATIONS SAFELY
ToggleName:Set(Config.Name)
ToggleTracer:Set(Config.Tracer)
ToggleGunCham:Set(Config.GunCham); ToggleGunName:Set(Config.GunName); ToggleGunTracer:Set(Config.GunTracer); NameSizeSlider:Set(Config.NameSize); GunNameSizeSlider:Set(Config.GunNameSize)
ToggleBox:Set(Config.Box)

if ToggleHighlight then
    ToggleHighlight:SetToggle(Config.Highlight)
    ToggleHighlight:SetSlider(Config.HighlightTrans)
end

if ToggleLimbChams then
    ToggleLimbChams:SetToggle(Config.LimbChams)
    ToggleLimbChams:SetSlider(Config.LimbChamsTrans)
end

ToggleMyBox:Set(Config.MyESP.Box)
ToggleMyName:Set(Config.MyESP.Name)
ToggleMySkeleton:Set(Config.MyESP.Skeleton)
if ToggleMyHighlight then
    ToggleMyHighlight:SetToggle(Config.MyESP.Highlight)
    ToggleMyHighlight:SetSlider(Config.MyESP.HighlightTrans)
end
if ToggleMyLimbChams then
    ToggleMyLimbChams:SetToggle(Config.MyESP.LimbChams)
    ToggleMyLimbChams:SetSlider(Config.MyESP.LimbChamsTrans)
end

local myFeatures = {"Highlight", "LimbChams", "Box", "Name", "Skeleton"}
for _, fKey in ipairs(myFeatures) do
    local toggleInstance = getgenv().KillerHub and getgenv().KillerHub.Flags and getgenv().KillerHub.Flags["CP_Active_My_" .. fKey]
    if toggleInstance and toggleInstance.Set then toggleInstance:Set(Config.MyESP[fKey .. "ColorActive"]) end
end

if DistanceInput and DistanceInput.Set then DistanceInput:Set(tostring(Config.MaxDistance)) end
if DropHighlight and DropHighlight.Set then pcall(function() DropHighlight:Set(Config.HighlightRoles) end) end
if DropLimbChams and DropLimbChams.Set then pcall(function() DropLimbChams:Set(Config.LimbChamsRoles) end) end
if DropBox and DropBox.Set then pcall(function() DropBox:Set(Config.BoxRoles) end) end
if DropName and DropName.Set then pcall(function() DropName:Set(Config.NameRoles) end) end
if DropTracer and DropTracer.Set then pcall(function() DropTracer:Set(Config.TracerRoles) end) end

for roleKey, _ in pairs(Config.CustomColorsActive) do
    local toggleInstance = getgenv().KillerHub and getgenv().KillerHub.Flags and getgenv().KillerHub.Flags["CP_Active_" .. roleKey]
    if toggleInstance and toggleInstance.Set then toggleInstance:Set(Config.CustomColorsActive[roleKey]) end
end

-- ============================================================================
-- 🧠 CORE ENGINE (ULTRA-OPTIMIZED V4.0)
-- ============================================================================

local playerRoles = {} 
local playerDeadStatus = {} 
local currentGunDrop = nil 

local GunDrawingLine = Drawing.new("Line")
GunDrawingLine.Thickness = 1
GunDrawingLine.Transparency = 1
GunDrawingLine.Visible = false

local playerTracers = {}
local mySkeletonLines = {}

local R6Bones = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"}
}

local R15Bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightUpperLeg", "RightFoot"}
}

local function clearMySkeleton()
    for _, line in pairs(mySkeletonLines) do
        line.Visible = false
        pcall(function() line:Remove() end)
    end
    table.clear(mySkeletonLines)
end

local function getTracerLine(player)
    if not playerTracers[player] then
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Transparency = 1
        line.Visible = false
        playerTracers[player] = line
    end
    return playerTracers[player]
end

local function removeTracerLine(player)
    if playerTracers[player] then
        pcall(function()
            playerTracers[player].Visible = false
            playerTracers[player]:Remove()
        end)
        playerTracers[player] = nil
    end
end

local function getRoleColor(roleKey, fallbackColor3)
    if Config.CustomColorsActive[roleKey] == true then
        local rgb = Config.CustomColorsRGB[roleKey]
        return Color3_fromRGB(rgb[1], rgb[2], rgb[3])
    end
    return fallbackColor3
end

local function getPlayerColorAndStatus(player)
    local char = player.Character
    local name = player.Name
    
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local isDeadInGame = not char or not humanoid or humanoid.Health <= 0
    local isDeadInNetwork = playerDeadStatus[name] == true

    if isDeadInGame or isDeadInNetwork then
        return getRoleColor("Dead/None", DefaultColors.Dead), "Dead/None"
    end

    local backpack = player:FindFirstChild("Backpack")
    local hasKnife = (char and char:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife"))
    local hasGun = (char and (char:FindFirstChild("Gun") or char:FindFirstChild("Revolver"))) or 
                   (backpack and (backpack:FindFirstChild("Gun") or backpack:FindFirstChild("Revolver")))

    if hasKnife or playerRoles[name] == "Murderer" then 
        playerRoles[name] = "Murderer"
        return getRoleColor("Murderer", DefaultColors.Murderer), "Murderer"
    end

    if hasGun then
        if playerRoles[name] == "Sheriff" then 
            return getRoleColor("Sheriff", DefaultColors.Sheriff), "Sheriff"
        else 
            return getRoleColor("Hero", DefaultColors.Hero), "Hero" 
        end
    end

    if playerRoles[name] == "Sheriff" then 
        return getRoleColor("Sheriff", DefaultColors.Sheriff), "Sheriff"
    elseif playerRoles[name] == "Hero" then 
        return getRoleColor("Hero", DefaultColors.Hero), "Hero"
    end

    return getRoleColor("Innocent", DefaultColors.Innocent), "Innocent"
end

local function getMyFeatureColor(featureKey)
    local activeKey = featureKey .. "ColorActive"
    local rgbKey = featureKey .. "ColorRGB"
    if Config.MyESP[activeKey] == true then
        local rgb = Config.MyESP[rgbKey]
        return Color3_fromRGB(rgb[1], rgb[2], rgb[3])
    end
    local defaultColor, _ = getPlayerColorAndStatus(LocalPlayer)
    return defaultColor
end

local function clearPlayerESP(char)
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        local box = root:FindFirstChild("KH_2DBox")
        local nameTag = root:FindFirstChild("KH_Name")
        local myBox = root:FindFirstChild("KH_My2DBox")
        local myNameTag = root:FindFirstChild("KH_MyName")
        if box then box:Destroy() end
        if nameTag then nameTag:Destroy() end
        if myBox then myBox:Destroy() end
        if myNameTag then myNameTag:Destroy() end
    end
    
    local limbFolder = char:FindFirstChild("KH_LimbChams")
    if limbFolder then limbFolder:Destroy() end
    local myLimbFolder = char:FindFirstChild("KH_MyLimbChams")
    if myLimbFolder then myLimbFolder:Destroy() end
    
    local hl = char:FindFirstChild("KH_Highlight")
    if hl then hl:Destroy() end
    local myHl = char:FindFirstChild("KH_MyHighlight")
    if myHl then myHl:Destroy() end
end

local function updatePlayerESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not root or not myRoot then return end
    
    local distance = (myRoot.Position - root.Position).Magnitude
    if distance > Config.MaxDistance then
        clearPlayerESP(char) 
        return
    end
    
    local color, currentStatus = getPlayerColorAndStatus(player)

    -- Cham ESP
    local limbFolder = char:FindFirstChild("KH_LimbChams")
    if Config.LimbChams and Config.LimbChamsRoles[currentStatus] == true then
        if not limbFolder then
            limbFolder = Instance_new("Folder")
            limbFolder.Name = "KH_LimbChams"
            limbFolder.Parent = char
        end
        
        local currentTrans = Config.LimbChamsTrans / 100
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local adornName = part.Name .. "_Adorn"
                local adorn = limbFolder:FindFirstChild(adornName)
                if not adorn then
                    adorn = Instance_new("BoxHandleAdornment")
                    adorn.Name = adornName
                    adorn.AlwaysOnTop = true
                    adorn.ZIndex = 5
                    adorn.Parent = limbFolder
                end
                adorn.Adornee = part
                adorn.Size = part.Size + Vector3_new(0.02, 0.02, 0.02)
                adorn.Color3 = color
                adorn.Transparency = currentTrans
            end
        end
    else
        if limbFolder then limbFolder:Destroy() end
    end

    -- BOX 2D ESP
    local box = root:FindFirstChild("KH_2DBox")
    if Config.Box and Config.BoxRoles[currentStatus] == true then
        if not box then
            box = Instance_new("BillboardGui"); box.Name = "KH_2DBox"; box.Size = UDim2_new(4.4, 0, 5.9, 0); box.AlwaysOnTop = true
            local frame = Instance_new("Frame"); frame.Size = UDim2_new(1, 0, 1, 0); frame.BackgroundTransparency = 1; frame.Parent = box
            local stroke = Instance_new("UIStroke"); stroke.Thickness = 1.2; stroke.Name = "Outline"; stroke.Parent = frame
            box.Adornee = root; box.Parent = root
        end
        box.Frame.Outline.Color = color
    else
        if box then box:Destroy() end
    end

    -- NAME ESP
    local nameTag = root:FindFirstChild("KH_Name")
    if Config.Name and Config.NameRoles[currentStatus] == true then
        if not nameTag then
            nameTag = Instance_new("BillboardGui"); nameTag.Name = "KH_Name"; nameTag.Size = UDim2_new(0, 160, 0, 40); nameTag.StudsOffset = Vector3_new(0, 4.0, 0); nameTag.AlwaysOnTop = true
            local label = Instance_new("TextLabel"); label.Name = "Display"; label.Size = UDim2_new(1, 0, 1, 0); label.BackgroundTransparency = 1
            label.Font = Enum.Font.SourceSansBold; label.TextStrokeTransparency = 0.3; label.Parent = nameTag
            nameTag.Adornee = root; nameTag.Parent = root
        end
        nameTag.Display.Text = player.Name
        nameTag.Display.TextColor3 = color
        nameTag.Display.TextSize = Config.NameSize
    else
        if nameTag then nameTag:Destroy() end
    end

    -- HIGHLIGHT ENGINE
    local hl = char:FindFirstChild("KH_Highlight")
    local allowHighlight = Config.Highlight and Config.HighlightRoles[currentStatus] == true

    if allowHighlight then
        if not hl then
            hl = Instance_new("Highlight"); hl.Name = "KH_Highlight"; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = char
        end
        hl.Adornee = char
        hl.FillColor = color
        hl.FillTransparency = Config.HighlightTrans / 100 
        hl.OutlineColor = color
        hl.OutlineTransparency = 0 
    else
        if hl then hl:Destroy() end
    end
end

local function updateMyESP()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local limbFolder = char:FindFirstChild("KH_MyLimbChams")
    if Config.MyESP.LimbChams then
        local chamColor = getMyFeatureColor("LimbChams")
        if not limbFolder then
            limbFolder = Instance_new("Folder")
            limbFolder.Name = "KH_MyLimbChams"
            limbFolder.Parent = char
        end
        local currentTrans = Config.MyESP.LimbChamsTrans / 100
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local adornName = part.Name .. "_MyAdorn"
                local adorn = limbFolder:FindFirstChild(adornName)
                if not adorn then
                    adorn = Instance_new("BoxHandleAdornment")
                    adorn.Name = adornName
                    adorn.AlwaysOnTop = true
                    adorn.ZIndex = 5
                    adorn.Parent = limbFolder
                end
                adorn.Adornee = part
                adorn.Size = part.Size + Vector3_new(0.02, 0.02, 0.02)
                adorn.Color3 = chamColor
                adorn.Transparency = currentTrans
            end
        end
    else
        if limbFolder then limbFolder:Destroy() end
    end

    local box = root:FindFirstChild("KH_My2DBox")
    if Config.MyESP.Box then
        local boxColor = getMyFeatureColor("Box")
        if not box then
            box = Instance_new("BillboardGui")
            box.Name = "KH_My2DBox"
            box.Size = UDim2_new(4.4, 0, 5.9, 0)
            box.AlwaysOnTop = true
            
            local mainFrame = Instance_new("Frame")
            mainFrame.Name = "MainFrame"
            mainFrame.Size = UDim2_new(1, 0, 1, 0)
            mainFrame.BackgroundTransparency = 1
            mainFrame.Parent = box

            local thickOffset = 2
            local cSize = 0.22

            local function addCornerSegment(name, pos, size, gradRotation)
                local frame = Instance_new("Frame")
                frame.Name = name
                frame.Position = pos
                frame.Size = size
                frame.BorderSizePixel = 0
                frame.Parent = mainFrame
                
                local grad = Instance_new("UIGradient")
                grad.Name = "Grad"
                grad.Rotation = gradRotation
                grad.Parent = frame
                return frame
            end

            addCornerSegment("TL_H", UDim2_new(0, 0, 0, 0), UDim2_new(cSize, 0, 0, thickOffset), 0)
            addCornerSegment("TL_V", UDim2_new(0, 0, 0, 0), UDim2_new(0, thickOffset, cSize, 0), 90)
            addCornerSegment("TR_H", UDim2_new(1 - cSize, 0, 0, 0), UDim2_new(cSize, 0, 0, thickOffset), 180)
            addCornerSegment("TR_V", UDim2_new(1, -thickOffset, 0, 0), UDim2_new(0, thickOffset, cSize, 0), 90)
            addCornerSegment("BL_H", UDim2_new(0, 0, 1, -thickOffset), UDim2_new(cSize, 0, 0, thickOffset), 0)
            addCornerSegment("BL_V", UDim2_new(0, 0, 1 - cSize, 0), UDim2_new(0, thickOffset, cSize, 0), 270)
            addCornerSegment("BR_H", UDim2_new(1 - cSize, 0, 1, -thickOffset), UDim2_new(cSize, 0, 0, thickOffset), 180)
            addCornerSegment("BR_V", UDim2_new(1, -thickOffset, 1 - cSize, 0), UDim2_new(0, thickOffset, cSize, 0), 270)

            box.Adornee = root
            box.Parent = root
        end

        local main = box:FindFirstChild("MainFrame")
        if main then
            local gradColorSeq = ColorSequence_new({
                ColorSequenceKeypoint_new(0, boxColor),
                ColorSequenceKeypoint_new(0.7, boxColor),
                ColorSequenceKeypoint_new(1, BlackColor)
            })
            for _, child in ipairs(main:GetChildren()) do
                local grad = child:FindFirstChild("Grad")
                if grad then
                    grad.Color = gradColorSeq
                end
            end
        end
    else
        if box then box:Destroy() end
    end

    local nameTag = root:FindFirstChild("KH_MyName")
    if Config.MyESP.Name then
        local nameColor = getMyFeatureColor("Name")
        if not nameTag then
            nameTag = Instance_new("BillboardGui"); nameTag.Name = "KH_MyName"; nameTag.Size = UDim2_new(0, 160, 0, 40); nameTag.StudsOffset = Vector3_new(0, 4.0, 0); nameTag.AlwaysOnTop = true
            local label = Instance_new("TextLabel"); label.Name = "Display"; label.Size = UDim2_new(1, 0, 1, 0); label.BackgroundTransparency = 1
            label.Font = Enum.Font.SourceSansBold; label.TextStrokeTransparency = 0.3; label.Parent = nameTag
            nameTag.Adornee = root; nameTag.Parent = root
        end
        nameTag.Display.Text = LocalPlayer.Name
        nameTag.Display.TextColor3 = nameColor
        nameTag.Display.TextSize = Config.NameSize
    else
        if nameTag then nameTag:Destroy() end
    end

    local hl = char:FindFirstChild("KH_MyHighlight")
    if Config.MyESP.Highlight then
        local hlColor = getMyFeatureColor("Highlight")
        if not hl then
            hl = Instance_new("Highlight"); hl.Name = "KH_MyHighlight"; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = char
        end
        hl.Adornee = char
        hl.FillColor = hlColor
        hl.FillTransparency = Config.MyESP.HighlightTrans / 100
        hl.OutlineColor = hlColor
        hl.OutlineTransparency = 0
    else
        if hl then hl:Destroy() end
    end
end

local function checkGunInstance(part)
    if part and part.Name == "GunDrop" and part:IsA("BasePart") then currentGunDrop = part end
end
Workspace.ChildAdded:Connect(checkGunInstance)

local function updateGunESP()
    if not currentGunDrop or not currentGunDrop:IsDescendantOf(Workspace) then
        currentGunDrop = Workspace:FindFirstChild("GunDrop", true)
    end

    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if currentGunDrop and currentGunDrop:IsA("BasePart") and myRoot then
        local distance = (myRoot.Position - currentGunDrop.Position).Magnitude
        if distance > Config.MaxDistance then
            local hl = currentGunDrop:FindFirstChild("KH_GunHighlight")
            local nameTag = currentGunDrop:FindFirstChild("KH_GunName")
            if hl then hl:Destroy() end
            if nameTag then nameTag:Destroy() end
            return
        end

        local gunColor = getRoleColor("GunDrop", DefaultColors.GunDrop)

        local hl = currentGunDrop:FindFirstChild("KH_GunHighlight")
        if Config.GunCham then
            if not hl then
                hl = Instance_new("Highlight"); hl.Name = "KH_GunHighlight"; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Adornee = currentGunDrop; hl.Parent = currentGunDrop
            end
            hl.FillColor = gunColor; hl.FillTransparency = 0; hl.OutlineTransparency = 1      
        elseif hl then hl:Destroy() end

        local nameTag = currentGunDrop:FindFirstChild("KH_GunName")
        if Config.GunName then
            if not nameTag then
                nameTag = Instance_new("BillboardGui"); nameTag.Name = "KH_GunName"; nameTag.Size = UDim2_new(0, 180, 0, 40); nameTag.StudsOffset = Vector3_new(0, 2.5, 0); nameTag.AlwaysOnTop = true
                local label = Instance_new("TextLabel"); label.Name = "Display"; label.Size = UDim2_new(1, 0, 1, 0); label.BackgroundTransparency = 1
                label.Font = Enum.Font.SourceSansBold; label.TextStrokeTransparency = 0.1; label.TextStrokeColor3 = Color3_fromRGB(0, 0, 0); label.Text = "GUN HERE"; label.Parent = nameTag
                nameTag.Adornee = currentGunDrop; nameTag.Parent = currentGunDrop
            end
            nameTag.Display.TextColor3 = gunColor
            nameTag.Display.TextSize = Config.GunNameSize
        elseif nameTag then nameTag:Destroy() end
    end
end

local PlayerDataChanged = ReplicatedStorage:FindFirstChild("PlayerDataChanged", true)
local RoundStart = ReplicatedStorage:FindFirstChild("RoundStart", true)

local function parsePlayerData(tabla)
    if type(tabla) == "table" then
        for name, data in pairs(tabla) do
            if type(data) == "table" then
                if data.Role then playerRoles[name] = data.Role end
                if data.Dead ~= nil then playerDeadStatus[name] = data.Dead end
            end
        end
    end
end

if PlayerDataChanged and PlayerDataChanged:IsA("RemoteEvent") then PlayerDataChanged.OnClientEvent:Connect(parsePlayerData) end
if RoundStart and RoundStart:IsA("RemoteEvent") then
    RoundStart.OnClientEvent:Connect(function(arg1, arg2)
        table.clear(playerRoles); table.clear(playerDeadStatus); currentGunDrop = nil 
        parsePlayerData(arg2); parsePlayerData(arg1)
    end)
end

local RoundOver = ReplicatedStorage:FindFirstChild("RoundOver", true) or ReplicatedStorage:FindFirstChild("SnowballRoundOver", true)
if RoundOver and RoundOver:IsA("RemoteEvent") then
    RoundOver.OnClientEvent:Connect(function()
        table.clear(playerRoles); table.clear(playerDeadStatus); currentGunDrop = nil
        local allPlayers = playersGetPlayers(Players)
        for i = 1, #allPlayers do 
            local plr = allPlayers[i]
            if plr and plr.Character then clearPlayerESP(plr.Character) end 
        end
    end)
end

Players.PlayerRemoving:Connect(function(player)
    playerRoles[player.Name] = nil; playerDeadStatus[player.Name] = nil
    removeTracerLine(player)
end)

-- OPTIMIZED REFRESH LOOP
task.spawn(function()
    while true do
        local allPlayers = playersGetPlayers(Players)
        for i = 1, #allPlayers do
            local plr = allPlayers[i]
            if plr and plr.Character then
                updatePlayerESP(plr)
            end
        end
        updateMyESP()
        updateGunESP()
        task.wait(0.15)
    end
end)

-- DYNAMIC TRACER ORIGIN RESOLVER (CENTER-LEFT, CENTER-RIGHT & TOP-CENTER ADDED)
local function getTracerOriginPoint(viewportSize, mode)
    if mode == "Top Center" then
        return Vector2_new(viewportSize.X / 2, 0)
    elseif mode == "Middle Left" then
        return Vector2_new(0, viewportSize.Y / 2)
    elseif mode == "Middle Right" then
        return Vector2_new(viewportSize.X, viewportSize.Y / 2)
    elseif mode == "Center Screen" then
        return Vector2_new(viewportSize.X / 2, viewportSize.Y / 2)
    end
    -- Default: Bottom Center
    return Vector2_new(viewportSize.X / 2, viewportSize.Y)
end

-- RENDER STEPPED (SKELETON, TRACERS & CAMERA ENGINE)
RunService.RenderStepped:Connect(function()
    if Config.MyESP.CameraFOV then
        local targetFOV = Config.MyESP.CameraFOVValue or 70
        if Camera.FieldOfView ~= targetFOV then
            Camera.FieldOfView = targetFOV
        end
    end

    if Config.MyESP.StretchedCam then
        local stretchFactor = Config.MyESP.StretchedCamValue or 0.67
        Camera.CFrame = Camera.CFrame * CFrame_new(0, 0, 0, 1, 0, 0, 0, stretchFactor, 0, 0, 0, 1)
    end

    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    -- 1. RENDER MY SKELETON ESP
    if Config.MyESP.Skeleton and myChar then
        local humanoid = myChar:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
            local boneList = isR15 and R15Bones or R6Bones
            local skelColor = getMyFeatureColor("Skeleton")

            for i = 1, #boneList do
                if not mySkeletonLines[i] then
                    local line = Drawing.new("Line")
                    line.Thickness = 1.5
                    line.Transparency = 1
                    line.Visible = false
                    mySkeletonLines[i] = line
                end
            end

            for i = #boneList + 1, #mySkeletonLines do
                mySkeletonLines[i].Visible = false
            end

            for i, bonePair in ipairs(boneList) do
                local partA = myChar:FindFirstChild(bonePair[1])
                local partB = myChar:FindFirstChild(bonePair[2])
                local line = mySkeletonLines[i]

                if partA and partB then
                    local posA, visA = Camera:WorldToViewportPoint(partA.Position)
                    local posB, visB = Camera:WorldToViewportPoint(partB.Position)

                    if visA or visB then
                        line.From = Vector2_new(posA.X, posA.Y)
                        line.To = Vector2_new(posB.X, posB.Y)
                        line.Color = skelColor
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        else
            for _, line in pairs(mySkeletonLines) do line.Visible = false end
        end
    else
        for _, line in pairs(mySkeletonLines) do line.Visible = false end
    end

    -- 2. TRACERS FOR OTHER PLAYERS & GUN
    if myRoot then
        local viewportSize = Camera.ViewportSize
        local tracerOrigin = getTracerOriginPoint(viewportSize, Config.TracerPosition)
        
        local allPlayers = playersGetPlayers(Players)
        for i = 1, #allPlayers do
            local player = allPlayers[i]
            if player ~= LocalPlayer then
                local line = playerTracers[player]
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                
                if Config.Tracer and root then
                    local distance = (myRoot.Position - root.Position).Magnitude
                    if distance <= Config.MaxDistance then
                        local color, currentStatus = getPlayerColorAndStatus(player)
                        if Config.TracerRoles[currentStatus] == true then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                            if onScreen then
                                if not line then line = getTracerLine(player) end
                                line.From = tracerOrigin
                                line.To = Vector2_new(screenPos.X, screenPos.Y)
                                line.Color = color
                                line.Visible = true
                            elseif line then
                                line.Visible = false
                            end
                        elseif line then
                            line.Visible = false
                        end
                    elseif line then
                        line.Visible = false
                    end
                elseif line then
                    line.Visible = false
                end
            end
        end

        if Config.GunTracer and currentGunDrop and currentGunDrop:IsDescendantOf(Workspace) and currentGunDrop:IsA("BasePart") then
            local distance = (myRoot.Position - currentGunDrop.Position).Magnitude
            local screenPos, onScreen = Camera:WorldToViewportPoint(currentGunDrop.Position)
            
            if onScreen and distance <= Config.MaxDistance then
                local gunColor = getRoleColor("GunDrop", DefaultColors.GunDrop)
                GunDrawingLine.From = tracerOrigin
                GunDrawingLine.To = Vector2_new(screenPos.X, screenPos.Y)
                GunDrawingLine.Color = gunColor
                GunDrawingLine.Visible = true
            else
                GunDrawingLine.Visible = false
            end
        else
            GunDrawingLine.Visible = false
        end
    else
        for _, line in pairs(playerTracers) do line.Visible = false end
        GunDrawingLine.Visible = false
    end
end)

CoreGui.ChildRemoved:Connect(function(child)
    if child.Name == "KillerHub" then 
        GunDrawingLine:Remove()
        for _, line in pairs(playerTracers) do
            pcall(function() line:Remove() end)
        end
        table.clear(playerTracers)
        clearMySkeleton()
    end
end)


-- ============================================================================
-- 👾 KILLER HUB | ENGINE V12.0 - SHERIFF SUITE (ADVANCED PREDICTION ENGINE)
-- ============================================================================

if getgenv().__KillerHubSheriff_Loaded then
    KillerHub:NotifyWarn("Already Loaded", "Sheriff script is already running.", 4)
    return
end
getgenv().__KillerHubSheriff_Loaded = true

local function Flag(name, default)
    local f = KillerHub.Flags[name]
    if f == nil or f.CurrentValue == nil then return default end
    return f.CurrentValue
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService") 
local Stats = game:GetService("Stats") 
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera

local math_clamp = math.clamp
local math_abs = math.abs
local math_pow = math.pow
local math_min = math.min
local math_floor = math.floor
local vec2New = Vector2.new
local vec3New = Vector3.new
local udim2New = UDim2.new
local cframeNew = CFrame.new
local color3RGB = Color3.fromRGB
local os_clock = os.clock

local workspace_Gravity = workspace.Gravity
local VECTOR_ZERO = vec3New(0, 0, 0)
local PREDICTION_BOOST = 1.10

if _G.KillerHubLines then
    for _, line in pairs(_G.KillerHubLines) do pcall(function() line:Remove() end) end
end
_G.KillerHubLines = {}

local oldGui = game:GetService("CoreGui"):FindFirstChild("KillerHub_SheriffGui")
if oldGui then oldGui:Destroy() end

-- Real-time Ping Reader
local cachedPingValue = 0.05
local pingTask = task.spawn(function()
    while task.wait(0.2) do
        local currentPing = nil
        pcall(function()
            if Stats and Stats.Network and Stats.Network:FindFirstChild("ServerStatsItem") then
                local dataPing = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
                if dataPing then currentPing = dataPing:GetValue() / 1000 end
            end
        end)

        if not currentPing or currentPing <= 0 then
            pcall(function()
                if LocalPlayer and LocalPlayer.GetNetworkPing then
                    currentPing = LocalPlayer:GetNetworkPing()
                end
            end)
        end

        if currentPing and currentPing > 0 then cachedPingValue = currentPing end
    end
end)
KillerHub:AddTask(pingTask)

-- UI Setup
local TabSheriff = KillerHub:CreateTab("Sheriff", "rbxassetid://15286655815")

TabSheriff:CreateSection("Silent Aim")
TabSheriff:CreateToggle("Sheriff_SilentAim", "Silent Aim", function() end)
TabSheriff:CreateDropdown("Sheriff_ShotType", "Shot Type", {"Normal", "Piercer Bullet"}, function() end)
TabSheriff:CreateKeybind("Sheriff_ShootKey", "Shoot Key", Enum.KeyCode.F, function() end)
TabSheriff:CreateToggle("Sheriff_JumpPred", "Jump Prediction", function() end)
TabSheriff:CreateToggle("Sheriff_WallCheck", "Wall Check", function() end)

TabSheriff:CreateSection("Prediction")
TabSheriff:CreateSlider("Sheriff_HScale", "Horizontal Prediction", 0, 300, function() end)
TabSheriff:CreateSlider("Sheriff_VScale", "Vertical Prediction", 0, 300, function() end)

local sliderPing = TabSheriff:CreateSlider("Sheriff_PingComp", "Ping Compensation", 0, 300, function() end)

local pingLoopThread
TabSheriff:CreateToggle("Sheriff_PrioritizePing", "Prioritize Ping", function(estado)
    if pingLoopThread then task.cancel(pingLoopThread) pingLoopThread = nil end
    if estado then
        pingLoopThread = task.spawn(function()
            while Flag("Sheriff_PrioritizePing", false) do
                local currentMS = math_floor(cachedPingValue * 1000)
                if sliderPing and sliderPing.Set then sliderPing:Set(currentMS) end
                task.wait(0.3)
            end
        end)
    end
end)

TabSheriff:CreateSlider("Sheriff_CloseRange", "Close Range Zone", 0, 20, function() end)

TabSheriff:CreateSection("Visuals")
TabSheriff:CreateMultiDropdown("Sheriff_Tracers", "Tracers", {"Tracer Prediction", "Min Tracer Prediction", "Lead Time"}, function() end)

local cachedShootButton, cachedScreenGui
TabSheriff:CreateSlider("Sheriff_BtnSize", "Button Size", 50, 200, function(val)
    if cachedShootButton then cachedShootButton.Size = udim2New(0, val, 0, val) end
end)

TabSheriff:CreateSection("Stabilizers")
TabSheriff:CreateToggle("Sheriff_InertialStab", "Inertial Stabilizer", function() end)

local checkWeaponVisibility
TabSheriff:CreateSection("Interface")
TabSheriff:CreateToggle("Sheriff_WeaponDetect", "Weapon Detector", function() if checkWeaponVisibility then checkWeaponVisibility() end end)
TabSheriff:CreateToggle("Sheriff_ShowButton", "Show Button", function() if checkWeaponVisibility then checkWeaponVisibility() end end)
TabSheriff:CreateToggle("Sheriff_LockBtnPos", "Lock Button Position", function() end)

local PageOthers = TabSheriff:CreatePage("Others", "Gear")
PageOthers:CreateSection("Auto Shoot")
PageOthers:CreateToggle("Sheriff_AutoShoot", "Auto shoot", function() end)
PageOthers:CreateDropdown("Sheriff_AutoShootType", "Type Auto shoot", {"Murder visible", "Knife visible"}, function() end)

-- Weapon & Role Systems
local function isRangedWeapon(tool)
    if not tool or not tool:IsA("Tool") then return false end
    return (tool:FindFirstChild("Shoot") or tool.Name == "Gun" or tool.Name == "Revolver")
end

local function isMeleeWeapon(tool)
    if not tool or not tool:IsA("Tool") then return false end
    return (tool:FindFirstChild("Stab") or tool.Name == "Knife")
end

checkWeaponVisibility = function()
    if not cachedScreenGui then return end
    local showBtn = Flag("Sheriff_ShowButton", false)
    local useDetect = Flag("Sheriff_WeaponDetect", false)
    
    if not showBtn then cachedScreenGui.Enabled = false return end

    if useDetect then
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local hasGun = false
        if char then
            for _, item in pairs(char:GetChildren()) do if isRangedWeapon(item) then hasGun = true break end end
        end
        if not hasGun and backpack then
            for _, item in pairs(backpack:GetChildren()) do if isRangedWeapon(item) then hasGun = true break end end
        end
        cachedScreenGui.Enabled = hasGun
    else
        cachedScreenGui.Enabled = true
    end
end

local visTask = task.spawn(function()
    while task.wait(0.3) do pcall(checkWeaponVisibility) end
end)
KillerHub:AddTask(visTask)

local MurdererDetectado = nil
local smoothedVelocity = VECTOR_ZERO
local lastTargetChar = nil
local emaDeltaTime = 0.016 
local playerRoles = {}
local playerDeadStatus = {}
local currentTarget = nil
local lastPositions = {} 
local handLineIsBlocked = false 
local lastScanTime = 0

local function setTarget(nt) currentTarget = nt end
local function parsePlayerData(t)
    if type(t) == "table" then
        for name, data in pairs(t) do
            if type(data) == "table" then
                if data.Role then playerRoles[name] = data.Role end
                if data.Dead ~= nil then playerDeadStatus[name] = data.Dead end
            end
        end
    end
end

local PlayerDataChanged = ReplicatedStorage:FindFirstChild("PlayerDataChanged", true)
if PlayerDataChanged and PlayerDataChanged:IsA("RemoteEvent") then 
    KillerHub:AddTask(PlayerDataChanged.OnClientEvent:Connect(parsePlayerData)) 
end

local RoundStart = ReplicatedStorage:FindFirstChild("RoundStart", true)
if RoundStart and RoundStart:IsA("RemoteEvent") then
    KillerHub:AddTask(RoundStart.OnClientEvent:Connect(function(a1, a2)
        table.clear(playerRoles) 
        table.clear(playerDeadStatus) 
        table.clear(lastPositions)
        MurdererDetectado = nil 
        parsePlayerData(a2) 
        parsePlayerData(a1)
    end))
end

local floorCastParams = RaycastParams.new()
floorCastParams.FilterType = Enum.RaycastFilterType.Exclude

local function autoEquipWeapon()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if character and character:FindFirstChild("Humanoid") and backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if isRangedWeapon(item) then 
                character.Humanoid:EquipTool(item) 
                break 
            end
        end
    end
end

local function getGunLocation()
    local char = LocalPlayer.Character
    if char then for _, item in pairs(char:GetChildren()) do if isRangedWeapon(item) then return item, char end end end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then for _, item in pairs(bp:GetChildren()) do if isRangedWeapon(item) then return item, bp end end end
    return nil, nil
end

local function getMurderer()
    if MurdererDetectado and MurdererDetectado.Parent and MurdererDetectado.Character then
        local name = MurdererDetectado.Name
        local char = MurdererDetectado.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not ((hum and hum.Health <= 0) or (playerDeadStatus[name] == true)) and (playerRoles[name] == "Murderer") then
            setTarget(MurdererDetectado) 
            return MurdererDetectado
        else 
            MurdererDetectado = nil 
        end
    end

    for name, role in pairs(playerRoles) do
        if role == "Murderer" then
            local pl = Players:FindFirstChild(name)
            if pl and pl.Character and pl ~= LocalPlayer then
                local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                if not ((hum and hum.Health <= 0) or (playerDeadStatus[name] == true)) then
                    MurdererDetectado = pl 
                    setTarget(pl) 
                    return pl
                end
            end
        end
    end

    local now = os_clock()
    if now - lastScanTime > 0.4 then
        lastScanTime = now
        local potentialMurderer = nil
        local allPlayers = Players:GetPlayers()
        for i = 1, #allPlayers do
            local player = allPlayers[i]
            if player ~= LocalPlayer and player.Parent ~= nil and player.Character then
                local name = player.Name
                local char = player.Character
                local hasKnife = false
                for _, item in pairs(char:GetChildren()) do if isMeleeWeapon(item) then hasKnife = true break end end
                if not hasKnife and player:FindFirstChild("Backpack") then
                    for _, item in pairs(player.Backpack:GetChildren()) do if isMeleeWeapon(item) then hasKnife = true break end end
                end
                if hasKnife then
                    playerRoles[name] = "Murderer"
                    if not ((char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health <= 0) or (playerDeadStatus[name] == true)) then
                        potentialMurderer = player 
                        break
                    end
                end
            end
        end
        if potentialMurderer then MurdererDetectado = potentialMurderer else setTarget(nil) end
    end

    return currentTarget
end

-- Raycasting & Line of Sight Checks
local mapCastParams = RaycastParams.new()
mapCastParams.FilterType = Enum.RaycastFilterType.Exclude

local cachedIgnoreList = {}
local function updateIgnoreListCache()
    table.clear(cachedIgnoreList)
    if LocalPlayer.Character then table.insert(cachedIgnoreList, LocalPlayer.Character) end
    table.insert(cachedIgnoreList, Camera)
    local allPlayers = Players:GetPlayers()
    for i = 1, #allPlayers do 
        local pChar = allPlayers[i].Character
        if pChar then table.insert(cachedIgnoreList, pChar) end 
    end
end

KillerHub:AddTask(Players.PlayerAdded:Connect(updateIgnoreListCache))
KillerHub:AddTask(Players.PlayerRemoving:Connect(updateIgnoreListCache))
KillerHub:AddTask(LocalPlayer.CharacterAdded:Connect(updateIgnoreListCache))
updateIgnoreListCache()

local function isStrictlyVisible(targetChar, targetPart)
    if not targetChar or not targetPart then return false end
    local origin = Camera.CFrame.Position
    local targetPos = targetPart.Position
    local direction = targetPos - origin
    
    local tempIgnore = table.clone(cachedIgnoreList)
    local currentOrigin = origin
    local rayPasses = 0

    while direction.Magnitude > 0.1 and rayPasses < 4 do
        rayPasses = rayPasses + 1
        mapCastParams.FilterDescendantsInstances = tempIgnore
        local ray = workspace:Raycast(currentOrigin, direction, mapCastParams)
        if not ray then return true end

        local hitInst = ray.Instance
        if hitInst and hitInst:IsDescendantOf(targetChar) then
            return true
        end

        if hitInst and hitInst.CanCollide and hitInst.Transparency < 0.8 then
            return false
        else
            table.insert(tempIgnore, hitInst)
            currentOrigin = ray.Position + (direction.Unit * 0.05)
            direction = targetPos - currentOrigin
        end
    end

    return true
end

local function getSmartTargetPart(targetChar)
    if not targetChar then return nil, true end
    local hrp = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
    if not hrp then return nil, true end
    
    local wallCheck = Flag("Sheriff_WallCheck", true)
    local shotType = Flag("Sheriff_ShotType", "Normal")

    if not wallCheck or shotType == "Piercer Bullet" then 
        return hrp, false 
    end
    
    local origin = Camera.CFrame.Position
    local ignoreListTemp = table.clone(cachedIgnoreList)

    local partsToScan = {
        hrp,
        targetChar:FindFirstChild("Head"),
        targetChar:FindFirstChild("LeftHand") or targetChar:FindFirstChild("Left Arm"),
        targetChar:FindFirstChild("RightHand") or targetChar:FindFirstChild("Right Arm")
    }
    
    for i = 1, #partsToScan do
        local part = partsToScan[i]
        if part then
            local targetPos = part.Position
            local currentOrigin = origin
            local direction = targetPos - currentOrigin
            local blocked = false
            local rayPasses = 0

            while direction.Magnitude > 0.1 and rayPasses < 5 do
                rayPasses = rayPasses + 1
                mapCastParams.FilterDescendantsInstances = ignoreListTemp
                local ray = workspace:Raycast(currentOrigin, direction, mapCastParams)
                if not ray then break end

                local hitInst = ray.Instance
                if hitInst and hitInst.CanCollide and hitInst.Transparency < 0.8 then
                    blocked = true
                    break 
                else
                    table.insert(ignoreListTemp, hitInst)
                    currentOrigin = ray.Position + (direction.Unit * 0.05)
                    direction = targetPos - currentOrigin
                end
            end

            if not blocked then return part, false end
        end
    end
    return hrp, true
end

local function getFloorHeight(targetHrp, targetChar)
    if not targetHrp then return nil end
    floorCastParams.FilterDescendantsInstances = {targetChar, LocalPlayer.Character, Camera}
    local ray = workspace:Raycast(targetHrp.Position, vec3New(0, -25, 0), floorCastParams)
    return ray and ray.Position.Y or nil
end

-- Advanced Adaptive Prediction Engine (Anti-Juke, Anti-Jitter & Advanced Jump Math)
local function getPredictedPosition(targetChar, targetPart, customDelta)
    if not targetChar or not targetPart then return nil, nil, nil end
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
    local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not humanoid or humanoid.Health <= 0 or not localHrp then return nil, nil, nil end

    local activeDT = customDelta or emaDeltaTime
    local targetPosition = targetPart.Position
    local distance = (targetPosition - localHrp.Position).Magnitude

    local moveMag = humanoid.MoveDirection.Magnitude
    local rawPhysicsVel = hrp.AssemblyLinearVelocity
    local walkSpeed = humanoid.WalkSpeed > 0 and humanoid.WalkSpeed or 16
    
    local intendedVel = vec3New(humanoid.MoveDirection.X * walkSpeed, 0, humanoid.MoveDirection.Z * walkSpeed)
    local actualPhysicsH = vec3New(rawPhysicsVel.X, 0, rawPhysicsVel.Z)
    local rawVelocity = actualPhysicsH:Lerp(intendedVel, math_clamp(moveMag, 0, 1))

    local calculatedVelY = rawPhysicsVel.Y
    local lastData = lastPositions[targetChar]
    local now = os_clock()
    if not lastData then
        lastData = {Pos = hrp.Position, Time = now}
        lastPositions[targetChar] = lastData
    else
        local dtPrev = now - lastData.Time
        if dtPrev > 0.008 then
            local realYVel = (hrp.Position.Y - lastData.Pos.Y) / dtPrev
            if math_abs(realYVel) > 0.5 then calculatedVelY = realYVel end
        end
        lastData.Pos = hrp.Position
        lastData.Time = now
    end

    local closeZone = Flag("Sheriff_CloseRange", 6)
    local predictionWeight = distance <= closeZone and 0 or 1

    if lastTargetChar ~= targetChar then
        smoothedVelocity = rawVelocity 
        lastTargetChar = targetChar
    end

    local isStopping = (moveMag < 0.1 and rawVelocity.Magnitude < 2)
    local isStarting = (moveMag > 0.1 and smoothedVelocity.Magnitude < 2)

    local vSmoothAlpha = 0.35
    if isStopping then vSmoothAlpha = 0.80
    elseif isStarting then vSmoothAlpha = 0.20
    elseif Flag("Sheriff_InertialStab", true) then vSmoothAlpha = math_clamp(14 * activeDT, 0.18, 0.50) end

    -- 1. Anti-Juke & Anti-Zigzag Logic
    local currentVelH = vec3New(rawPhysicsVel.X, 0, rawPhysicsVel.Z)
    local prevVelH = vec3New(smoothedVelocity.X, 0, smoothedVelocity.Z)
    if currentVelH.Magnitude > 2 and prevVelH.Magnitude > 2 then
        local dotProduct = currentVelH.Unit:Dot(prevVelH.Unit)
        if dotProduct < 0.3 then
            vSmoothAlpha = 0.85
            predictionWeight = predictionWeight * 0.5
        end
    end

    -- 2. Anti-Jitter / Anti-Troll Filter (Presionar A/D rápido sin avanzar)
    local isJittering = (moveMag > 0.1 and actualPhysicsH.Magnitude < 3.5)
    if isJittering then
        predictionWeight = predictionWeight * 0.25
    end

    smoothedVelocity = smoothedVelocity:Lerp(rawVelocity, vSmoothAlpha)
    if isStopping and smoothedVelocity.Magnitude < 0.3 then smoothedVelocity = VECTOR_ZERO end

    local horizontalShift = VECTOR_ZERO
    local verticalShift = VECTOR_ZERO

    local prioritizePing = Flag("Sheriff_PrioritizePing", false)
    local vScale = Flag("Sheriff_VScale", 100)
    local hScale = Flag("Sheriff_HScale", 100)
    local shotType = Flag("Sheriff_ShotType", "Normal")

    local timeToTarget = (distance / 320)
    local totalLatency = cachedPingValue + timeToTarget

    local effectiveHLatency = 0
    local effectiveVLatency = 0

    if prioritizePing then
        local rawMS = totalLatency * 1000
        local autoScale = 90 + (rawMS * 0.5)
        autoScale = math_min(autoScale, 170)

        effectiveHLatency = (autoScale / 1000) * PREDICTION_BOOST
        local autoVScale = math_min(autoScale, 80)
        effectiveVLatency = (autoVScale / 1000) * PREDICTION_BOOST
    else
        effectiveHLatency = (hScale / 1000) * PREDICTION_BOOST
        local cappedVScale = math_min(vScale, 80)
        effectiveVLatency = (cappedVScale / 1000) * PREDICTION_BOOST
    end

    if shotType == "Piercer Bullet" then
        if hScale == 0 then
            effectiveHLatency = (28 / 1000) * PREDICTION_BOOST
            horizontalShift = vec3New(smoothedVelocity.X, 0, smoothedVelocity.Z) * effectiveHLatency * predictionWeight
        elseif hScale > 100 then
            horizontalShift = vec3New(smoothedVelocity.X, 0, smoothedVelocity.Z) * effectiveHLatency * predictionWeight * 0.90
        else
            horizontalShift = vec3New(smoothedVelocity.X, 0, smoothedVelocity.Z) * effectiveHLatency * predictionWeight * 0.33
        end
    else
        horizontalShift = vec3New(smoothedVelocity.X, 0, smoothedVelocity.Z) * effectiveHLatency * predictionWeight
    end

    -- 3. Advanced Jump & Gravity Physics (Anti Spam Jump)
    if vScale > 0 then
        local isAir = (humanoid.FloorMaterial == Enum.Material.Air)
        local isStairMovement = (not isAir and math_abs(calculatedVelY) > 0.8)

        if isAir or isStairMovement then
            local adaptiveYFactor = math_clamp((distance - closeZone) / 12, 0, 1)
            local vFactor = effectiveVLatency * adaptiveYFactor

            if isAir then
                local g = workspace_Gravity
                local predictedY = (calculatedVelY * vFactor) - (0.5 * g * math_pow(vFactor, 2))
                verticalShift = vec3New(0, predictedY, 0)
            elseif isStairMovement then
                local pY = calculatedVelY * vFactor
                verticalShift = vec3New(0, pY, 0)
            end
        end
    end

    if horizontalShift.Magnitude > 8.5 then horizontalShift = horizontalShift.Unit * 8.5 end
    if verticalShift.Magnitude > 6.0 then verticalShift = verticalShift.Unit * 6.0 end

    local finalPredNoY = vec3New(targetPosition.X + horizontalShift.X, targetPosition.Y, targetPosition.Z + horizontalShift.Z)
    local minPredNoY = vec3New(targetPosition.X + (horizontalShift.X * 0.4), targetPosition.Y, targetPosition.Z + (horizontalShift.Z * 0.4))

    local finalPredWithY = targetPosition + horizontalShift + verticalShift
    local floorY = getFloorHeight(hrp, targetChar)
    if floorY then
        local minAllowedY = floorY + (hrp.Size.Y / 2) + 0.1
        if finalPredWithY.Y < minAllowedY then finalPredWithY = vec3New(finalPredWithY.X, minAllowedY, finalPredWithY.Z) end
    end

    return finalPredWithY, finalPredNoY, minPredNoY
end

-- Tracers Render
local MinPredictionLine = Drawing.new("Line")
MinPredictionLine.Color = color3RGB(4, 0, 220); MinPredictionLine.Thickness = 2.0; MinPredictionLine.Transparency = 1.0; MinPredictionLine.ZIndex = 5

local PredictionLine = Drawing.new("Line")
PredictionLine.Color = color3RGB(255, 35, 35); PredictionLine.Thickness = 2.0; PredictionLine.Transparency = 1.0; PredictionLine.ZIndex = 10

-- Lead Time siempre configurado a Verde
local LeadTimeLine = Drawing.new("Line")
LeadTimeLine.Color = color3RGB(35, 255, 35); LeadTimeLine.Thickness = 1.8; LeadTimeLine.Transparency = 1.0; LeadTimeLine.ZIndex = 7

table.insert(_G.KillerHubLines, MinPredictionLine)
table.insert(_G.KillerHubLines, PredictionLine)
table.insert(_G.KillerHubLines, LeadTimeLine)

local worldToViewport = Camera.WorldToViewportPoint

local renderConn = RunService.RenderStepped:Connect(function(dt)
    emaDeltaTime = emaDeltaTime + 0.2 * (dt - emaDeltaTime) 

    local murderer = getMurderer()
    if not murderer or not murderer.Character then
        PredictionLine.Visible = false; MinPredictionLine.Visible = false; LeadTimeLine.Visible = false;
        return
    end

    local targetChar = murderer.Character
    local visualPart, isBlocked = getSmartTargetPart(targetChar) 
    handLineIsBlocked = isBlocked

    local myChar = LocalPlayer.Character
    local rightHand = myChar and (myChar:FindFirstChild("RightHand") or myChar:FindFirstChild("Right Arm"))

    local tracersTable = Flag("Sheriff_Tracers", {})
    local showRed = tracersTable["Tracer Prediction"] == true
    local showBlue = tracersTable["Min Tracer Prediction"] == true
    local showGreen = tracersTable["Lead Time"] == true

    if visualPart then
        local _, predNoY, minPredNoY = getPredictedPosition(targetChar, visualPart, dt)
        local currentViewportSize = Camera.ViewportSize
        local screenOrigin = vec2New(currentViewportSize.X / 2, currentViewportSize.Y)

        if predNoY and minPredNoY then
            if showBlue then
                local screenPos, onScreen = worldToViewport(Camera, minPredNoY)
                if onScreen then
                    MinPredictionLine.From = screenOrigin 
                    MinPredictionLine.To = vec2New(screenPos.X, screenPos.Y) 
                    MinPredictionLine.Visible = true
                else MinPredictionLine.Visible = false end
            else MinPredictionLine.Visible = false end

            if showRed then
                local screenPos, onScreen = worldToViewport(Camera, predNoY)
                if onScreen then
                    PredictionLine.From = screenOrigin 
                    PredictionLine.To = vec2New(screenPos.X, screenPos.Y) 
                    PredictionLine.Visible = true
                else PredictionLine.Visible = false end
            else PredictionLine.Visible = false end

            if rightHand and showGreen then
                local handScreenPos, handOnScreen = worldToViewport(Camera, rightHand.Position)
                local predScreenPos, predOnScreen = worldToViewport(Camera, predNoY)

                if handOnScreen and predOnScreen then
                    -- Modificado: Mantener SIEMPRE el color verde original
                    LeadTimeLine.Color = color3RGB(35, 255, 35)
                    LeadTimeLine.From = vec2New(handScreenPos.X, handScreenPos.Y)
                    LeadTimeLine.To = vec2New(predScreenPos.X, predScreenPos.Y)
                    LeadTimeLine.Visible = true
                else LeadTimeLine.Visible = false end
            else LeadTimeLine.Visible = false end
        end
    else
        PredictionLine.Visible = false; MinPredictionLine.Visible = false; LeadTimeLine.Visible = false;
    end 
end)
KillerHub:AddTask(renderConn)

-- Fire Execution
local function fireAtMurdererDirectly()
    local shotType = Flag("Sheriff_ShotType", "Normal")
    if handLineIsBlocked and shotType ~= "Piercer Bullet" then return end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end 

    local murderer = getMurderer()
    if murderer and murderer.Character then
        local targetChar = murderer.Character
        local bestPart, isBlocked = getSmartTargetPart(targetChar) 
        if bestPart and (not isBlocked or shotType == "Piercer Bullet") then 
            local finalPredictedPos = getPredictedPosition(targetChar, bestPart)
            if finalPredictedPos then
                autoEquipWeapon()
                local gun, _ = getGunLocation()
                if gun and gun:FindFirstChild("Shoot") then
                    local originCFrame = char.HumanoidRootPart.CFrame
                    if char.HumanoidRootPart:FindFirstChild("GunRaycastAttachment") then 
                        originCFrame = char.HumanoidRootPart.GunRaycastAttachment.WorldCFrame 
                    end

                    if shotType == "Piercer Bullet" then
                        local dir = (finalPredictedPos - char.HumanoidRootPart.Position).Unit
                        originCFrame = cframeNew(finalPredictedPos - (dir * 1.3), finalPredictedPos)
                    end

                    gun.Shoot:FireServer(originCFrame, cframeNew(finalPredictedPos))
                end
            end
        end
    end
end

-- Auto Shoot Engine (Strict Obstruction Safety)
local lastAutoShootTime = 0
local autoShootConn = RunService.RenderStepped:Connect(function()
    if not Flag("Sheriff_AutoShoot", false) then return end
    
    local now = os_clock()
    if now - lastAutoShootTime < 0.18 then return end

    local murderer = getMurderer()
    if not murderer or not murderer.Character then return end
    local targetChar = murderer.Character

    local autoType = Flag("Sheriff_AutoShootType", "Murder visible")
    if autoType == "Knife visible" then
        local knifeEquipped = false
        for _, item in pairs(targetChar:GetChildren()) do
            if isMeleeWeapon(item) then knifeEquipped = true break end
        end
        if not knifeEquipped then return end
    end

    local bestPart, _ = getSmartTargetPart(targetChar)
    if bestPart and isStrictlyVisible(targetChar, bestPart) then
        lastAutoShootTime = now
        fireAtMurdererDirectly()
    end
end)
KillerHub:AddTask(autoShootConn)

-- Keybinds & Mobile GUI
local function safeGetEnum(enumType, name)
    local ok, result = pcall(function() return enumType[name] end)
    return ok and result or nil
end

local inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local targetKeyName = Flag("Sheriff_ShootKey", "F")
    local kc = safeGetEnum(Enum.KeyCode, targetKeyName)
    local uit = safeGetEnum(Enum.UserInputType, targetKeyName)
    if (kc and input.KeyCode == kc) or (uit and input.UserInputType == uit) then
        task.spawn(fireAtMurdererDirectly)
    end
end)
KillerHub:AddTask(inputConn)

local POS_FILE = "KillerHub_ButtonPos.txt"
local function loadButtonPosition()
    if isfile and readfile and isfile(POS_FILE) then
        local ok, result = pcall(function() return HttpService:JSONDecode(readfile(POS_FILE)) end)
        if ok and type(result) == "table" and result.X and result.Y then
            return udim2New(result.X, 0, result.Y, 0)
        end
    end
    if getgenv().__KillerHub_ButtonPos then return getgenv().__KillerHub_ButtonPos end
    return udim2New(0.7, 0, 0.6, 0)
end

local function saveButtonPosition(pos)
    getgenv().__KillerHub_ButtonPos = pos
    if writefile then
        pcall(function() writefile(POS_FILE, HttpService:JSONEncode({X = pos.X.Scale, Y = pos.Y.Scale})) end)
    end
end

local VoidGui = Instance.new("ScreenGui")
VoidGui.Name = "KillerHub_SheriffGui"; VoidGui.ResetOnSpawn = false; VoidGui.Parent = game:GetService("CoreGui")
KillerHub:AddTask(VoidGui)

local btnSize = Flag("Sheriff_BtnSize", 95)
local ShootButton = Instance.new("ImageButton")
ShootButton.Name = "ShootButton"
ShootButton.Size = udim2New(0, btnSize, 0, btnSize)
ShootButton.Position = loadButtonPosition()
ShootButton.BackgroundColor3 = color3RGB(15, 6, 26); ShootButton.BackgroundTransparency = 0.05
ShootButton.BorderSizePixel = 0; ShootButton.AutoButtonColor = false; ShootButton.ClipsDescendants = true; ShootButton.Parent = VoidGui

cachedScreenGui = VoidGui
cachedShootButton = ShootButton

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.28, 0); Corner.Parent = ShootButton

local GlowOverlay = Instance.new("Frame")
GlowOverlay.Size = udim2New(1, 0, 1, 0); GlowOverlay.BackgroundTransparency = 1; GlowOverlay.ZIndex = ShootButton.ZIndex + 1; GlowOverlay.Parent = ShootButton

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0.28, 0); GlowCorner.Parent = GlowOverlay

local UiGradient = Instance.new("UIGradient")
UiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, color3RGB(24, 8, 43)), 
    ColorSequenceKeypoint.new(0.5, color3RGB(131, 46, 222)), 
    ColorSequenceKeypoint.new(1, color3RGB(24, 8, 43))
})
UiGradient.Offset = vec2New(0, 0); UiGradient.Rotation = 0; UiGradient.Parent = GlowOverlay

local rotTask = task.spawn(function()
    while VoidGui.Parent do
        local tweenRot = TweenService:Create(UiGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = UiGradient.Rotation + 360})
        tweenRot:Play()
        tweenRot.Completed:Wait()
    end
end)
KillerHub:AddTask(rotTask)

local DecalTexture = Instance.new("ImageLabel")
DecalTexture.Size = udim2New(0.37, 0, 0.37, 0); DecalTexture.AnchorPoint = vec2New(0.5, 0.5); DecalTexture.Position = udim2New(0.5, 0, 0.44, 0)
DecalTexture.BackgroundTransparency = 1; DecalTexture.Image = "rbxassetid://125754446555599"
DecalTexture.ZIndex = ShootButton.ZIndex + 2; DecalTexture.Parent = ShootButton

local tiLoop = TweenInfo.new(0.80, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local rotAnim = TweenService:Create(DecalTexture, tiLoop, {Rotation = 360})
rotAnim:Play()
KillerHub:AddTask(rotAnim)

local Label = Instance.new("TextLabel")
Label.Size = udim2New(1, 0, 0.2, 0); Label.Position = udim2New(0, 0, 0.75, 0); Label.BackgroundTransparency = 1
Label.Text = "SHOOT"; Label.TextColor3 = color3RGB(255, 255, 255); Label.TextSize = 15; Label.Font = Enum.Font.GothamBold
Label.ZIndex = ShootButton.ZIndex + 2; Label.Parent = ShootButton

local dragging, dragInput, dragStart, startPos
KillerHub:AddTask(ShootButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        TweenService:Create(GlowOverlay, TweenInfo.new(0.01, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.02}):Play()
        task.spawn(fireAtMurdererDirectly)
        
        if not Flag("Sheriff_LockBtnPos", false) then
            dragging = true; dragStart = input.Position; startPos = ShootButton.Position
            local cChanged
            cChanged = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false 
                    cChanged:Disconnect()
                    saveButtonPosition(ShootButton.Position)
                end
            end)
        end
     end
end))

KillerHub:AddTask(ShootButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        TweenService:Create(GlowOverlay, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        if dragging then dragging = false; saveButtonPosition(ShootButton.Position) end
    end
end))

KillerHub:AddTask(ShootButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end))

KillerHub:AddTask(UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging and not Flag("Sheriff_LockBtnPos", false) then
        local delta = input.Position - dragStart
        ShootButton.Position = udim2New(startPos.X.Scale + (delta.X / Camera.ViewportSize.X), 0, startPos.Y.Scale + (delta.Y / Camera.ViewportSize.Y), 0)
    end
end))

-- Silent Aim Hooks
local WeaponService = nil
local ClientServices = ReplicatedStorage:FindFirstChild("ClientServices") or ReplicatedStorage:FindFirstChild("Services")
if ClientServices then
    local ws = ClientServices:FindFirstChild("WeaponService") or ClientServices:FindFirstChild("GunService")
    if ws and ws:IsA("ModuleScript") then pcall(function() WeaponService = require(ws) end) end
end
if not WeaponService then
    local descendants = ReplicatedStorage:GetDescendants()
    for i = 1, #descendants do
        local obj = descendants[i]
        if obj:IsA("ModuleScript") then
            local success, mod = pcall(require, obj)
            if success and type(mod) == "table" and (mod.GetTargetPosition or mod.GetMouseTargetCFrame) then WeaponService = mod break end
        end
    end
end

if WeaponService then
    local oldGetTargetPosition = WeaponService.GetTargetPosition
    local oldGetMouseTargetCFrame = WeaponService.GetMouseTargetCFrame
    local lastHookCallTime = os_clock()
    local frameCachedTime = 0
    local frameCachedCF = nil

    local function getPredictedTargetCFrame(customDelta)
        local currentTime = os_clock()
        if currentTime == frameCachedTime then return frameCachedCF end

        local silentAim = Flag("Sheriff_SilentAim", false)
        if not silentAim then frameCachedTime = currentTime; frameCachedCF = nil; return nil end

        local shotType = Flag("Sheriff_ShotType", "Normal")
        local useDetect = Flag("Sheriff_WeaponDetect", false)

        local gun, _ = getGunLocation()
        if useDetect and not gun then frameCachedTime = currentTime; frameCachedCF = nil; return nil end

        local murderer = getMurderer()
        if not murderer or not murderer.Character then frameCachedTime = currentTime; frameCachedCF = nil; return nil end

        local bestPart, isBlocked = getSmartTargetPart(murderer.Character)
        if not bestPart or (isBlocked and shotType ~= "Piercer Bullet") then 
            frameCachedTime = currentTime; frameCachedCF = nil; return nil 
        end

        local dt = customDelta or math_clamp(currentTime - lastHookCallTime, 0.008, 0.033)
        lastHookCallTime = currentTime

        local finalPredictedPos = getPredictedPosition(murderer.Character, bestPart, dt)
        frameCachedCF = finalPredictedPos and cframeNew(finalPredictedPos) or nil
        frameCachedTime = currentTime
        return frameCachedCF
    end

    if oldGetTargetPosition then
        WeaponService.GetTargetPosition = function(self, ...)
            local targetCF = getPredictedTargetCFrame()
            return targetCF or oldGetTargetPosition(self, ...)
        end
    end

    if oldGetMouseTargetCFrame then
        WeaponService.GetMouseTargetCFrame = function(self, ...)
            local targetCF = getPredictedTargetCFrame()
            return targetCF or oldGetMouseTargetCFrame(self, ...)
        end
    end
end

return KillerHub
