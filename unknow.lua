-- ============================================================================
-- 👻 KILLER HUB - MM2 ADVANCED VISUAL SUITE (ULTRA-OPTIMIZED V3.3)
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

-- Localización/Cacheo para Máxima Optimización de FPS
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
local Instance_new = Instance.new
local UDim2_new = UDim2.new
local playersGetPlayers = Players.GetPlayers

-- Colores base del juego
local DefaultColors = {
    Murderer = Color3_fromRGB(180, 55, 55),
    Sheriff  = Color3_fromRGB(35, 102, 204),
    Hero     = Color3_fromRGB(230, 188, 62),
    Innocent = Color3_fromRGB(26, 171, 81),
    Dead     = Color3_fromRGB(115, 115, 115),
    GunDrop  = Color3_fromRGB(255, 0, 0)
}

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
    TracerRoles = {["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, ["Dead/None"] = false},

    LimbChams = false,
    LimbChamsTrans = 50,
    LimbChamsRoles = {["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, ["Dead/None"] = false},

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
                if type(v) == "table" then
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

-- [3] GRAPHICAL INTERFACE
local KillerHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/Paolo0109/KillerHUB/refs/heads/main/InterfazBase.lua"))()

-- VISUALS TAB
local VisualsTab = KillerHub:CreateTab("Visuals", "rbxassetid://6523858394")

VisualsTab:CreateSection("Player ESP")

-- Cuerpo Completo (Highlight)
local ToggleHighlight = VisualsTab:CreateToggleSlider("EspHighlight", "EspHighlightTrans", "Highlight ESP", 0, 100, 
    function(val) Config.Highlight = val; saveConfig() end,
    function(val) Config.HighlightTrans = math_floor(val); saveConfig() end
)
VisualsTab:CreateMultiDropdown("HighlightFilters", "Highlight Filters", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.HighlightRoles) do Config.HighlightRoles[r] = flags[r] == true end; saveConfig()
end)
local DropHighlight = KillerHub.Elements["HighlightFilters"]

-- Cham ESP
local ToggleLimbChams = VisualsTab:CreateToggleSlider("EspLimbChams", "EspLimbChamsTrans", "Cham ESP", 0, 100, 
    function(val) Config.LimbChams = val; saveConfig() end,
    function(val) Config.LimbChamsTrans = math_floor(val); saveConfig() end
)
VisualsTab:CreateMultiDropdown("LimbChamsFilters", "Cham ESP Filters", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.LimbChamsRoles) do Config.LimbChamsRoles[r] = flags[r] == true end; saveConfig()
end)
local DropLimbChams = KillerHub.Elements["LimbChamsFilters"]

-- Box 2D
local ToggleBox = VisualsTab:CreateToggle("EspBox", "ESP Box 2D", function(val) Config.Box = val; saveConfig() end)
VisualsTab:CreateMultiDropdown("BoxFilters", "Box Filters", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.BoxRoles) do Config.BoxRoles[r] = flags[r] == true end; saveConfig()
end)
local DropBox = KillerHub.Elements["BoxFilters"]

-- Nombres
local ToggleName = VisualsTab:CreateToggle("EspName", "ESP Name", function(val) Config.Name = val; saveConfig() end)
VisualsTab:CreateMultiDropdown("NameFilters", "Name Filters", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.NameRoles) do Config.NameRoles[r] = flags[r] == true end; saveConfig()
end)
local DropName = KillerHub.Elements["NameFilters"]

-- Tracers (Líneas)
local ToggleTracer = VisualsTab:CreateToggle("EspTracer", "ESP Tracer (Líneas)", function(val) Config.Tracer = val; saveConfig() end)
VisualsTab:CreateMultiDropdown("TracerFilters", "Tracer Filters", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.TracerRoles) do Config.TracerRoles[r] = flags[r] == true end; saveConfig()
end)
local DropTracer = KillerHub.Elements["TracerFilters"]

VisualsTab:CreateSection("Gun ESP")
local ToggleGunCham = VisualsTab:CreateToggle("EspGunCham", "ESP Gun", function(val) Config.GunCham = val; saveConfig() end)
local ToggleGunName = VisualsTab:CreateToggle("EspGunName", "ESP Gun Name", function(val) Config.GunName = val; saveConfig() end)
local ToggleGunTracer = VisualsTab:CreateToggle("EspGunTracer", "ESP Gun Tracer", function(val) Config.GunTracer = val; saveConfig() end)

VisualsTab:CreateSection("Role Colors")
local function createRoleColorPicker(roleKey, visualName)
    local defaultRGB = Config.CustomColorsRGB[roleKey]
    local defaultColor3 = Color3_fromRGB(defaultRGB[1], defaultRGB[2], defaultRGB[3])
    
    VisualsTab:CreateToggleColorPicker(
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

VisualsTab:CreateSection("Settings & Performance")
local DistanceInput = VisualsTab:CreateInput("EspMaxDistance", "Max Render Distance (Studs)", "400", function(val)
    local num = tonumber(val)
    if num then Config.MaxDistance = math_abs(num); saveConfig()
    else KillerHub:NotifyWarn("Valor Inválido", "Ingresa únicamente números para la distancia.", 3) end
end)
local NameSizeSlider = VisualsTab:CreateSlider("EspNameSize", "Name Size", 10, 30, function(val) Config.NameSize = math_floor(val); saveConfig() end)
local GunNameSizeSlider = VisualsTab:CreateSlider("EspGunNameSize", "Gun Name Size", 10, 30, function(val) Config.GunNameSize = math_floor(val); saveConfig() end)


-- [4] APPLY SAVED CONFIGURATIONS Safely
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
-- 🧠 CORE ENGINE (HYPER-OPTIMIZED WITH TRACERS)
-- ============================================================================

local playerRoles = {} 
local playerDeadStatus = {} 
local currentGunDrop = nil 

-- TRACER ENGINE (CACHE & RECYCLED DRAWINGS)
local GunDrawingLine = Drawing.new("Line")
GunDrawingLine.Thickness = 1
GunDrawingLine.Transparency = 1
GunDrawingLine.Visible = false

local playerTracers = {}

local function getTracerLine(player)
    if not playerTracers[player] then
        local line = Drawing.new("Line")
        line.Thickness = 1 -- Delgado para máximo FPS
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
    
    local humanoid = char and char:FindFirstChild("Humanoid")
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

local function clearPlayerESP(char)
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        local box = root:FindFirstChild("KH_2DBox")
        local nameTag = root:FindFirstChild("KH_Name")
        if box then box:Destroy() end
        if nameTag then nameTag:Destroy() end
    end
    
    local limbFolder = char:FindFirstChild("KH_LimbChams")
    if limbFolder then limbFolder:Destroy() end
    
    local hl = char:FindFirstChild("KH_Highlight")
    if hl then hl:Destroy() end
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

-- GROUND GUN ESP
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

-- REMOTE RETRIEVING (MM2 Logic Sync)
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
        for i = 1, #allPlayers do pcall(function() clearPlayerESP(allPlayers[i].Character) end) end
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
            pcall(updatePlayerESP, allPlayers[i])
        end
        pcall(updateGunESP)
        task.wait(0.1)
    end
end)

