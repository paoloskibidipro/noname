-- ============================================================================
-- 👻 KILLER HUB - MM2 ADVANCED VISUAL SUITE (WITH DUELS ESP SUPPORT V4.5)
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

-- Default Game Roles Colors
local DefaultColors = {
    Murderer     = Color3_fromRGB(180, 55, 55),
    Sheriff      = Color3_fromRGB(35, 102, 204),
    Hero         = Color3_fromRGB(230, 188, 62),
    Innocent     = Color3_fromRGB(26, 171, 81),
    Dead         = Color3_fromRGB(115, 115, 115),
    GunDrop      = Color3_fromRGB(255, 0, 0),
    DuelEnemy    = Color3_fromRGB(255, 40, 40),  -- Rojo para rivales
    DuelTeammate = Color3_fromRGB(40, 140, 255)  -- Azul para nuestro equipo
}

-- [1] CONFIGURATION TABLE
local Config = { 
    -- NORMAL ESP
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

    -- DUELS ESP CONFIG
    DuelHighlight = false,
    DuelHighlightTrans = 50,
    DuelHighlightRoles = {["Enemy"] = true, ["Teammate"] = false},

    DuelLimbChams = false,
    DuelLimbChamsTrans = 50,
    DuelLimbChamsRoles = {["Enemy"] = true, ["Teammate"] = false},

    DuelBox = false,
    DuelBoxRoles = {["Enemy"] = true, ["Teammate"] = false},

    DuelName = false,
    DuelNameRoles = {["Enemy"] = true, ["Teammate"] = false},

    DuelTracer = false,
    DuelTracerRoles = {["Enemy"] = true, ["Teammate"] = false},

    -- GENERAL & DROPPED GUN
    GunCham = false,    
    GunName = false,    
    GunTracer = false, 
    NameSize = 13,      
    GunNameSize = 14,
    MaxDistance = 400,
    
    CustomColorsActive = {
        ["Murderer"] = false, ["Sheriff"] = false, ["Hero"] = false, ["Innocent"] = false, 
        ["Dead/None"] = false, ["GunDrop"] = false, ["DuelEnemy"] = false, ["DuelTeammate"] = false
    },
    CustomColorsRGB = {
        ["Murderer"]     = {180, 55, 55},
        ["Sheriff"]      = {35, 102, 204},
        ["Hero"]         = {230, 188, 62},
        ["Innocent"]     = {26, 171, 81},
        ["Dead/None"]    = {115, 115, 115},
        ["GunDrop"]      = {255, 0, 0},
        ["DuelEnemy"]    = {255, 40, 40},
        ["DuelTeammate"] = {40, 140, 255}
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

local VisualsTab  = KillerHub:CreateTab("Visuals", "rbxassetid://6523858394")
local PagePlayers = VisualsTab:CreatePage("Players ESP", "Eye")
local PageDuels   = VisualsTab:CreatePage("Duels ESP", "Sword")

-- ==========================================
-- PAGE 1: PLAYERS ESP (MODO NORMAL)
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
    Config.TracerPosition = sel; saveConfig()
end, Config.TracerPosition or "Bottom Center")

PagePlayers:CreateMultiDropdown("TracerFilters", "Roles", {"Murderer", "Sheriff", "Hero", "Innocent", "Dead/None"}, function(flags)
    for r, _ in pairs(Config.TracerRoles) do Config.TracerRoles[r] = flags[r] == true end; saveConfig()
end)

PagePlayers:CreateSection("Dropped Gun ESP")
local ToggleGunCham   = PagePlayers:CreateToggle("EspGunCham", "Gun Cham", function(val) Config.GunCham = val; saveConfig() end)
local ToggleGunName   = PagePlayers:CreateToggle("EspGunName", "Gun Name", function(val) Config.GunName = val; saveConfig() end)
local ToggleGunTracer = PagePlayers:CreateToggle("EspGunTracer", "Gun Tracer", function(val) Config.GunTracer = val; saveConfig() end)

PagePlayers:CreateSection("Role Colors Customization")
local function createRoleColorPicker(page, roleKey, visualName)
    local defaultRGB = Config.CustomColorsRGB[roleKey]
    local defaultColor3 = Color3_fromRGB(defaultRGB[1], defaultRGB[2], defaultRGB[3])
    
    page:CreateToggleColorPicker(
        "CP_Active_" .. roleKey, "CP_Color_" .. roleKey, visualName, defaultColor3,
        function(estado) Config.CustomColorsActive[roleKey] = estado; saveConfig() end,
        function(colorSeleccionado)
            Config.CustomColorsRGB[roleKey] = {math_floor(colorSeleccionado.R * 255), math_floor(colorSeleccionado.G * 255), math_floor(colorSeleccionado.B * 255)}
            saveConfig()
        end
    )
end

createRoleColorPicker(PagePlayers, "Murderer", "Murderer")
createRoleColorPicker(PagePlayers, "Sheriff", "Sheriff")
createRoleColorPicker(PagePlayers, "Hero", "Hero")
createRoleColorPicker(PagePlayers, "Innocent", "Innocent")
createRoleColorPicker(PagePlayers, "Dead/None", "Dead / Spectators")
createRoleColorPicker(PagePlayers, "GunDrop", "Dropped Gun")

PagePlayers:CreateSection("Settings & Performance")
local DistanceInput = PagePlayers:CreateInput("EspMaxDistance", "Max Render Distance (Studs)", "400", function(val)
    local num = tonumber(val)
    if num then Config.MaxDistance = math_abs(num); saveConfig()
    else KillerHub:NotifyWarn("Invalid Input", "Please enter numbers only.", 3) end
end)
local NameSizeSlider = PagePlayers:CreateSlider("EspNameSize", "Name Size", 10, 30, function(val) Config.NameSize = math_floor(val); saveConfig() end)
local GunNameSizeSlider = PagePlayers:CreateSlider("EspGunNameSize", "Gun Name Size", 10, 30, function(val) Config.GunNameSize = math_floor(val); saveConfig() end)

-- ==========================================
-- PAGE 2: DUELS ESP (MODO DUELOS)
-- ==========================================
PageDuels:CreateSection("Duels ESP Options")

local ToggleDuelHighlight = PageDuels:CreateToggleSlider("DuelEspHighlight", "DuelEspHighlightTrans", "Highlight ESP", 0, 100, 
    function(val) Config.DuelHighlight = val; saveConfig() end,
    function(val) Config.DuelHighlightTrans = math_floor(val); saveConfig() end
)
PageDuels:CreateMultiDropdown("DuelHighlightFilters", "Teams Filter", {"Enemy", "Teammate"}, function(flags)
    for r, _ in pairs(Config.DuelHighlightRoles) do Config.DuelHighlightRoles[r] = flags[r] == true end; saveConfig()
end)

local ToggleDuelLimbChams = PageDuels:CreateToggleSlider("DuelEspLimbChams", "DuelEspLimbChamsTrans", "Cham ESP", 0, 100, 
    function(val) Config.DuelLimbChams = val; saveConfig() end,
    function(val) Config.DuelLimbChamsTrans = math_floor(val); saveConfig() end
)
PageDuels:CreateMultiDropdown("DuelLimbChamsFilters", "Teams Filter", {"Enemy", "Teammate"}, function(flags)
    for r, _ in pairs(Config.DuelLimbChamsRoles) do Config.DuelLimbChamsRoles[r] = flags[r] == true end; saveConfig()
end)

local ToggleDuelBox = PageDuels:CreateToggle("DuelEspBox", "Box ESP", function(val) Config.DuelBox = val; saveConfig() end)
PageDuels:CreateMultiDropdown("DuelBoxFilters", "Teams Filter", {"Enemy", "Teammate"}, function(flags)
    for r, _ in pairs(Config.DuelBoxRoles) do Config.DuelBoxRoles[r] = flags[r] == true end; saveConfig()
end)

local ToggleDuelName = PageDuels:CreateToggle("DuelEspName", "Name ESP", function(val) Config.DuelName = val; saveConfig() end)
PageDuels:CreateMultiDropdown("DuelNameFilters", "Teams Filter", {"Enemy", "Teammate"}, function(flags)
    for r, _ in pairs(Config.DuelNameRoles) do Config.DuelNameRoles[r] = flags[r] == true end; saveConfig()
end)

local ToggleDuelTracer = PageDuels:CreateToggle("DuelEspTracer", "Tracer ESP", function(val) Config.DuelTracer = val; saveConfig() end)
PageDuels:CreateMultiDropdown("DuelTracerFilters", "Teams Filter", {"Enemy", "Teammate"}, function(flags)
    for r, _ in pairs(Config.DuelTracerRoles) do Config.DuelTracerRoles[r] = flags[r] == true end; saveConfig()
end)

PageDuels:CreateSection("Duels Team Colors")
createRoleColorPicker(PageDuels, "DuelEnemy", "Enemy Team (Rival)")
createRoleColorPicker(PageDuels, "DuelTeammate", "Our Team (Teammate)")

-- [4] APPLY SAVED CONFIGURATIONS SAFELY
ToggleName:Set(Config.Name)
ToggleTracer:Set(Config.Tracer)
ToggleGunCham:Set(Config.GunCham); ToggleGunName:Set(Config.GunName); ToggleGunTracer:Set(Config.GunTracer); NameSizeSlider:Set(Config.NameSize); GunNameSizeSlider:Set(Config.GunNameSize)
ToggleBox:Set(Config.Box)

if ToggleHighlight then ToggleHighlight:SetToggle(Config.Highlight); ToggleHighlight:SetSlider(Config.HighlightTrans) end
if ToggleLimbChams then ToggleLimbChams:SetToggle(Config.LimbChams); ToggleLimbChams:SetSlider(Config.LimbChamsTrans) end

if ToggleDuelHighlight then ToggleDuelHighlight:SetToggle(Config.DuelHighlight); ToggleDuelHighlight:SetSlider(Config.DuelHighlightTrans) end
if ToggleDuelLimbChams then ToggleDuelLimbChams:SetToggle(Config.DuelLimbChams); ToggleDuelLimbChams:SetSlider(Config.DuelLimbChamsTrans) end
if ToggleDuelBox then ToggleDuelBox:Set(Config.DuelBox) end
if ToggleDuelName then ToggleDuelName:Set(Config.DuelName) end
if ToggleDuelTracer then ToggleDuelTracer:Set(Config.DuelTracer) end

-- ============================================================================
-- 🧠 CORE ENGINE (ULTRA-OPTIMIZED V4.5 WITH DUEL DETECTION)
-- ============================================================================

local playerRoles = {} 
local playerDeadStatus = {} 
local currentGunDrop = nil 

-- Sistema de Duelos Inteligente
local isDuelActive = false
local duelRivals = {}
local duelTeammates = {}

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
    local char = player.Character
    local name = player.Name
    
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local isDeadInGame = not char or not humanoid or humanoid.Health <= 0
    local isDeadInNetwork = playerDeadStatus[name] == true

    if isDeadInGame or isDeadInNetwork then
        return getRoleColor("Dead/None", DefaultColors.Dead), "Dead/None"
    end

    -- ⚔️ DETECCIÓN DE DUELOS INTEGRA
    if isDuelActive then
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local isTeammate = duelTeammates[name] or (root and root:FindFirstChild("TeamMate") ~= nil)
        
        if isTeammate then
            return getRoleColor("DuelTeammate", DefaultColors.DuelTeammate), "DuelTeammate"
        else
            return getRoleColor("DuelEnemy", DefaultColors.DuelEnemy), "DuelEnemy"
        end
    end

    -- 🕵️ MODO MM2 NORMAL
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

local function isEspEnabledForRole(espType, status)
    if status == "DuelEnemy" then
        return Config.DuelHighlightRoles and (
            (espType == "Highlight" and Config.DuelHighlight and Config.DuelHighlightRoles["Enemy"]) or
            (espType == "LimbChams" and Config.DuelLimbChams and Config.DuelLimbChamsRoles["Enemy"]) or
            (espType == "Box" and Config.DuelBox and Config.DuelBoxRoles["Enemy"]) or
            (espType == "Name" and Config.DuelName and Config.DuelNameRoles["Enemy"]) or
            (espType == "Tracer" and Config.DuelTracer and Config.DuelTracerRoles["Enemy"])
        )
    elseif status == "DuelTeammate" then
        return Config.DuelHighlightRoles and (
            (espType == "Highlight" and Config.DuelHighlight and Config.DuelHighlightRoles["Teammate"]) or
            (espType == "LimbChams" and Config.DuelLimbChams and Config.DuelLimbChamsRoles["Teammate"]) or
            (espType == "Box" and Config.DuelBox and Config.DuelBoxRoles["Teammate"]) or
            (espType == "Name" and Config.DuelName and Config.DuelNameRoles["Teammate"]) or
            (espType == "Tracer" and Config.DuelTracer and Config.DuelTracerRoles["Teammate"])
        )
    else
        if espType == "Highlight" then return Config.Highlight and Config.HighlightRoles[status] == true end
        if espType == "LimbChams" then return Config.LimbChams and Config.LimbChamsRoles[status] == true end
        if espType == "Box" then return Config.Box and Config.BoxRoles[status] == true end
        if espType == "Name" then return Config.Name and Config.NameRoles[status] == true end
        if espType == "Tracer" then return Config.Tracer and Config.TracerRoles[status] == true end
    end
    return false
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
    if isEspEnabledForRole("LimbChams", currentStatus) then
        if not limbFolder then
            limbFolder = Instance_new("Folder")
            limbFolder.Name = "KH_LimbChams"
            limbFolder.Parent = char
        end
        
        local currentTrans = (isDuelActive and Config.DuelLimbChamsTrans or Config.LimbChamsTrans) / 100
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
    if isEspEnabledForRole("Box", currentStatus) then
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
    if isEspEnabledForRole("Name", currentStatus) then
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
    local allowHighlight = isEspEnabledForRole("Highlight", currentStatus)

    if allowHighlight then
        if not hl then
            hl = Instance_new("Highlight"); hl.Name = "KH_Highlight"; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = char
        end
        hl.Adornee = char
        hl.FillColor = color
        hl.FillTransparency = (isDuelActive and Config.DuelHighlightTrans or Config.HighlightTrans) / 100 
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
-- 📡 EVENTS & REMOTES LISTENERS (MM2 STANDARD + DUELS)
-- ============================================================================
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
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
        isDuelActive = false
        table.clear(playerRoles); table.clear(playerDeadStatus); table.clear(duelRivals); table.clear(duelTeammates); currentGunDrop = nil
        local allPlayers = playersGetPlayers(Players)
        for i = 1, #allPlayers do 
            local plr = allPlayers[i]
            if plr and plr.Character then clearPlayerESP(plr.Character) end 
        end
    end)
