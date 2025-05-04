EsoRpLetters = {}
EsoRpLetters.name = "ESO_RP_Letters"

local logger = LibDebugLogger(EsoRpLetters.name)  -- Initialize logger here
local menuSceneName = "EsoRpLetters"  -- Define the scene name
local menuScene -- We'll initialize this after the addon is loaded
local LMM2  -- We'll initialize this after the addon is loaded
local bookPanel
local bg
local label
local list
local mainControl
local items
local scrollData 
local panelInitialized = false

-- This function creates a button in the Game Menu Bar
function EsoRpLetters.CreateGameMenuButton()
    logger:Info("Creating game menu button")

    -- Initialize librarys and needed high scope vairables
    LMM2 = LibMainMenu2
    LMM2:Init()

    -- Ensure LMM2 is initialized before proceeding
    if not LMM2 then
        logger:Error("LibMainMenu2 is not initialized.")
        return
    end

    -- Button category layout information
    local categoryLayoutInfo =
    {
        binding = "TOGGLE_ESO_RP_LETTERS",
        categoryName = STRID_ESO_RP_LETTERS_DISPLAY,
        callback = function(buttonData)
            if not SCENE_MANAGER:IsShowing(menuSceneName) then
                SCENE_MANAGER:Show(menuSceneName)
            end
        end,
        visible = function(buttonData) return true end,
    
        normal = "/esoui/art/icons/housing_bre_inc_book_closed002.dds",
        pressed = "/esoui/art/icons/housing_bre_inc_book_closed002.dds",
        highlight = "/esoui/art/icons/housing_bre_inc_book_closed002.dds",
        disabled = "/esoui/art/icons/quest_murkmire_captain_hostias_journal"
    }
    
    -- Add the button to the menu
    LMM2:AddMenuItem(menuSceneName, menuSceneName, categoryLayoutInfo, nil)
    mainControl = LMM2:GetControl()  
    logger:Info("Game menu button created successfully")
end

function EsoRpLetters.InitScene()
    logger.Info("init scene start");
    menuScene = ZO_Scene:New(menuSceneName, SCENE_MANAGER)

    menuScene:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    menuScene:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    menuScene:AddFragment(TITLE_FRAGMENT)
    menuScene:AddFragment(RIGHT_BG_FRAGMENT)
    menuScene:AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)

end

function EsoRpLetters.InitPanel()
    logger:Info("init panel start")

    logger:Info("ZO_RightPanel exists: " .. tostring(mainControl))
    -- Check if the mainControl is properly initialized
    if mainControl == nil then
        logger:Error("ZO_RightPanel is nil! Could not find the mainControl!")
        return
    end

    -- Create the scroll list control as a child of ZO_RightPanel
    list = WINDOW_MANAGER:CreateControlFromVirtual("EsoRpLettersList", mainControl, "ZO_ScrollList")
    list:SetAnchor(TOPLEFT, mainControl, TOPLEFT, 20, 20)
    list:SetDimensions(600, 400)
    list:SetHidden(false)
    EsoRpLetters.scrollList = list  -- Save reference for later

    -- Setup the list
    ZO_ScrollList_AddDataType(list, 1, nil, 30, function(control, data)
        if not control.label then
            control.label = WINDOW_MANAGER:CreateControl(nil, control, CT_LABEL)
            control.label:SetFont("ZoFontGame")
            control.label:SetAnchor(LEFT, control, LEFT, 10, 0)
        end
        control.label:SetText(data.text)
    end)

    ZO_ScrollList_SetTypeSelectable(list, 1, true)
    ZO_ScrollList_SetEqualityFunction(list, 1, function(left, right) return left.id == right.id end)

    -- Populate it with example data
    items = {}
    for i = 1, 10 do
        logger:Info("fake letter: " .. i)
        table.insert(items, { id = i, text = "Letter " .. i })
    end

    scrollData = ZO_ScrollList_GetDataList(list)
    ZO_ClearNumericallyIndexedTable(scrollData)

    for _, entry in ipairs(items) do
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, entry))
    end

    ZO_ScrollList_Commit(list)
end


function EsoRpLetters.initStateChanges()
    menuScene:RegisterCallback("StateChange", function(oldState, newState)
        if newState == SCENE_SHOWING then
            PushActionLayerByName("SceneActionLayer")
            if not EsoRpLetters.panelInitialized then
                EsoRpLetters.InitPanel()
                EsoRpLetters.panelInitialized = true
            end
        elseif newState == SCENE_HIDDEN then
            RemoveActionLayerByName("SceneActionLayer")
        end
    end)
end

function EsoRpLetters.Initialize()
    logger:Info("Initializing ESO RP Letters...")
    -- Set scene
    EsoRpLetters.InitScene()
    ZO_CreateStringId("STRID_ESO_RP_LETTERS_DISPLAY", "Letter Note Book")
    -- Register the button in the Game Menu Bar
    EsoRpLetters.CreateGameMenuButton()
    EsoRpLetters.initStateChanges()
end

function EsoRpLetters.OnAddOnLoaded(event, addonName)
    if addonName == EsoRpLetters.name then
        EsoRpLetters.Initialize()
        EVENT_MANAGER:UnregisterForEvent(EsoRpLetters.name, EVENT_ADD_ON_LOADED)
    end
end

EVENT_MANAGER:RegisterForEvent("ESO_RP_Letters", EVENT_ADD_ON_LOADED, EsoRpLetters.OnAddOnLoaded)