-- RENDER STEPPED (ULTRA-FAST 2D TRACERS ENGINE)
RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    if myRoot then
        local viewportSize = Camera.ViewportSize
        local screenBottom = Vector2_new(viewportSize.X / 2, viewportSize.Y)
        
        -- 1. JUGADORES TRACERS
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
                                line.From = screenBottom
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

        -- 2. ARMA TRACER
        if Config.GunTracer and currentGunDrop and currentGunDrop:IsDescendantOf(Workspace) and currentGunDrop:IsA("BasePart") then
            local distance = (myRoot.Position - currentGunDrop.Position).Magnitude
            local screenPos, onScreen = Camera:WorldToViewportPoint(currentGunDrop.Position)
            
            if onScreen and distance <= Config.MaxDistance then
                local gunColor = getRoleColor("GunDrop", DefaultColors.GunDrop)
                GunDrawingLine.From = screenBottom
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
        for _, line in pairs(playerTracers) do
            line.Visible = false
        end
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
    end
end)

-- ============================================================================
-- 👾 KILLER HUB | ENGINE V11.4 - SHERIFF SUITE (HYBRID STABILIZER & MINI AVATAR)
-- ============================================================================

-- Prevent double execution
if getgenv().__KillerHubSheriff_Loaded then
    KillerHub:NotifyWarn("Already Loaded", "Sheriff script is already running.", 4)
    return
end
getgenv().__KillerHubSheriff_Loaded = true

-- Flag reader helper
local function Flag(name, default)
    local f = KillerHub.Flags[name]
    if f == nil or f.CurrentValue == nil then return default end
    return f.CurrentValue
end

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService") 
local Stats = game:GetService("Stats") 
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera

-- Math & Constructor Optimizations
local math_clamp = math.clamp
local math_abs = math.abs
local math_pow = math.pow
local math_min = math.min
local vec2New = Vector2.new
local vec3New = Vector3.new
local udim2New = UDim2.new
local cframeNew = CFrame.new
local color3RGB = Color3.fromRGB
local os_clock = os.clock

local workspace_Gravity = workspace.Gravity
local VECTOR_ZERO = vec3New(0, 0, 0)
local PREDICTION_BOOST = 1.10 -- 10% Stronger Prediction Multiplier

-- Preventative cleanup
if _G.KillerHubLines then
    for _, line in pairs(_G.KillerHubLines) do pcall(function() line:Remove() end) end
end
_G.KillerHubLines = {}

local oldGui = game:GetService("CoreGui"):FindFirstChild("KillerHub_SheriffGui")
if oldGui then oldGui:Destroy() end

-- ============================================================================
-- REAL-TIME PING READER
-- ============================================================================
local cachedPingValue = 0.05

local pingTask = task.spawn(function()
    while task.wait(0.2) do
        local currentPing = nil
        pcall(function()
            if Stats and Stats.Network and Stats.Network:FindFirstChild("ServerStatsItem") then
                local dataPing = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
                if dataPing then
                    currentPing = dataPing:GetValue() / 1000
                end
            end
        end)

        if not currentPing or currentPing <= 0 then
            pcall(function()
                if LocalPlayer and LocalPlayer.GetNetworkPing then
                    currentPing = LocalPlayer:GetNetworkPing()
                end
            end)
        end

        if currentPing and currentPing > 0 then
            cachedPingValue = currentPing
        end
    end
end)
KillerHub:AddTask(pingTask)

-- ============================================================================
-- USER INTERFACE
-- ============================================================================
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
                local currentMS = math.floor(cachedPingValue * 1000)
                if sliderPing and sliderPing.Set then
                    sliderPing:Set(currentMS)
                end
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
    if cachedShootButton then
        cachedShootButton.Size = udim2New(0, val, 0, val)
    end
end)

TabSheriff:CreateSection("Stabilizers")
TabSheriff:CreateToggle("Sheriff_InertialStab", "Inertial Stabilizer", function() end)

local checkWeaponVisibility

TabSheriff:CreateSection("Interface")
TabSheriff:CreateToggle("Sheriff_WeaponDetect", "Weapon Detector", function() if checkWeaponVisibility then checkWeaponVisibility() end end)
TabSheriff:CreateToggle("Sheriff_ShowButton", "Show Button", function() if checkWeaponVisibility then checkWeaponVisibility() end end)
TabSheriff:CreateToggle("Sheriff_LockBtnPos", "Lock Button Position", function() end)

-- ============================================================================
-- WEAPON & ROLE DETECTION
-- ============================================================================
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
    
    if not showBtn then
        cachedScreenGui.Enabled = false
        return
    end

    if useDetect then
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local hasGun = false
        if char then
            for _, item in pairs(char:GetChildren()) do
                if isRangedWeapon(item) then hasGun = true break end
            end
        end
        if not hasGun and backpack then
            for _, item in pairs(backpack:GetChildren()) do
                if isRangedWeapon(item) then hasGun = true break end
            end
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

local mapCastParams = RaycastParams.new()
mapCastParams.FilterType = Enum.RaycastFilterType.Exclude
local ignoreListCache = {} 

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
    table.clear(ignoreListCache)
    table.insert(ignoreListCache, LocalPlayer.Character)
    table.insert(ignoreListCache, Camera)
    
    local allPlayers = Players:GetPlayers()
    for i = 1, #allPlayers do 
        if allPlayers[i].Character then table.insert(ignoreListCache, allPlayers[i].Character) end 
    end

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

            while direction.Magnitude > 0.1 do
                mapCastParams.FilterDescendantsInstances = ignoreListCache
                local ray = workspace:Raycast(currentOrigin, direction, mapCastParams)
                if not ray then break end

                local hitInst = ray.Instance
                if hitInst and (hitInst.CanCollide == true and hitInst.Transparency < 0.8) then
                    blocked = true
                    break 
                else
                    table.insert(ignoreListCache, hitInst)
                    currentOrigin = ray.Position + (direction.Unit * 0.05)
                    direction = targetPos - currentOrigin
                end
            end

            if not blocked then 
                return part, false
            end
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

