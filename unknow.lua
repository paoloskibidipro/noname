-- ============================================================================
-- 👻 KILLER HUB - MM2 ADVANCED VISUAL SUITE (SINGLE-TAB INTEGRATED V5.2)
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
local Instance_new = Instance.new
local UDim2_new = UDim2.new
local playersGetPlayers = Players.GetPlayers

-- Default Game Roles & Teams Colors
local DefaultColors = {
    Murderer = Color3_fromRGB(180, 55, 55),
    Sheriff  = Color3_fromRGB(35, 102, 204),
    Hero     = Color3_fromRGB(230, 188, 62),
    Innocent = Color3_fromRGB(26, 171, 81),
    Dead     = Color3_fromRGB(115, 115, 115),
    GunDrop  = Color3_fromRGB(255, 0, 0),
    Teammate = Color3_fromRGB(0, 255, 0),
    Enemy    = Color3_fromRGB(255, 0, 0)
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
    TracerPosition = "Bottom Center",
    TracerRoles = {["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, ["Dead/None"] = false},

    LimbChams = false,
    LimbChamsTrans = 50,
    LimbChamsRoles = {["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, ["Dead/None"] = false},

    -- DUELS CONFIG
    DuelESP = true, -- Activado por defecto para detectar cuando inicie un duelo
    DuelHighlight = true,
    DuelBox = true,
    DuelName = true,
    DuelTracer = false,

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
local KillerHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/zpxlo0ev/LuXpaO/refs/heads/main/007900118.lua"))()

local VisualsTab  = KillerHub:CreateTab("Visuals", "Eye")
local PagePlayers = VisualsTab:CreatePage("Players ESP", "Eye")
local PageDuels   = VisualsTab:CreatePage("Duels ESP", "Sword")

-- PAGE 1: PLAYERS ESP
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

-- PAGE 2: DUELS ESP
PageDuels:CreateSection("Duels & Gun vs Gun Team ESP")
local ToggleDuelESP = PageDuels:CreateToggle("DuelEspMaster", "Enable Duels Mode ESP", function(val) Config.DuelESP = val; saveConfig() end)
local ToggleDuelHL  = PageDuels:CreateToggle("DuelEspHL", "Highlight ESP", function(val) Config.DuelHighlight = val; saveConfig() end)
local ToggleDuelBox = PageDuels:CreateToggle("DuelEspBox", "Box ESP", function(val) Config.DuelBox = val; saveConfig() end)
local ToggleDuelName= PageDuels:CreateToggle("DuelEspName", "Name ESP", function(val) Config.DuelName = val; saveConfig() end)
local ToggleDuelTracer = PageDuels:CreateToggle("DuelEspTracer", "Tracer ESP", function(val) Config.DuelTracer = val; saveConfig() end)

-- [4] APPLY SAVED CONFIGURATIONS SAFELY
ToggleName:Set(Config.Name)
ToggleTracer:Set(Config.Tracer)
ToggleGunCham:Set(Config.GunCham); ToggleGunName:Set(Config.GunName); ToggleGunTracer:Set(Config.GunTracer); NameSizeSlider:Set(Config.NameSize); GunNameSizeSlider:Set(Config.GunNameSize)
ToggleBox:Set(Config.Box)

ToggleDuelESP:Set(Config.DuelESP)
ToggleDuelHL:Set(Config.DuelHighlight)
ToggleDuelBox:Set(Config.DuelBox)
ToggleDuelName:Set(Config.DuelName)
ToggleDuelTracer:Set(Config.DuelTracer)

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
-- 🧠 CORE ENGINE (INTELLIGENT DUEL DETECTOR)
-- ============================================================================

local playerRoles = {} 
local playerDeadStatus = {} 
local duelTeams = {} -- [PlayerName] = "Teammate" or "Enemy"
local currentGunDrop = nil 

local GunDrawingLine = Drawing.new("Line")
GunDrawingLine.Thickness = 1
GunDrawingLine.Transparency = 1
GunDrawingLine.Visible = false

local playerTracers = {}

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
    local name = player.Name
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local isDeadInGame = not char or not humanoid or humanoid.Health <= 0
    local isDeadInNetwork = playerDeadStatus[name] == true

    if isDeadInGame or isDeadInNetwork then
        return getRoleColor("Dead/None", DefaultColors.Dead), "Dead/None"
    end

    -- 🔴 DETECCIÓN DE MODO DUELOS (SOLO SE ACTIVA SI SE DETECTAN JUGADORES EN duelTeams)
    if Config.DuelESP and duelTeams[name] then
        local teamType = duelTeams[name]
        if teamType == "Teammate" then
            return DefaultColors.Teammate, "Teammate"
        elseif teamType == "Enemy" then
            return DefaultColors.Enemy, "Enemy"
        end
    end

    -- LÓGICA ESTÁNDAR (PARTIDAS NORMALES MM2)
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
    local isDuelMode = Config.DuelESP and (currentStatus == "Teammate" or currentStatus == "Enemy")

    -- Cham ESP
    local limbFolder = char:FindFirstChild("KH_LimbChams")
    if not isDuelMode and Config.LimbChams and Config.LimbChamsRoles[currentStatus] == true then
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
    local allowBox = (isDuelMode and Config.DuelBox) or (not isDuelMode and Config.Box and Config.BoxRoles[currentStatus] == true)
    
    if allowBox then
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
    local allowName = (isDuelMode and Config.DuelName) or (not isDuelMode and Config.Name and Config.NameRoles[currentStatus] == true)

    if allowName then
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
    local allowHighlight = (isDuelMode and Config.DuelHighlight) or (not isDuelMode and Config.Highlight and Config.HighlightRoles[currentStatus] == true)

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

-- ============================================================================
-- 📡 EVENTOS Y CONEXIONES CON EL SERVIDOR DE MM2
-- ============================================================================

local PlayerDataChanged = ReplicatedStorage:FindFirstChild("PlayerDataChanged", true)
local RoundStart = ReplicatedStorage:FindFirstChild("RoundStart", true)
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local CustomGames = Remotes and Remotes:FindFirstChild("CustomGames")
local DuelStarted = CustomGames and CustomGames:FindFirstChild("DuelStarted")

-- CONEXIÓN INTELIGENTE A EVENTO DE DUELOS
if DuelStarted then
    DuelStarted.OnClientEvent:Connect(function(duelData)
        table.clear(duelTeams)
        if type(duelData) == "table" then
            local myName = LocalPlayer.Name
            local myTeamName = duelData.Team1 and duelData.Team1[myName] and "Team1" or (duelData.Team2 and duelData.Team2[myName] and "Team2" or nil)
            local enemyTeamName = myTeamName == "Team1" and "Team2" or "Team1"

            if myTeamName then
                for pName, _ in pairs(duelData[myTeamName] or {}) do
                    if pName ~= myName then duelTeams[pName] = "Teammate" end
                end
                for pName, _ in pairs(duelData[enemyTeamName] or {}) do
                    duelTeams[pName] = "Enemy"
                end
            end
        end
    end)
end

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
        table.clear(playerRoles)
        table.clear(playerDeadStatus)
        currentGunDrop = nil 
        parsePlayerData(arg2)
        parsePlayerData(arg1)
    end)
end

local RoundOver = ReplicatedStorage:FindFirstChild("RoundOver", true) or ReplicatedStorage:FindFirstChild("SnowballRoundOver", true)
if RoundOver and RoundOver:IsA("RemoteEvent") then
    RoundOver.OnClientEvent:Connect(function()
        table.clear(playerRoles)
        table.clear(playerDeadStatus)
        table.clear(duelTeams) -- Vuelve al modo normal para ahorrar recursos
        currentGunDrop = nil
        local allPlayers = playersGetPlayers(Players)
        for i = 1, #allPlayers do 
            local plr = allPlayers[i]
            if plr and plr.Character then clearPlayerESP(plr.Character) end 
        end
    end)
end

Players.PlayerRemoving:Connect(function(player)
    playerRoles[player.Name] = nil
    playerDeadStatus[player.Name] = nil
    duelTeams[player.Name] = nil
    removeTracerLine(player)
end)

-- BUCLE DE ACTUALIZACIÓN (OPTIMIZADO CON task.wait)
task.spawn(function()
    while true do
        local allPlayers = playersGetPlayers(Players)
        for i = 1, #allPlayers do
            local plr = allPlayers[i]
            if plr and plr.Character then
                updatePlayerESP(plr)
            end
        end
        updateGunESP()
        task.wait(0.15)
    end
end)

-- ORIGEN DE TRACERS
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
    return Vector2_new(viewportSize.X / 2, viewportSize.Y)
end

-- TRACERS ENGINE (RenderStepped para 60+ FPS)
RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
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
                
                if root then
                    local distance = (myRoot.Position - root.Position).Magnitude
                    local color, currentStatus = getPlayerColorAndStatus(player)
                    local isDuelMode = Config.DuelESP and (currentStatus == "Teammate" or currentStatus == "Enemy")
                    local allowTracer = (isDuelMode and Config.DuelTracer) or (not isDuelMode and Config.Tracer and Config.TracerRoles[currentStatus] == true)

                    if allowTracer and distance <= Config.MaxDistance then
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

-- AUTOCLEANUP AL CERRAR
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
-- 👾 KILLER HUB | ENGINE V12.7 - SHERIFF SUITE (NATIVE STABILIZER & SMOOTH Y)
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
local math_max = math.max
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
TabSheriff:CreateSlider("Sheriff_HScale", "Horizontal Prediction", 0, 300, function() end, 100)
TabSheriff:CreateSlider("Sheriff_VScale", "Vertical Prediction", 0, 300, function() end, 100)

local sliderPing = TabSheriff:CreateSlider("Sheriff_PingComp", "Ping Compensation", 0, 300, function() end, 50)

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

TabSheriff:CreateSlider("Sheriff_CloseRange", "Close Range Zone", 0, 20, function() end, 6)

TabSheriff:CreateSection("Visuals")
TabSheriff:CreateMultiDropdown("Sheriff_Tracers", "Tracers", {
    "Tracer Prediction", 
    "Min Tracer Prediction", 
    "Lead Time", 
    "Lead Time Prediction",
    "Confirm wall check", 
    "Prediction X/Y offset"
}, function() end)

local cachedShootButton, cachedScreenGui
TabSheriff:CreateSlider("Sheriff_BtnSize", "Button Size", 50, 200, function(val)
    if cachedShootButton then cachedShootButton.Size = udim2New(0, val, 0, val) end
end, 95)

local checkWeaponVisibility
TabSheriff:CreateSection("Interface")
TabSheriff:CreateToggle("Sheriff_WeaponDetect", "Weapon Detector", function() if checkWeaponVisibility then checkWeaponVisibility() end end)
TabSheriff:CreateToggle("Sheriff_ShowButton", "Show Button", function() if checkWeaponVisibility then checkWeaponVisibility() end end)
TabSheriff:CreateToggle("Sheriff_LockBtnPos", "Lock Button Position", function() end)

local PageOthers = TabSheriff:CreatePage("Others", "Gear")
PageOthers:CreateSection("Auto Shoot")
PageOthers:CreateToggle("Sheriff_AutoShoot", "Auto shoot", function() end)
PageOthers:CreateDropdown("Sheriff_AutoShootType", "Type Auto shoot", {"Murder visible", "Knife visible"}, function() end)

PageOthers:CreateSection("Wait for Sight")
PageOthers:CreateToggle("Sheriff_WaitSight", "Wait for Sight", function() end)
PageOthers:CreateToggle("Sheriff_CancelOnClick", "Cancel waiting on click", function() end)
PageOthers:CreateSlider("Sheriff_WaitTime", "Wait Time", 5, 67, function() end, 15)

PageOthers:CreateSection("Gun Actions")
PageOthers:CreateToggle("Sheriff_UnEquipGun", "Un-Equip gun", function() end)

-- Weapon & Role Systems
local function isRangedWeapon(tool)
    if not tool or not tool:IsA("Tool") then return false end
    return (tool:FindFirstChild("Shoot") or tool.Name == "Gun" or tool.Name == "Revolver")
end

local function isMeleeWeapon(tool)
    if not tool or not tool:IsA("Tool") then return false end
    return (tool:FindFirstChild("Stab") or tool.Name == "Knife")
end

local function getGunLocation()
    local char = LocalPlayer.Character
    if char then for _, item in pairs(char:GetChildren()) do if isRangedWeapon(item) then return item, char end end end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then for _, item in pairs(bp:GetChildren()) do if isRangedWeapon(item) then return item, bp end end end
    return nil, nil
end

checkWeaponVisibility = function()
    if not cachedScreenGui then return end
    local showBtn = Flag("Sheriff_ShowButton", false)
    local useDetect = Flag("Sheriff_WeaponDetect", false)
    
    if not showBtn then cachedScreenGui.Enabled = false return end

    if useDetect then
        local gun, _ = getGunLocation()
        cachedScreenGui.Enabled = (gun ~= nil)
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
local smoothedVisualY = 0 -- Búfer anti-temblores para el eje Y visual
local lastTargetChar = nil
local emaDeltaTime = 0.016 
local playerRoles = {}
local playerDeadStatus = {}
local duelTeams = {}
local currentTarget = nil
local lastPositions = {} 
local handLineIsBlocked = false 
local lastScanTime = 0

local isWaitingForSight = false
local waitSightThread = nil
local Label = nil
local SubLabel = nil
local DecalTexture = nil

local tweenInfoFast = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function resetWaitState()
    isWaitingForSight = false
    local threadToCancel = waitSightThread
    waitSightThread = nil

    if DecalTexture then
        TweenService:Create(DecalTexture, tweenInfoFast, {
            Position = udim2New(0.5, 0, 0.44, 0),
            Size = udim2New(0.38, 0, 0.38, 0)
        }):Play()
    end
    if Label then
        TweenService:Create(Label, tweenInfoFast, {
            Position = udim2New(0, 0, 0.75, 0),
            Size = udim2New(1, 0, 0.2, 0)
        }):Play()
        Label.Text = "SHOOT"
        Label.TextColor3 = color3RGB(255, 255, 255)
    end
    if SubLabel then
        SubLabel.Text = ""
    end

    if threadToCancel and threadToCancel ~= coroutine.running() then
        pcall(function() task.cancel(threadToCancel) end)
    end
end

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

-- Remote Detector for Duels
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local CustomGames = Remotes and Remotes:FindFirstChild("CustomGames")
local DuelStarted = CustomGames and CustomGames:FindFirstChild("DuelStarted")

if DuelStarted then
    KillerHub:AddTask(DuelStarted.OnClientEvent:Connect(function(duelData)
        table.clear(duelTeams)
        if type(duelData) == "table" then
            local myName = LocalPlayer.Name
            local myTeamName = duelData.Team1 and duelData.Team1[myName] and "Team1" or (duelData.Team2 and duelData.Team2[myName] and "Team2" or nil)
            local enemyTeamName = myTeamName == "Team1" and "Team2" or "Team1"

            if myTeamName then
                for pName, _ in pairs(duelData[enemyTeamName] or {}) do
                    duelTeams[pName] = true
                end
            end
        end
    end))
end

local RoundStart = ReplicatedStorage:FindFirstChild("RoundStart", true)
if RoundStart and RoundStart:IsA("RemoteEvent") then
    KillerHub:AddTask(RoundStart.OnClientEvent:Connect(function(a1, a2)
        resetWaitState()
        table.clear(playerRoles) 
        table.clear(playerDeadStatus) 
        table.clear(lastPositions)
        MurdererDetectado = nil 
        parsePlayerData(a2) 
        parsePlayerData(a1)
    end))
end

local RoundOver = ReplicatedStorage:FindFirstChild("RoundOver", true) or ReplicatedStorage:FindFirstChild("SnowballRoundOver", true)
if RoundOver and RoundOver:IsA("RemoteEvent") then
    KillerHub:AddTask(RoundOver.OnClientEvent:Connect(function()
        resetWaitState()
        table.clear(duelTeams)
        table.clear(playerRoles)
        table.clear(playerDeadStatus)
        table.clear(lastPositions)
        MurdererDetectado = nil
    end))
end

Players.PlayerRemoving:Connect(function(plr)
    duelTeams[plr.Name] = nil
    playerRoles[plr.Name] = nil
    playerDeadStatus[plr.Name] = nil
end)

local floorCastParams = RaycastParams.new()
floorCastParams.FilterType = Enum.RaycastFilterType.Exclude

local function autoEquipWeapon()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if character and character:FindFirstChild("Humanoid") and backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if isRangedWeapon(item) then 
                character.Humanoid:EquipTool(item) 
                task.wait(0.03)
                break 
            end
        end
    end
end

local function autoUnequipWeapon()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:UnequipTools()
        end
    end
end

local function getMurderer()
    local hasDuelEnemies = false
    for _, _ in pairs(duelTeams) do
        hasDuelEnemies = true
        break
    end

    if hasDuelEnemies then
        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local closestEnemy = nil
        local minDistance = math.huge

        for enemyName, _ in pairs(duelTeams) do
            local pl = Players:FindFirstChild(enemyName)
            if pl and pl.Character and pl ~= LocalPlayer then
                local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
                local isDead = (hum and hum.Health <= 0) or (playerDeadStatus[enemyName] == true)

                if not isDead and hrp then
                    local dist = myHrp and (hrp.Position - myHrp.Position).Magnitude or 0
                    if dist < minDistance then
                        minDistance = dist
                        closestEnemy = pl
                    end
                end
            end
        end

        if closestEnemy then
            setTarget(closestEnemy)
            return closestEnemy
        end
    end

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

-- Raycasting Params
local wallCastParams = RaycastParams.new()
wallCastParams.FilterType = Enum.RaycastFilterType.Exclude

local gunCastParams = RaycastParams.new()
gunCastParams.FilterType = Enum.RaycastFilterType.Exclude

local visCastParams = RaycastParams.new()
visCastParams.FilterType = Enum.RaycastFilterType.Exclude

local cachedIgnoreList = {}
local tempIgnoreBuffer = {}

local function updateIgnoreListCache()
    table.clear(cachedIgnoreList)
    if LocalPlayer.Character then table.insert(cachedIgnoreList, LocalPlayer.Character) end
    table.insert(cachedIgnoreList, Camera)
end

KillerHub:AddTask(Players.PlayerAdded:Connect(updateIgnoreListCache))
KillerHub:AddTask(Players.PlayerRemoving:Connect(updateIgnoreListCache))
KillerHub:AddTask(LocalPlayer.CharacterAdded:Connect(function()
    updateIgnoreListCache()
    resetWaitState()
end))
updateIgnoreListCache()

local function isGunBlocked(targetPos, targetChar)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return true end

    local origin = char.HumanoidRootPart.Position
    if char.HumanoidRootPart:FindFirstChild("GunRaycastAttachment") then
        origin = char.HumanoidRootPart.GunRaycastAttachment.WorldPosition
    else
        local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
        if rightHand then origin = rightHand.Position end
    end

    local direction = targetPos - origin
    if direction.Magnitude < 0.1 then return false end

    table.clear(tempIgnoreBuffer)
    for i = 1, #cachedIgnoreList do tempIgnoreBuffer[i] = cachedIgnoreList[i] end
    
    local currentOrigin = origin
    local rayPasses = 0

    while direction.Magnitude > 0.1 and rayPasses < 5 do
        rayPasses = rayPasses + 1
        gunCastParams.FilterDescendantsInstances = tempIgnoreBuffer
        local ray = workspace:Raycast(currentOrigin, direction, gunCastParams)
        if not ray then return false end

        local hitInst = ray.Instance
        if targetChar and hitInst:IsDescendantOf(targetChar) then
            return false
        end

        if hitInst and hitInst.CanCollide and hitInst.Transparency < 0.8 then
            return true
        else
            table.insert(tempIgnoreBuffer, hitInst)
            currentOrigin = ray.Position + (direction.Unit * 0.05)
            direction = targetPos - currentOrigin
        end
    end

    return false
end

local function isStrictlyVisible(targetChar, targetPart)
    if not targetChar or not targetPart then return false end
    local origin = Camera.CFrame.Position
    local targetPos = targetPart.Position
    
    if isGunBlocked(targetPos, targetChar) then return false end

    local direction = targetPos - origin
    table.clear(tempIgnoreBuffer)
    for i = 1, #cachedIgnoreList do tempIgnoreBuffer[i] = cachedIgnoreList[i] end

    local currentOrigin = origin
    local rayPasses = 0

    while direction.Magnitude > 0.1 and rayPasses < 5 do
        rayPasses = rayPasses + 1
        visCastParams.FilterDescendantsInstances = tempIgnoreBuffer
        local ray = workspace:Raycast(currentOrigin, direction, visCastParams)
        if not ray then return true end

        local hitInst = ray.Instance
        if hitInst and hitInst:IsDescendantOf(targetChar) then
            return true
        end

        if hitInst and hitInst.CanCollide and hitInst.Transparency < 0.8 then
            return false
        else
            table.insert(tempIgnoreBuffer, hitInst)
            currentOrigin = ray.Position + (direction.Unit * 0.05)
            direction = targetPos - currentOrigin
        end
    end

    return true
end

local function getSmartTargetPart(targetChar)
    if not targetChar then return nil, true end
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, true end
    
    local wallCheck = Flag("Sheriff_WallCheck", true)
    local shotType = Flag("Sheriff_ShotType", "Normal")

    if not wallCheck or shotType == "Piercer Bullet" then 
        return hrp, false 
    end
    
    local origin = Camera.CFrame.Position
    table.clear(tempIgnoreBuffer)
    for i = 1, #cachedIgnoreList do tempIgnoreBuffer[i] = cachedIgnoreList[i] end

    local targetPos = hrp.Position
    local currentOrigin = origin
    local direction = targetPos - currentOrigin
    local blocked = false
    local rayPasses = 0

    while direction.Magnitude > 0.1 and rayPasses < 5 do
        rayPasses = rayPasses + 1
        wallCastParams.FilterDescendantsInstances = tempIgnoreBuffer
        local ray = workspace:Raycast(currentOrigin, direction, wallCastParams)
        if not ray then break end

        local hitInst = ray.Instance
        if hitInst and hitInst:IsDescendantOf(targetChar) then
            break
        end

        if hitInst and hitInst.CanCollide and hitInst.Transparency < 0.8 then
            blocked = true
            break 
        else
            table.insert(tempIgnoreBuffer, hitInst)
            currentOrigin = ray.Position + (direction.Unit * 0.05)
            direction = targetPos - currentOrigin
        end
    end

    if not blocked and isGunBlocked(targetPos, targetChar) then
        blocked = true
    end

    return hrp, blocked
end

local function getFloorHeight(targetHrp, targetChar)
    if not targetHrp then return nil end
    floorCastParams.FilterDescendantsInstances = {targetChar, LocalPlayer.Character, Camera}
    local ray = workspace:Raycast(targetHrp.Position, vec3New(0, -25, 0), floorCastParams)
    return ray and ray.Position.Y or nil
end

-- Prediction Engine
local function getPredictedPosition(targetChar, targetPart, customDelta)
    if not targetChar or not targetPart then return nil, nil, nil, nil, nil end
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid or humanoid.Health <= 0 then return nil, nil, nil, nil, nil end

    local activeDT = customDelta or emaDeltaTime
    local targetPosition = targetPart.Position

    local referencePos = Camera and Camera.CFrame.Position or targetPosition
    local distance = (targetPosition - referencePos).Magnitude

    local moveMag = humanoid.MoveDirection.Magnitude
    local rawPhysicsVel = hrp.AssemblyLinearVelocity
    local walkSpeed = (humanoid.WalkSpeed > 0) and humanoid.WalkSpeed or 16

    -- Detector de Desplazamiento Real (Anti-Lag & Anti-Exploit Falsos Positivos)
    local calculatedVelY = rawPhysicsVel.Y
    local realDisplacementSpeed = 0
    local lastData = lastPositions[targetChar]
    local now = os_clock()
    
    if not lastData then
        lastData = {Pos = hrp.Position, Time = now, RealSpeed = 0}
        lastPositions[targetChar] = lastData
    else
        local dtPrev = now - lastData.Time
        if dtPrev > 0.008 then
            local distMoved = (hrp.Position - lastData.Pos).Magnitude
            realDisplacementSpeed = distMoved / dtPrev
            lastData.RealSpeed = realDisplacementSpeed
            
            local realYVel = (hrp.Position.Y - lastData.Pos.Y) / dtPrev
            if math_abs(realYVel) > 0.5 then calculatedVelY = realYVel end
        else
            realDisplacementSpeed = lastData.RealSpeed or 0
        end
        lastData.Pos = hrp.Position
        lastData.Time = now
    end

    local isDesynced = (realDisplacementSpeed < 1.2 and (rawPhysicsVel.Magnitude > 3 or moveMag > 0.1))

    local actualPhysicsH = vec3New(rawPhysicsVel.X, 0, rawPhysicsVel.Z)
    local realSpeedH = actualPhysicsH.Magnitude

    local effectiveSpeed = math_min(realSpeedH, walkSpeed)
    local intendedVel = vec3New(humanoid.MoveDirection.X * effectiveSpeed, 0, humanoid.MoveDirection.Z * effectiveSpeed)

    local speedRatio = math_clamp(realSpeedH / math_max(walkSpeed, 1), 0, 1)
    local rawVelocity = actualPhysicsH:Lerp(intendedVel, speedRatio)

    if isDesynced then
        rawVelocity = VECTOR_ZERO
        smoothedVelocity = VECTOR_ZERO
    elseif smoothedVelocity.Magnitude > 0.5 and rawVelocity.Magnitude > 0.5 then
        local dotProduct = smoothedVelocity.Unit:Dot(rawVelocity.Unit)
        if dotProduct < 0.85 then
            local dampingFactor = math_clamp((dotProduct + 1) / 1.85, 0.25, 1.0)
            rawVelocity = rawVelocity * dampingFactor
        end
    end

    local closeZone = Flag("Sheriff_CloseRange", 6)
    local predictionWeight = distance <= closeZone and 0 or 1

    if lastTargetChar ~= targetChar then
        smoothedVelocity = rawVelocity 
        smoothedVisualY = 0
        lastTargetChar = targetChar
    end

    local isStopping = (moveMag < 0.1 and rawVelocity.Magnitude < 2)
    local isStarting = (moveMag > 0.1 and smoothedVelocity.Magnitude < 2)

    -- Inertial Stabilizer Nativo (Adaptativo según FPS)
    local vSmoothAlpha = 0.35
    if isStopping then 
        vSmoothAlpha = 0.80
    elseif isStarting then 
        vSmoothAlpha = 0.15
    else 
        vSmoothAlpha = math_clamp(14 * activeDT, 0.18, 0.50) 
    end
    
    smoothedVelocity = smoothedVelocity:Lerp(rawVelocity, vSmoothAlpha)
    if (isStopping or isDesynced) and smoothedVelocity.Magnitude < 0.3 then smoothedVelocity = VECTOR_ZERO end

    local horizontalShift = VECTOR_ZERO
    local verticalShift = VECTOR_ZERO

    local prioritizePing = Flag("Sheriff_PrioritizePing", false)
    local vScale = Flag("Sheriff_VScale", 100)
    local hScale = Flag("Sheriff_HScale", 100)

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

    horizontalShift = vec3New(smoothedVelocity.X, 0, smoothedVelocity.Z) * effectiveHLatency * predictionWeight

    if vScale > 0 and not isDesynced then
        local isAir = (humanoid.FloorMaterial == Enum.Material.Air)
        local isStairMovement = (not isAir and math_abs(calculatedVelY) > 0.8)

        if isAir or isStairMovement then
            local adaptiveYFactor = math_clamp((distance - closeZone) / 12, 0, 1)
            local vFactor = effectiveVLatency * adaptiveYFactor

            if isAir then
                if calculatedVelY < -0.5 then
                    local fallSpeed = math_max(calculatedVelY, -18)
                    local fallingYFactor = fallSpeed * 0.30 * vFactor
                    verticalShift = vec3New(0, fallingYFactor, 0)
                else
                    local gravityEffect = 0.5 * workspace_Gravity * math_pow(vFactor, 2)
                    local pY = (calculatedVelY * vFactor) - gravityEffect
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
    local predXYExaggerated = targetPosition + (horizontalShift * 1.8) + verticalShift
    
    -- Filtro de Suavizado Vertical Exponencial para Lead Time Prediction (3.6x)
    local rawVisualY = math_clamp(verticalShift.Y * 3.6, -14, 14)
    local yLerpAlpha = math_clamp(12 * activeDT, 0.08, 0.28)
    smoothedVisualY = smoothedVisualY + (rawVisualY - smoothedVisualY) * yLerpAlpha

    local finalPred36X = targetPosition + (horizontalShift * 3.6) + vec3New(0, smoothedVisualY, 0)

    local floorY = getFloorHeight(hrp, targetChar)
    if floorY then
        local minAllowedY = floorY + (hrp.Size.Y / 2) + 0.15
        if finalPredWithY.Y < minAllowedY then finalPredWithY = vec3New(finalPredWithY.X, minAllowedY, finalPredWithY.Z) end
        if predXYExaggerated.Y < minAllowedY then predXYExaggerated = vec3New(predXYExaggerated.X, minAllowedY, predXYExaggerated.Z) end
        if finalPred36X.Y < minAllowedY then finalPred36X = vec3New(finalPred36X.X, minAllowedY, finalPred36X.Z) end
    end

    return finalPredWithY, finalPredNoY, minPredNoY, predXYExaggerated, finalPred36X
end

-- Tracers Render Setup
local MinPredictionLine = Drawing.new("Line")
MinPredictionLine.Color = color3RGB(4, 0, 220); MinPredictionLine.Thickness = 2.0; MinPredictionLine.Transparency = 1.0; MinPredictionLine.ZIndex = 5

local PredictionLine = Drawing.new("Line")
PredictionLine.Color = color3RGB(255, 35, 35); PredictionLine.Thickness = 2.0; PredictionLine.Transparency = 1.0; PredictionLine.ZIndex = 10

local LeadTimeLine = Drawing.new("Line")
LeadTimeLine.Color = color3RGB(35, 255, 35); LeadTimeLine.Thickness = 1.8; LeadTimeLine.Transparency = 1.0; LeadTimeLine.ZIndex = 7

local LeadTimePredLine = Drawing.new("Line")
LeadTimePredLine.Color = color3RGB(35, 255, 35); LeadTimePredLine.Thickness = 1.8; LeadTimePredLine.Transparency = 1.0; LeadTimePredLine.ZIndex = 8

local ConfirmWallLine = Drawing.new("Line")
ConfirmWallLine.Color = color3RGB(0, 0, 0); ConfirmWallLine.Thickness = 2.0; ConfirmWallLine.Transparency = 1.0; ConfirmWallLine.ZIndex = 8

local PredictionXYLine = Drawing.new("Line")
PredictionXYLine.Color = color3RGB(170, 0, 255); PredictionXYLine.Thickness = 2.0; PredictionXYLine.Transparency = 1.0; PredictionXYLine.ZIndex = 9

table.insert(_G.KillerHubLines, MinPredictionLine)
table.insert(_G.KillerHubLines, PredictionLine)
table.insert(_G.KillerHubLines, LeadTimeLine)
table.insert(_G.KillerHubLines, LeadTimePredLine)
table.insert(_G.KillerHubLines, ConfirmWallLine)
table.insert(_G.KillerHubLines, PredictionXYLine)

local worldToViewport = Camera.WorldToViewportPoint

local renderConn = RunService.RenderStepped:Connect(function(dt)
    emaDeltaTime = emaDeltaTime + 0.2 * (dt - emaDeltaTime) 

    local murderer = getMurderer()
    if not murderer or not murderer.Character then
        PredictionLine.Visible = false
        MinPredictionLine.Visible = false
        LeadTimeLine.Visible = false
        LeadTimePredLine.Visible = false
        ConfirmWallLine.Visible = false
        PredictionXYLine.Visible = false
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
    local showLeadPred = tracersTable["Lead Time Prediction"] == true
    local showConfirmWall = tracersTable["Confirm wall check"] == true
    local showXYOffset = tracersTable["Prediction X/Y offset"] == true

    if visualPart then
        local _, predNoY, minPredNoY, predXYExaggerated, finalPred36X = getPredictedPosition(targetChar, visualPart, dt)
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

            if showLeadPred and finalPred36X then
                local screenPos, onScreen = worldToViewport(Camera, finalPred36X)
                if onScreen then
                    LeadTimePredLine.From = screenOrigin
                    LeadTimePredLine.To = vec2New(screenPos.X, screenPos.Y)
                    LeadTimePredLine.Visible = true
                else LeadTimePredLine.Visible = false end
            else LeadTimePredLine.Visible = false end

            if showXYOffset and predXYExaggerated then
                local screenPos, onScreen = worldToViewport(Camera, predXYExaggerated)
                if onScreen then
                    PredictionXYLine.From = screenOrigin
                    PredictionXYLine.To = vec2New(screenPos.X, screenPos.Y)
                    PredictionXYLine.Visible = true
                else PredictionXYLine.Visible = false end
            else PredictionXYLine.Visible = false end

            if rightHand and showGreen then
                local targetPosForLead = showLeadPred and finalPred36X or predNoY
                if targetPosForLead then
                    local handScreenPos, handOnScreen = worldToViewport(Camera, rightHand.Position)
                    local predScreenPos, predOnScreen = worldToViewport(Camera, targetPosForLead)

                    if handOnScreen and predOnScreen then
                        LeadTimeLine.Color = color3RGB(35, 255, 35)
                        LeadTimeLine.From = vec2New(handScreenPos.X, handScreenPos.Y)
                        LeadTimeLine.To = vec2New(predScreenPos.X, predScreenPos.Y)
                        LeadTimeLine.Visible = true
                    else LeadTimeLine.Visible = false end
                else LeadTimeLine.Visible = false end
            else LeadTimeLine.Visible = false end
        end

        if showConfirmWall and myChar and myChar:FindFirstChild("HumanoidRootPart") then
            local myHrp = myChar.HumanoidRootPart
            local myScreenPos, myOnScreen = worldToViewport(Camera, myHrp.Position)
            local targetScreenPos, targetOnScreen = worldToViewport(Camera, visualPart.Position)

            if myOnScreen and targetOnScreen then
                ConfirmWallLine.From = vec2New(myScreenPos.X, myScreenPos.Y)
                ConfirmWallLine.To = vec2New(targetScreenPos.X, targetScreenPos.Y)
                if isBlocked then
                    ConfirmWallLine.Color = color3RGB(0, 0, 0)
                else
                    ConfirmWallLine.Color = color3RGB(130, 35, 190)
                end
                ConfirmWallLine.Visible = true
            else
                ConfirmWallLine.Visible = false
            end
        else
            ConfirmWallLine.Visible = false
        end
    else
        PredictionLine.Visible = false
        MinPredictionLine.Visible = false
        LeadTimeLine.Visible = false
        LeadTimePredLine.Visible = false
        ConfirmWallLine.Visible = false
        PredictionXYLine.Visible = false
    end 
end)
KillerHub:AddTask(renderConn)

-- Core Shoot Handler
local executeActualShoot

local function startWaitingForSight(initialTarget)
    resetWaitState()

    local gun, _ = getGunLocation()
    if not gun then return end

    isWaitingForSight = true

    if DecalTexture then
        TweenService:Create(DecalTexture, tweenInfoFast, {Position = udim2New(0.5, 0, 0.28, 0), Size = udim2New(0.38, 0, 0.38, 0)}):Play()
    end
    if Label then
        TweenService:Create(Label, tweenInfoFast, {Position = udim2New(0, 0, 0.52, 0), Size = udim2New(1, 0, 0.2, 0)}):Play()
        Label.Text = "WAITING..."
        Label.TextColor3 = color3RGB(255, 50, 50)
    end

    local maxWaitTime = Flag("Sheriff_WaitTime", 15)
    local startTime = os_clock()
    local lostSightCounter = 0 

    waitSightThread = task.spawn(function()
        while isWaitingForSight do
            local currentGun, _ = getGunLocation()
            if not currentGun then
                resetWaitState()
                break
            end

            local elapsed = os_clock() - startTime
            local remaining = maxWaitTime - elapsed

            if remaining <= 0 then
                resetWaitState()
                break
            end

            if SubLabel then
                SubLabel.Text = string.format("%.1fs", math_max(0, remaining))
            end

            local murderer = getMurderer()
            if not murderer or not murderer.Character then
                lostSightCounter = lostSightCounter + 0.016
                if lostSightCounter > 0.15 then
                    resetWaitState()
                    break
                end
            else
                local targetChar = murderer.Character
                local hum = targetChar:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then
                    resetWaitState()
                    break
                end

                local shotType = Flag("Sheriff_ShotType", "Normal")
                local bestPart, isBlocked = getSmartTargetPart(targetChar)

                if bestPart and (not isBlocked or shotType == "Piercer Bullet") then
                    resetWaitState()
                    executeActualShoot(targetChar, bestPart)
                    break
                end
            end

            RunService.RenderStepped:Wait()
        end
    end)
end

executeActualShoot = function(targetChar, bestPart)
    local shotType = Flag("Sheriff_ShotType", "Normal")
    local wallCheck = Flag("Sheriff_WallCheck", true)
    local char = LocalPlayer.Character
    if not char then return end

    local gun, _ = getGunLocation()
    if not gun then return end

    local finalPredictedPos = getPredictedPosition(targetChar, bestPart)
    if finalPredictedPos then
        if wallCheck and shotType ~= "Piercer Bullet" then
            if isGunBlocked(finalPredictedPos, targetChar) then
                return
            end
        end

        autoEquipWeapon()
        
        local activeGun, _ = getGunLocation()
        if activeGun and activeGun:FindFirstChild("Shoot") then
            local originCFrame = char.HumanoidRootPart and char.HumanoidRootPart.CFrame or Camera.CFrame
            if char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("GunRaycastAttachment") then 
                originCFrame = char.HumanoidRootPart.GunRaycastAttachment.WorldCFrame 
            end

            if shotType == "Piercer Bullet" then
                local camLook = Camera.CFrame.LookVector
                local horizDir = vec3New(camLook.X, 0, camLook.Z)
                
                if horizDir.Magnitude < 0.01 then
                    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                    if hrp then horizDir = vec3New(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z) end
                end
                
                if horizDir.Magnitude < 0.01 then
                    horizDir = vec3New(1, 0, 0)
                else
                    horizDir = horizDir.Unit
                end

                local spawnOrigin = finalPredictedPos - (horizDir * 1.5)
                originCFrame = cframeNew(spawnOrigin, finalPredictedPos)
            end

            activeGun.Shoot:FireServer(originCFrame, cframeNew(finalPredictedPos))

            if Flag("Sheriff_UnEquipGun", false) then
                task.delay(0.20, autoUnequipWeapon)
            end
        end
    end
end

local function fireAtMurdererDirectly()
    local cancelOnClick = Flag("Sheriff_CancelOnClick", false)
    if isWaitingForSight then
        if cancelOnClick then
            resetWaitState()
            return
        end
    end

    local gun, _ = getGunLocation()
    if not gun then
        if isWaitingForSight then resetWaitState() end
        return
    end

    local shotType = Flag("Sheriff_ShotType", "Normal")
    local wallCheck = Flag("Sheriff_WallCheck", true)
    local waitSight = Flag("Sheriff_WaitSight", false)
    
    local murderer = getMurderer()
    if murderer and murderer.Character then
        local targetChar = murderer.Character
        local bestPart, isBlocked = getSmartTargetPart(targetChar) 
        
        local allowWaitSight = waitSight and (shotType ~= "Piercer Bullet")

        if wallCheck and isBlocked and shotType ~= "Piercer Bullet" then
            if isWaitingForSight then
                return
            end
            if allowWaitSight then
                startWaitingForSight(targetChar)
            end
            return
        end

        if isWaitingForSight then
            resetWaitState()
        end

        if bestPart then
            executeActualShoot(targetChar, bestPart)
        end
    end
end

-- Auto Shoot Engine
local lastAutoShootTime = 0
local autoShootConn = RunService.Heartbeat:Connect(function()
    if not Flag("Sheriff_AutoShoot", false) then return end

    local now = os_clock()
    if now - lastAutoShootTime < 0.18 then return end

    local gun, _ = getGunLocation()
    if not gun then return end

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

local tweenRot = TweenService:Create(UiGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
tweenRot:Play()
KillerHub:AddTask(tweenRot)

DecalTexture = Instance.new("ImageLabel")
DecalTexture.Name = "CrosshairDecal"
DecalTexture.Size = udim2New(0.38, 0, 0.38, 0)
DecalTexture.AnchorPoint = vec2New(0.5, 0.5)
DecalTexture.Position = udim2New(0.5, 0, 0.44, 0)
DecalTexture.BackgroundTransparency = 1
DecalTexture.Image = "rbxassetid://125754446555599"
DecalTexture.ZIndex = ShootButton.ZIndex + 2; DecalTexture.Parent = ShootButton

local tiLoop = TweenInfo.new(0.80, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local rotAnim = TweenService:Create(DecalTexture, tiLoop, {Rotation = 360})
rotAnim:Play()
KillerHub:AddTask(rotAnim)

Label = Instance.new("TextLabel")
Label.Name = "ShootLabel"
Label.Size = udim2New(1, 0, 0.2, 0)
Label.Position = udim2New(0, 0, 0.75, 0)
Label.BackgroundTransparency = 1
Label.Text = "SHOOT"; Label.TextColor3 = color3RGB(255, 255, 255); Label.TextSize = 14; Label.Font = Enum.Font.GothamBold
Label.TextScaled = true; Label.ZIndex = ShootButton.ZIndex + 2; Label.Parent = ShootButton

local LabelConstraint = Instance.new("UITextSizeConstraint")
LabelConstraint.MaxTextSize = 15; LabelConstraint.MinTextSize = 8; LabelConstraint.Parent = Label

SubLabel = Instance.new("TextLabel")
SubLabel.Name = "SubTimerLabel"
SubLabel.Size = udim2New(1, 0, 0.18, 0)
SubLabel.Position = udim2New(0, 0, 0.74, 0)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = ""; SubLabel.TextColor3 = color3RGB(255, 255, 255); SubLabel.TextSize = 12; SubLabel.Font = Enum.Font.GothamBold
SubLabel.TextScaled = true; SubLabel.ZIndex = ShootButton.ZIndex + 2; SubLabel.Parent = ShootButton -- <--- CORREGIDO

local SubConstraint = Instance.new("UITextSizeConstraint")
SubConstraint.MaxTextSize = 13; SubConstraint.MinTextSize = 7; SubConstraint.Parent = SubLabel

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