end

-- DETECCIÓN DE EVENTOS DE DUELOS MM2
if Remotes then
    local CustomGames = Remotes:FindFirstChild("CustomGames")
    local Gameplay = Remotes:FindFirstChild("Gameplay")

    if CustomGames and CustomGames:FindFirstChild("DuelStarted") then
        CustomGames.DuelStarted.OnClientEvent:Connect(function(duelData)
            table.clear(duelRivals)
            table.clear(duelTeammates)
            isDuelActive = true

            if type(duelData) == "table" then
                local myName = LocalPlayer.Name
                local myTeamKey = (duelData.Team1 and duelData.Team1[myName]) and "Team1" or ((duelData.Team2 and duelData.Team2[myName]) and "Team2" or nil)
                
                if myTeamKey then
                    local rivalTeamKey = (myTeamKey == "Team1") and "Team2" or "Team1"
                    if duelData[myTeamKey] then
                        for name, _ in pairs(duelData[myTeamKey]) do
                            if name ~= myName then duelTeammates[name] = true end
                        end
                    end
                    if duelData[rivalTeamKey] then
                        for name, _ in pairs(duelData[rivalTeamKey]) do
                            duelRivals[name] = true
                        end
                    end
                end
            end
        end)
    end

    if Gameplay and Gameplay:FindFirstChild("RoundEndFade") then
        Gameplay.RoundEndFade.OnClientEvent:Connect(function()
            isDuelActive = false
            table.clear(duelRivals)
            table.clear(duelTeammates)
        end)
    end
end

Players.PlayerRemoving:Connect(function(player)
    playerRoles[player.Name] = nil; playerDeadStatus[player.Name] = nil
    duelRivals[player.Name] = nil; duelTeammates[player.Name] = nil
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
        updateGunESP()
        task.wait(0.15)
    end
end)

-- DYNAMIC TRACER ORIGIN RESOLVER
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

-- RENDER STEPPED (TRACERS ENGINE)
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
                    if distance <= Config.MaxDistance then
                        local color, currentStatus = getPlayerColorAndStatus(player)
                        if isEspEnabledForRole("Tracer", currentStatus) then
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
    end
end)

return KillerHub