-- ============================================================================
-- PREDICTION ENGINE
-- ============================================================================
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
    
    local realDisplacement = VECTOR_ZERO
    local calculatedVelY = rawPhysicsVel.Y

    if lastPositions[targetChar] then
        local dtPrev = os_clock() - lastPositions[targetChar].Time
        if dtPrev > 0.008 then
            realDisplacement = (hrp.Position - lastPositions[targetChar].Pos) / dtPrev
            if math_abs(realDisplacement.Y) > 0.5 then
                calculatedVelY = realDisplacement.Y
            end
        end
    end
    lastPositions[targetChar] = {Pos = hrp.Position, Time = os_clock()}

    local intendedVel = vec3New(humanoid.MoveDirection.X * walkSpeed, 0, humanoid.MoveDirection.Z * walkSpeed)
    local actualPhysicsH = vec3New(rawPhysicsVel.X, 0, rawPhysicsVel.Z)
    local rawVelocity = actualPhysicsH:Lerp(intendedVel, math_clamp(moveMag, 0, 1))

    -- FILTRO DE INERTIAL STABILIZER (Anti-Lag y Choque de Paredes)
    local useStabilizer = Flag("Sheriff_InertialStab", true)
    if useStabilizer then
        local realHorizontalVel = vec3New(realDisplacement.X, 0, realDisplacement.Z)
        -- Si el juego marca velocidad pero en el mundo 3D no se mueve (atascado o lag)
        if realHorizontalVel.Magnitude < 1.2 and (moveMag > 0.1 or actualPhysicsH.Magnitude > 2) then
            rawVelocity = realHorizontalVel
        end
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
    if isStopping then
        vSmoothAlpha = 0.80
    elseif isStarting then
        vSmoothAlpha = 0.20
    elseif useStabilizer then
        vSmoothAlpha = math_clamp(14 * activeDT, 0.18, 0.50)
    end
    
    smoothedVelocity = smoothedVelocity:Lerp(rawVelocity, vSmoothAlpha)
    if isStopping and smoothedVelocity.Magnitude < 0.3 then smoothedVelocity = VECTOR_ZERO end

    local horizontalShift = VECTOR_ZERO
    local verticalShift = VECTOR_ZERO

    local prioritizePing = Flag("Sheriff_PrioritizePing", false)
    local vScale = Flag("Sheriff_VScale", 100)
    local hScale = Flag("Sheriff_HScale", 100)
    local shotType = Flag("Sheriff_ShotType", "Normal")

    local effectiveHLatency = 0
    local effectiveVLatency = 0

    if prioritizePing then
        local rawMS = cachedPingValue * 1000
        local autoScale = 90 + (rawMS * 0.6)
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

    -- DETECCIÓN NATIVA DE AVATARES DIMINUTOS / MINI RTHRO
    local extentsSize = targetChar:GetExtentsSize()
    local isMiniAvatar = (extentsSize.Y < 3.8)

    if vScale > 0 then
        local isAir = (humanoid.FloorMaterial == Enum.Material.Air)
        local isStairMovement = (not isAir and math_abs(calculatedVelY) > 0.8)

        if isAir or isStairMovement then
            local adaptiveYFactor = math_clamp((distance - closeZone) / 12, 0, 1)
            local vFactor = effectiveVLatency * adaptiveYFactor

            if isAir then
                if calculatedVelY < -0.5 then
                    local fallingYFactor = calculatedVelY * 0.15
                    local gravityEffect = 0.05 * workspace_Gravity * math_pow(vFactor, 2)
                    local pY = (fallingYFactor * vFactor) - gravityEffect
                    verticalShift = vec3New(0, pY, 0)
                else
                    local miniHeightMult = isMiniAvatar and 0.65 or 1.0
                    local gravityEffect = 0.5 * workspace_Gravity * math_pow(vFactor, 2)
                    local pY = ((calculatedVelY * vFactor) - gravityEffect) * miniHeightMult
                    verticalShift = vec3New(0, pY, 0)
                end
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
        local minAllowedY = floorY + (isMiniAvatar and (extentsSize.Y * 0.3) or (hrp.Size.Y / 2)) + 0.05
        if finalPredWithY.Y < minAllowedY then 
            finalPredWithY = vec3New(finalPredWithY.X, minAllowedY, finalPredWithY.Z) 
        end
    end

    return finalPredWithY, finalPredNoY, minPredNoY
end

-- ============================================================================
-- TRACERS & VISUALS
-- ============================================================================
local MinPredictionLine = Drawing.new("Line")
MinPredictionLine.Color = color3RGB(4, 0, 220)
MinPredictionLine.Thickness = 2.0
MinPredictionLine.Transparency = 1.0  
MinPredictionLine.ZIndex = 5          

local PredictionLine = Drawing.new("Line")
PredictionLine.Color = color3RGB(255, 35, 35)
PredictionLine.Thickness = 2.0
PredictionLine.Transparency = 1.0  
PredictionLine.ZIndex = 10         

local LeadTimeLine = Drawing.new("Line")
LeadTimeLine.Color = color3RGB(35, 255, 35)
LeadTimeLine.Thickness = 1.8
LeadTimeLine.Transparency = 1.0  
LeadTimeLine.ZIndex = 7

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
                    local shotType = Flag("Sheriff_ShotType", "Normal")
                    LeadTimeLine.Color = (handLineIsBlocked and shotType ~= "Piercer Bullet") and color3RGB(255, 255, 255) or color3RGB(35, 255, 35)
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

-- ============================================================================
-- FIRING EXECUTION
-- ============================================================================
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

-- Keybind listener
local inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local targetKey = Flag("Sheriff_ShootKey", "F")
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode.Name == targetKey or tostring(input.KeyCode) == tostring(targetKey) then
            task.spawn(fireAtMurdererDirectly)
        end
    end
end)
KillerHub:AddTask(inputConn)

-- ============================================================================
-- TOUCH SHOOT BUTTON
-- ============================================================================
local POS_FILE = "KillerHub_ButtonPos.txt"

local function loadButtonPosition()
    if isfile and readfile and isfile(POS_FILE) then
        local ok, result = pcall(function()
            return HttpService:JSONDecode(readfile(POS_FILE))
        end)
        if ok and type(result) == "table" and result.X and result.Y then
            return udim2New(result.X, 0, result.Y, 0)
        end
    end
    if getgenv().__KillerHub_ButtonPos then
        return getgenv().__KillerHub_ButtonPos
    end
    return udim2New(0.7, 0, 0.6, 0)
end

local function saveButtonPosition(pos)
    getgenv().__KillerHub_ButtonPos = pos
    if writefile then
        pcall(function()
            writefile(POS_FILE, HttpService:JSONEncode({X = pos.X.Scale, Y = pos.Y.Scale}))
        end)
    end
end

local VoidGui = Instance.new("ScreenGui")
VoidGui.Name = "KillerHub_SheriffGui"
VoidGui.ResetOnSpawn = false 
VoidGui.Parent = game:GetService("CoreGui")
KillerHub:AddTask(VoidGui)

local btnSize = Flag("Sheriff_BtnSize", 95)
local ShootButton = Instance.new("ImageButton")
ShootButton.Name = "ShootButton"
ShootButton.Size = udim2New(0, btnSize, 0, btnSize)
ShootButton.Position = loadButtonPosition()
ShootButton.BackgroundColor3 = color3RGB(15, 6, 26)
ShootButton.BackgroundTransparency = 0.05
ShootButton.BorderSizePixel = 0; ShootButton.AutoButtonColor = false; ShootButton.ClipsDescendants = true; ShootButton.Parent = VoidGui

cachedScreenGui = VoidGui
cachedShootButton = ShootButton

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0.28, 0) Corner.Parent = ShootButton

local GlowOverlay = Instance.new("Frame")
GlowOverlay.Size = udim2New(1, 0, 1, 0) 
GlowOverlay.BackgroundTransparency = 1; 
GlowOverlay.ZIndex = ShootButton.ZIndex + 1; 
GlowOverlay.Parent = ShootButton

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0.28, 0) GlowCorner.Parent = GlowOverlay

local UiGradient = Instance.new("UIGradient")
UiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, color3RGB(24, 8, 43)), 
    ColorSequenceKeypoint.new(0.5, color3RGB(131, 46, 222)), 
    ColorSequenceKeypoint.new(1, color3RGB(24, 8, 43))
})
UiGradient.Offset = vec2New(0, 0) 
UiGradient.Rotation = 0 
UiGradient.Parent = GlowOverlay

local rotTask = task.spawn(function()
    while VoidGui.Parent do
        local tweenRot = TweenService:Create(UiGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = UiGradient.Rotation + 360})
        tweenRot:Play()
        tweenRot.Completed:Wait()
    end
end)
KillerHub:AddTask(rotTask)

local DecalTexture = Instance.new("ImageLabel")
DecalTexture.Size = udim2New(0.37, 0, 0.37, 0) DecalTexture.AnchorPoint = vec2New(0.5, 0.5) DecalTexture.Position = udim2New(0.5, 0, 0.44, 0)
DecalTexture.BackgroundTransparency = 1; DecalTexture.Image = "rbxassetid://125754446555599"
DecalTexture.ZIndex = ShootButton.ZIndex + 2; DecalTexture.Parent = ShootButton

local animTask = task.spawn(function()
    local ti = TweenInfo.new(0.80, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local t1 = TweenService:Create(DecalTexture, ti, {Rotation = 360})
    local t2 = TweenService:Create(DecalTexture, ti, {Rotation = 0})
    KillerHub:AddTask(t1.Completed:Connect(function() task.wait(0.032) t2:Play() end))
    KillerHub:AddTask(t2.Completed:Connect(function() task.wait(0.032) t1:Play() end))
    t1:Play()
end)
KillerHub:AddTask(animTask)

local Label = Instance.new("TextLabel")
Label.Size = udim2New(1, 0, 0.2, 0) Label.Position = udim2New(0, 0, 0.75, 0) Label.BackgroundTransparency = 1
Label.Text = "SHOOT" Label.TextColor3 = color3RGB(255, 255, 255) Label.TextSize = 15 Label.Font = Enum.Font.GothamBold
Label.ZIndex = ShootButton.ZIndex + 2; Label.Parent = ShootButton

local dragging, dragInput, dragStart, startPos
KillerHub:AddTask(ShootButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        TweenService:Create(GlowOverlay, TweenInfo.new(0.01, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.02}):Play()
        task.spawn(fireAtMurdererDirectly)
        
        if not Flag("Sheriff_LockBtnPos", false) then
            dragging = true dragStart = input.Position startPos = ShootButton.Position
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
        if dragging then
            dragging = false
            saveButtonPosition(ShootButton.Position)
        end
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

-- ============================================================================
-- SILENT AIM HOOKS (WEAPONSERVICE INTERCEPTOR)
-- ============================================================================
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

    local function getPredictedTargetCFrame(customDelta)
        local silentAim = Flag("Sheriff_SilentAim", false)
        if not silentAim then return nil end

        local shotType = Flag("Sheriff_ShotType", "Normal")
        local useDetect = Flag("Sheriff_WeaponDetect", false)

        local gun, _ = getGunLocation()
        if useDetect and not gun then return nil end

        local murderer = getMurderer()
        if not murderer or not murderer.Character then return nil end

        local bestPart, isBlocked = getSmartTargetPart(murderer.Character)
        if not bestPart then return nil end
        if isBlocked and shotType ~= "Piercer Bullet" then return nil end

        local currentTime = os_clock()
        local dt = customDelta or math_clamp(currentTime - lastHookCallTime, 0.008, 0.033)
        lastHookCallTime = currentTime

        local finalPredictedPos = getPredictedPosition(murderer.Character, bestPart, dt)
        if finalPredictedPos then
            return cframeNew(finalPredictedPos)
        end
        return nil
    end

    if oldGetTargetPosition then
        WeaponService.GetTargetPosition = function(self, ...)
            local targetCF = getPredictedTargetCFrame()
            if targetCF then
                return targetCF
            end
            return oldGetTargetPosition(self, ...)
        end
    end

    if oldGetMouseTargetCFrame then
        WeaponService.GetMouseTargetCFrame = function(self, ...)
            local targetCF = getPredictedTargetCFrame()
            if targetCF then
                return targetCF
            end
            return oldGetMouseTargetCFrame(self, ...)
        end
    end
end



-- ============================================================================
-- 👻 KILLER HUB | MURDER SUITE V9.3 (SMART RESOURCE SAVER & VISUAL FIX)
-- ============================================================================

if getgenv().__KillerHub_MurderSuite_Loaded then
    if getgenv().KillerHub and getgenv().KillerHub.NotifyWarn then
        getgenv().KillerHub:NotifyWarn("Ya cargado", "Murder Suite ya se está ejecutando.", 3)
    end
    return
end
getgenv().__KillerHub_MurderSuite_Loaded = true


-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Camera = workspace.CurrentCamera

-- Constants & Memory Caches
local MAX_DISTANCE_SQ = 1822500
local wallFilterTable = {}
local partsToCheck = {nil, nil}
local playerFysics = {}
local lastVisualPosition = Vector3.new(0, 0, 0)
local lastActualPosition = Vector3.new(0, 0, 0)
local lastTracerPosition = Vector3.new(0, 0, 0)
local cachedHasKnife = false
local lastKnifeCheck = 0
local cachedTarget = nil
local wasHitboxActive = false

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude

-- Caché de Viewport y DPI
local cachedViewportSize = Camera.ViewportSize
local cachedScreenCenter = Vector2.new(cachedViewportSize.X / 2, cachedViewportSize.Y / 2)
local cachedDpiScale = 1

local function updateViewportCache()
    cachedViewportSize = Camera.ViewportSize
    cachedScreenCenter = Vector2.new(cachedViewportSize.X / 2, cachedViewportSize.Y / 2)
    local viewportY = cachedViewportSize.Y
    cachedDpiScale = viewportY > 0 and math.max(1, 1080 / viewportY) or 1
end
updateViewportCache()
KillerHub:AddTask(Camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateViewportCache))

-- Visual Drawing API
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 0.8; FOVCircle.NumSides = 36; FOVCircle.Filled = false; FOVCircle.Visible = false; FOVCircle.Transparency = 0.8
KillerHub:AddTask(FOVCircle)

local PredRingOuter = Drawing.new("Circle")
PredRingOuter.Radius = 6.0; PredRingOuter.Thickness = 1.2; PredRingOuter.Filled = false; PredRingOuter.Color = Color3.fromRGB(255, 35, 35); PredRingOuter.Visible = false
KillerHub:AddTask(PredRingOuter)

local PredDotCenter = Drawing.new("Circle")
PredDotCenter.Radius = 2.5; PredDotCenter.Thickness = 1; PredDotCenter.Filled = true; PredDotCenter.Color = Color3.fromRGB(255, 255, 255); PredDotCenter.Visible = false
KillerHub:AddTask(PredDotCenter)

local PredLine = Drawing.new("Line")
PredLine.Thickness = 1.0; PredLine.Color = Color3.fromRGB(185, 0, 255); PredLine.Transparency = 0.65; PredLine.Visible = false
KillerHub:AddTask(PredLine)

-- Morado Void Tracer
local TracerLine = Drawing.new("Line")
TracerLine.Thickness = 1.0; TracerLine.Color = Color3.fromRGB(140, 0, 255); TracerLine.Transparency = 0.9; TracerLine.Visible = false
KillerHub:AddTask(TracerLine)

-- Helper para leer Flags
local function GetFlag(flagName, default)
    local f = KillerHub.Flags[flagName]
    if f == nil or f.CurrentValue == nil then return default end
    return f.CurrentValue
end

-- Caché de Materiales sin pcall dentro de loops
local materialCache = {}
local function getMaterialEnum(matString)
    if materialCache[matString] then return materialCache[matString] end
    local success, mat = pcall(function() return Enum.Material[matString] end)
    local result = success and mat or Enum.Material.Plastic
    materialCache[matString] = result
    return result
end

-- Auxiliares del juego con Throttle de caché
local function hasKnifeInInventory()
    local now = os.clock()
    if now - lastKnifeCheck > 0.25 then
        lastKnifeCheck = now
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        cachedHasKnife = (char and char:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife"))
    end
    return cachedHasKnife
end

local function checkPlayerHasGun(player)
    local char = player.Character
    if char and char:FindFirstChild("Gun") then return true end
    local backpack = player:FindFirstChild("Backpack")
    return backpack and backpack:FindFirstChild("Gun") ~= nil
end

-- Wall Check optimizado
local function isVisibleThroughWalls(targetChar)
    if not targetChar then return false end
    local localChar = LocalPlayer.Character
    if not localChar then return false end

    local head = targetChar:FindFirstChild("Head")
    local torso = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso")
    if not head and not torso then return false end

    local origin = Camera.CFrame.Position
    partsToCheck[1] = head
    partsToCheck[2] = torso

    for i = 1, 2 do
        local part = partsToCheck[i]
        if part then
            local direction = part.Position - origin
            if direction:Dot(direction) > 0 then
                table.clear(wallFilterTable)
                wallFilterTable[1] = localChar
                wallFilterTable[2] = targetChar
                wallFilterTable[3] = Camera
                
                local visible = true
                for step = 1, 3 do
                    raycastParams.FilterDescendantsInstances = wallFilterTable
                    local raycastResult = workspace:Raycast(origin, direction, raycastParams)

                    if not raycastResult then
                        visible = true
                        break
                    end

                    local hitInst = raycastResult.Instance
                    if hitInst then
                        if not hitInst.CanCollide or hitInst.Transparency >= 0.75 then
                            table.insert(wallFilterTable, hitInst)
                        else
                            visible = false
                            break
                        end
                    else
                        visible = true
                        break
                    end
                end

                if visible then return true end
            end
        end
    end

    return false
end

-- Detección de Sheriff optimizada
local CurrentSheriff = nil
local lastSheriffScan = 0

local function updateSheriffTarget()
    if CurrentSheriff and CurrentSheriff.Parent == Players then
        local char = CurrentSheriff.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 and checkPlayerHasGun(CurrentSheriff) then
            return 
        end
    end

    local now = os.clock()
    if now - lastSheriffScan > 0.6 then
        lastSheriffScan = now
        CurrentSheriff = nil
        
        local allPlayers = Players:GetPlayers()
        for i = 1, #allPlayers do
            local player = allPlayers[i]
            if player ~= LocalPlayer and checkPlayerHasGun(player) then
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    CurrentSheriff = player
                    break
                end
            end
        end
    end
end

-- Selección de Objetivo Dual
local function getClosestTargetToFOV()
    local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localHrp then return nil end

    local aimType = GetFlag("KnifeAimType", "Target FOV")
    local wallCheck = GetFlag("KnifeWallCheckActive", false)
    local allPlayers = Players:GetPlayers()

    if aimType == "Nearest Player" then
        local nearestPlayer = nil
        local shortestDistSq = MAX_DISTANCE_SQ

        for i = 1, #allPlayers do
            local player = allPlayers[i]
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                if hrp and humanoid and humanoid.Health > 0 then
                    local diff = hrp.Position - localHrp.Position
                    local distSq = diff:Dot(diff)
                    if distSq <= shortestDistSq then
                        if wallCheck and not isVisibleThroughWalls(player.Character) then
                            continue
                        end
                        shortestDistSq = distSq
                        nearestPlayer = player
                    end
                end
            end
        end

        cachedTarget = nearestPlayer
        return nearestPlayer
    end

    if GetFlag("PrioritizeSheriffActive", false) then
        updateSheriffTarget()
    else
        CurrentSheriff = nil
    end

    local fovRadius = GetFlag("FovRadiusMurder", 150)

    if CurrentSheriff and CurrentSheriff.Character then
        local hrp = CurrentSheriff.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local diff = hrp.Position - localHrp.Position
            if diff:Dot(diff) <= MAX_DISTANCE_SQ then
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - cachedScreenCenter).Magnitude
                    if distToCenter < fovRadius then
                        if not wallCheck or isVisibleThroughWalls(CurrentSheriff.Character) then
                            cachedTarget = CurrentSheriff
                            return CurrentSheriff
                        end
                    end
                end
            end
        end
    end

    local closestInnocent = nil
    local shortestDistance = fovRadius 

    for i = 1, #allPlayers do
        local player = allPlayers[i]
        if player ~= LocalPlayer and player ~= CurrentSheriff and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if hrp and humanoid and humanoid.Health > 0 then
                local diff = hrp.Position - localHrp.Position
                if diff:Dot(diff) > MAX_DISTANCE_SQ then continue end

                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - cachedScreenCenter).Magnitude
                    if distToCenter < shortestDistance then
                        if wallCheck and not isVisibleThroughWalls(player.Character) then
                            continue
                        end
                        shortestDistance = distToCenter
                        closestInnocent = player
                    end
                end
            end
        end
    end

    cachedTarget = closestInnocent
    return closestInnocent
end

-- Motor de Predicción Balística de Cuchillo
local function getAdvancedKnifePrediction(targetChar)
    if not targetChar then return nil, nil end
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
    local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not hrp or not humanoid or not localHrp then return nil, nil end

    local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
    local targetPosition = hrp.Position
    local distance = (targetPosition - localHrp.Position).Magnitude
    local physicsData = playerFysics[targetPlayer]
    
    if physicsData and physicsData.IsLaggingOut then
        return targetPosition, targetPosition
    end

    local extentsY = targetChar:GetExtentsSize().Y
    local scaleFactor = 1.0
    if humanoid:FindFirstChild("BodyHeightScale") then scaleFactor = humanoid.BodyHeightScale.Value end

    if extentsY < 4.8 or scaleFactor < 0.85 then
        local heightDeficit = math.clamp((5.1 - extentsY) * 0.52, 0.4, 2.3)
        targetPosition = targetPosition - Vector3.new(0, heightDeficit, 0)
    end

    local smoothVelocity = physicsData and physicsData.SmoothedVelocity or Vector3.new(0, 0, 0)
    if smoothVelocity:Dot(smoothVelocity) < 0.0225 then return targetPosition, targetPosition end

    local rawPing = 0.06
    if Stats and Stats:FindFirstChild("Network") and Stats.Network:FindFirstChild("ServerToClientPing") then
        rawPing = Stats.Network.ServerToClientPing:GetValue() / 1000
    end
    local ping = math.clamp(rawPing, 0.01, 0.25)
    local travelTime = (distance / 85) + ping

    local horizontalVelocity = Vector3.new(smoothVelocity.X, 0, smoothVelocity.Z)
    local exactSpeed = horizontalVelocity.Magnitude

    local MAX_WALKSPEED = 16.715
    if exactSpeed > MAX_WALKSPEED then 
        horizontalVelocity = horizontalVelocity.Unit * MAX_WALKSPEED
        exactSpeed = MAX_WALKSPEED
    end

    local jukeFactor = 1.0
    if physicsData and physicsData.LastVelocity then
        local lastHorizVel = Vector3.new(physicsData.LastVelocity.X, 0, physicsData.LastVelocity.Z)
        local lastSpeed = lastHorizVel.Magnitude
        
        if exactSpeed > 1 and lastSpeed > 1 then
            local currentDir = horizontalVelocity.Unit
            local lastDir = lastHorizVel.Unit
            local dotProduct = currentDir:Dot(lastDir)
            
            if dotProduct < 0.94 then
                jukeFactor = math.clamp(dotProduct, 0.10, 1.0)
            end
            
            if exactSpeed < lastSpeed * 0.85 then
                local decelerationRatio = exactSpeed / lastSpeed
                jukeFactor = jukeFactor * math.clamp(decelerationRatio, 0.05, 1.0)
            end
        end
    end

    local velocityScale = math.clamp(exactSpeed / MAX_WALKSPEED, 0, 1)
    if exactSpeed < 12 then
        velocityScale = math.pow(velocityScale, 1.4)
    end

    local shortRangeBoost = distance < 20 and 1.15 or 1.0
    local dynamicScale = (1.0 + (distance * 0.004)) * shortRangeBoost
    local maxElasticCap = math.clamp(distance * 0.38, 3.5, 13.5)
    
    local hPredConfig = GetFlag("KnifeHorizSlider", 145) / 1000
    local vPredConfig = GetFlag("KnifeVertSlider", 40) / 1000

    local horizontalOffset = horizontalVelocity * (hPredConfig * 6.8) * travelTime * dynamicScale * jukeFactor * velocityScale
    if horizontalOffset:Dot(horizontalOffset) > (maxElasticCap * maxElasticCap) then 
        horizontalOffset = horizontalOffset.Unit * maxElasticCap 
    end

    local verticalOffset = Vector3.new(0, 0, 0)
    local isAir = (humanoid.FloorMaterial == Enum.Material.Air)
    local absYVelocity = math.abs(smoothVelocity.Y)

    if isAir then
        local verticalVelocity = math.clamp(smoothVelocity.Y, -18, 25)
        local verticalDistanceScale = 1 / (1 + (distance * 0.005))
        verticalVelocity = verticalVelocity * (verticalVelocity < -1 and 0.40 or 0.70)
        verticalOffset = Vector3.new(0, verticalVelocity * (vPredConfig * 6.0) * travelTime * verticalDistanceScale, 0)
    elseif absYVelocity > 0.02 then
        local verticalVelocity = smoothVelocity.Y
        local rampCompensationFactor = 1.35
        local sliderScale = (vPredConfig / 0.040)
        verticalOffset = Vector3.new(0, verticalVelocity * travelTime * sliderScale * rampCompensationFactor, 0)
    end

    local finalPredictedPos = targetPosition + horizontalOffset + verticalOffset
    
    table.clear(wallFilterTable)
    wallFilterTable[1] = targetChar
    wallFilterTable[2] = LocalPlayer.Character
    wallFilterTable[3] = Camera
    raycastParams.FilterDescendantsInstances = wallFilterTable
    
    local wallRay = workspace:Raycast(targetPosition, finalPredictedPos - targetPosition, raycastParams)
    if wallRay and wallRay.Instance and wallRay.Instance.CanCollide then
        local hitDistance = (wallRay.Position - targetPosition).Magnitude
        if hitDistance > 0.5 then
            finalPredictedPos = targetPosition + (finalPredictedPos - targetPosition).Unit * (hitDistance - 0.4)
        else
            finalPredictedPos = targetPosition
        end
    end

    return targetPosition, finalPredictedPos
end

-- UI Setup
local MurderTab = KillerHub:CreateTab("Murder", "rbxassetid://104386785713574")

MurderTab:CreateSection("Knife Combats")
MurderTab:CreateToggle("KnifeAimActive", "Knife Thrown aim", function(state) end)
MurderTab:CreateDropdown("KnifeAimType", "Type of throw aim", {"Target FOV", "Nearest Player"}, function(selected) end)
MurderTab:CreateToggle("PrioritizeSheriffActive", "Prioritize Sheriff", function(state) end)
MurderTab:CreateToggle("KnifeWallCheckActive", "Wall Check", function(state) end)

MurderTab:CreateDropdown("KnifeThrowType", "Knife throwing type", {"Normal", "Fast"}, function(selected) end)
MurderTab:CreateSlider("KnifeThrowDistance", "Throw Advance Distance", 0, 100, function(value) end)

MurderTab:CreateSlider("KnifeHorizSlider", "Horizontal prediction", 0, 300, function(value) end)
MurderTab:CreateSlider("KnifeVertSlider", "Vertical prediction", 0, 120, function(value) end)

MurderTab:CreateSection("Stab Hitbox Modifier")
MurderTab:CreateToggle("StabHitboxMaster", "Stab Hitbox", function(state) end)
MurderTab:CreateToggle("SeeHitboxActive", "See hitbox", function(state) end)
MurderTab:CreateSlider("HitboxSizeSlider", "Stab Hitbox Size", 2, 30, function(value) end)
MurderTab:CreateSlider("HitboxTransparencySlider", "Hitbox transparency", 0, 100, function(value) end)

MurderTab:CreateDropdown("HitboxMaterialDropdown", "Hitbox Material", 
    {"Plastic", "SmoothPlastic", "Metal", "DiamondPlate", "Glass", "Neon", "ForceField", "Wood"}, 
    function(selected) end
)

MurderTab:CreateSection("Visuals & Environment")
MurderTab:CreateToggle("ShowKnifePredictionVisual", "See prediction", function(state) end)
MurderTab:CreateToggle("ShowKnifeTracerVisual", "See prediction tracer", function(state) end)
MurderTab:CreateToggle("SmartHandVisibility", "Smart Visibility", function(state) end)

MurderTab:CreateSection("Modify FOV")
MurderTab:CreateToggleColorPicker("FovVisibleMurder", "FovColorMurder", "Show FOV Circle", Color3.fromRGB(0, 255, 185), function(state) end, function(color) end)
MurderTab:CreateSlider("FovRadiusMurder", "FOV Radius", 30, 600, function(value) end)

-- LOOPS OPTIMIZADOS
local hbConn = RunService.Heartbeat:Connect(function()
    local silentAimActive = GetFlag("KnifeAimActive", false)
    local hitboxActive = GetFlag("StabHitboxMaster", false)
    local smartVis = GetFlag("SmartHandVisibility", false)
    local hasKnife = hasKnifeInInventory()

    -- Ahorrador de recursos: Si Smart Visibility está activado y NO hay cuchillo, pausamos cálculos de aimbot
    local shouldRunAimLogic = silentAimActive and (not smartVis or hasKnife)

    if shouldRunAimLogic then
        getClosestTargetToFOV()
    else
        cachedTarget = nil
    end

    -- Restaurar Hitbox si se desactiva
    if not hitboxActive and wasHitboxActive then
        wasHitboxActive = false
        local allPlayers = Players:GetPlayers()
        for i = 1, #allPlayers do
            local player = allPlayers[i]
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Material = Enum.Material.Plastic
                end
            end
        end
    end

    if not shouldRunAimLogic and not hitboxActive then return end
    if hitboxActive then wasHitboxActive = true end

    local currentTime = os.clock()
    local seeHitbox = GetFlag("SeeHitboxActive", false)
    local hitboxSize = GetFlag("HitboxSizeSlider", 2)
    local transSlider = GetFlag("HitboxTransparencySlider", 0)
    local targetTransparency = math.clamp(transSlider, 0, 100) / 100
    local matEnum = getMaterialEnum(GetFlag("HitboxMaterialDropdown", "Plastic"))
    local allPlayers = Players:GetPlayers()

    for i = 1, #allPlayers do
        local player = allPlayers[i]
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- Modificación de Hitbox con comprobación rápida
                if hitboxActive then
                    local targetSize = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    if hrp.Size ~= targetSize then hrp.Size = targetSize end
                    if hrp.CanCollide then hrp.CanCollide = false end

                    if seeHitbox then
                        if hrp.Transparency ~= targetTransparency then hrp.Transparency = targetTransparency end
                        if hrp.Material ~= matEnum then hrp.Material = matEnum end
                    else
                        if hrp.Transparency ~= 1 then hrp.Transparency = 1 end
                    end
                end

                -- Cálculo de Física para Silent Aim
                if shouldRunAimLogic then
                    local currentPos = hrp.Position
                    local physicsVelocity = hrp.AssemblyLinearVelocity
                    
                    if not playerFysics[player] then
                        playerFysics[player] = { 
                            LastPos = currentPos, 
                            LastTime = currentTime, 
                            SmoothedVelocity = physicsVelocity, 
                            LastVelocity = physicsVelocity,
                            LastRawVelocity = physicsVelocity,
                            ConsecutiveSameVelocity = 0,
                            IsLaggingOut = false
                        }
                    else
                        local data = playerFysics[player]
                        local deltaTime = currentTime - data.LastTime
                        
                        if deltaTime > 0 then
                            local positionalVelocity = (currentPos - data.LastPos) / deltaTime
                            local realVelocity = Vector3.new(physicsVelocity.X, positionalVelocity.Y, physicsVelocity.Z)
                            
                            local diffVel = realVelocity - data.LastRawVelocity
                            if data.LastRawVelocity and diffVel:Dot(diffVel) < 0.000001 then
                                data.ConsecutiveSameVelocity = data.ConsecutiveSameVelocity + 1
                            else
                                data.ConsecutiveSameVelocity = 0
                            end
                            
                            data.LastRawVelocity = realVelocity
                            
                            if data.ConsecutiveSameVelocity > 20 and realVelocity:Dot(realVelocity) > 1 then
                                data.IsLaggingOut = true
                                realVelocity = Vector3.new(0, 0, 0)
                            else
                                data.IsLaggingOut = false
                            end
                            
                            if positionalVelocity:Dot(positionalVelocity) > 3025 then 
                                realVelocity = Vector3.new(0, 0, 0) 
                            end
                            
                            data.LastVelocity = data.SmoothedVelocity
                            data.SmoothedVelocity = data.SmoothedVelocity:Lerp(realVelocity, 0.20)
                        end
                        
                        data.LastPos = currentPos
                        data.LastTime = currentTime
                    end
                end
            end
        end
    end
end)
KillerHub:AddTask(hbConn)

local rsConn = RunService.RenderStepped:Connect(function()
    local silentAimActive = GetFlag("KnifeAimActive", false)

    -- Si apagas el Silent Aim, apaga todo inmediatamente
    if not silentAimActive then
        FOVCircle.Visible = false
        PredDotCenter.Visible = false
        PredRingOuter.Visible = false
        PredLine.Visible = false
        TracerLine.Visible = false
        return
    end

    local hasKnife = hasKnifeInInventory()
    local smartVis = GetFlag("SmartHandVisibility", false)

    -- Ahorrador de recursos: Si Smart Visibility está encendido y no hay cuchillo, ocultar todo
    if smartVis and not hasKnife then
        FOVCircle.Visible = false
        PredDotCenter.Visible = false
        PredRingOuter.Visible = false
        PredLine.Visible = false
        TracerLine.Visible = false
        return
    end

    -- FOV Circle
    local showFOV = GetFlag("FovVisibleMurder", false)
    if showFOV then
        FOVCircle.Position = cachedScreenCenter
        FOVCircle.Radius = GetFlag("FovRadiusMurder", 150) * cachedDpiScale
        FOVCircle.Thickness = 0.8 * cachedDpiScale
        FOVCircle.Color = GetFlag("FovColorMurder", Color3.fromRGB(0, 255, 185))
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end

    local activeTarget = cachedTarget

    -- Standard Prediction Visuals (Circles & Connection Line)
    local showPred = GetFlag("ShowKnifePredictionVisual", false)
    if showPred and activeTarget and activeTarget.Character then
        local basePos, rawPredictedPos = getAdvancedKnifePrediction(activeTarget.Character)
        if basePos and rawPredictedPos then
            lastActualPosition = lastActualPosition:Lerp(basePos, 0.28)
            lastVisualPosition = lastVisualPosition:Lerp(rawPredictedPos, 0.28)
            
            local screenPosBase, onScreenBase = Camera:WorldToViewportPoint(lastActualPosition)
            local screenPosPred, onScreenPred = Camera:WorldToViewportPoint(lastVisualPosition)
            
            if onScreenBase and onScreenPred then
                local drawBase = Vector2.new(screenPosBase.X, screenPosBase.Y)
                local drawPred = Vector2.new(screenPosPred.X, screenPosPred.Y)
                
                PredDotCenter.Radius = 2.5 * cachedDpiScale
                PredDotCenter.Thickness = 1 * cachedDpiScale
                PredRingOuter.Radius = 6.0 * cachedDpiScale
                PredRingOuter.Thickness = 1.2 * cachedDpiScale
                PredLine.Thickness = 1.0 * cachedDpiScale

                PredDotCenter.Position = drawBase
                PredRingOuter.Position = drawPred
                PredLine.From = drawBase
                PredLine.To = drawPred
                
                local lineDiff = drawBase - drawPred
                PredLine.Visible = lineDiff:Dot(lineDiff) >= (2.25 * cachedDpiScale * cachedDpiScale)
                PredDotCenter.Visible = true
                PredRingOuter.Visible = true
            else
                PredDotCenter.Visible = false; PredRingOuter.Visible = false; PredLine.Visible = false
            end
        else
            PredDotCenter.Visible = false; PredRingOuter.Visible = false; PredLine.Visible = false
        end
    else
        PredDotCenter.Visible = false; PredRingOuter.Visible = false; PredLine.Visible = false
        if activeTarget and activeTarget.Character then
            local hrp = activeTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                lastActualPosition = hrp.Position
                lastVisualPosition = hrp.Position
            end
        end
    end

    -- Prediction Tracer Visual (Morado Void desde Mano Derecha)
    local showTracer = GetFlag("ShowKnifeTracerVisual", false)
    if showTracer and activeTarget and activeTarget.Character then
        local _, rawPredictedPos = getAdvancedKnifePrediction(activeTarget.Character)
        if rawPredictedPos then
            -- 80% reactividad / 20% suavizado en la respuesta
            lastTracerPosition = lastTracerPosition:Lerp(rawPredictedPos, 0.80)

            local char = LocalPlayer.Character
            local rightHand = char and (char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"))
            local originWorld = rightHand and rightHand.Position or (char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position)

            if originWorld then
                local screenHand, onScreenHand = Camera:WorldToViewportPoint(originWorld)
                local screenPred, onScreenPred = Camera:WorldToViewportPoint(lastTracerPosition)

                if onScreenHand or onScreenPred then
                    TracerLine.From = Vector2.new(screenHand.X, screenHand.Y)
                    TracerLine.To = Vector2.new(screenPred.X, screenPred.Y)
                    TracerLine.Thickness = 1.0 * cachedDpiScale
                    TracerLine.Visible = true
                else
                    TracerLine.Visible = false
                end
            else
                TracerLine.Visible = false
            end
        else
            TracerLine.Visible = false
        end
    else
        TracerLine.Visible = false
        if activeTarget and activeTarget.Character then
            local hrp = activeTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then lastTracerPosition = hrp.Position end
        end
    end
end)
KillerHub:AddTask(rsConn)

-- Hooks para Silent Aim
local ClientServices = ReplicatedStorage:WaitForChild("ClientServices", 5)
if ClientServices then
    local WeaponService = require(ClientServices:WaitForChild("WeaponService"))
    local oldGetTargetPosition = WeaponService.GetTargetPosition
    local oldGetMouseTargetCFrame = WeaponService.GetMouseTargetCFrame

    WeaponService.GetTargetPosition = function(self, ...)
        local silentAim = GetFlag("KnifeAimActive", false)
        if silentAim and hasKnifeInInventory() then
            local targetPlayer = cachedTarget or getClosestTargetToFOV()
            if targetPlayer and targetPlayer.Character then
                local _, predictedPos = getAdvancedKnifePrediction(targetPlayer.Character)
                if predictedPos then return CFrame.new(predictedPos) end
            end
        end
        return oldGetTargetPosition(self, ...)
    end

    WeaponService.GetMouseTargetCFrame = function(self, ...)
        local silentAim = GetFlag("KnifeAimActive", false)
        if silentAim and hasKnifeInInventory() then
            local targetPlayer = cachedTarget or getClosestTargetToFOV()
            if targetPlayer and targetPlayer.Character then
                local _, predictedPos = getAdvancedKnifePrediction(targetPlayer.Character)
                if predictedPos then return CFrame.new(predictedPos) end
            end
        end
        return oldGetMouseTargetCFrame(self, ...)
    end
end

-- Namecall hook
local rawNamecall
rawNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() and method == "FireServer" and self.Name == "KnifeThrown" then
        local throwType = GetFlag("KnifeThrowType", "Normal")
        local throwDistConfig = GetFlag("KnifeThrowDistance", 14)
        
        if throwType == "Fast" and throwDistConfig > 0 and #args >= 2 and typeof(args[1]) == "CFrame" and typeof(args[2]) == "CFrame" then
            local originCF = args[1]
            local targetCF = args[2]
            
            local direction = (targetCF.Position - originCF.Position)
            local dist = direction.Magnitude
            
            if dist > 0 then
                local lookDir = direction.Unit
                local advanceDistance = math.min(throwDistConfig, dist * 0.75)
                
                args[1] = originCF + (lookDir * advanceDistance)
            end
            
            return rawNamecall(self, unpack(args))
        end
    end

    return rawNamecall(self, ...)
end))

return KillerHub
