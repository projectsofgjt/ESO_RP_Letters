EsoRpLetters = {}
EsoRpLetters.name = "ESO_RP_Letters"

local logger = LibDebugLogger(EsoRpLetters.name)  -- Initialize logger here
local menuSceneName = "EsoRpLetters"  -- Define the scene name
local menuScene -- We'll initialize this after the addon is loaded
local LMM2  -- We'll initialize this after the addon is loaded

-- This function creates a button in the Game Menu Bar
function EsoRpLetters.CreateGameMenuButton()
    logger:Info("Creating game menu button")

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

    logger:Info("Game menu button created successfully")
end

function EsoRpLetters.Initialize()
    logger:Info("Initializing ESO RP Letters...")

    -- Initialize librarys and needed high scope vairables
    LMM2 = LibMainMenu2
    LMM2:Init()
    -- Set scene
    menuScene = ZO_Scene:New(menuSceneName, SCENE_MANAGER) 
    ZO_CreateStringId("STRID_ESO_RP_LETTERS_DISPLAY", "Letter Note Book");

    -- Initialize addon components
    -- Register the button in the Game Menu Bar
    EsoRpLetters.CreateGameMenuButton()
end

function EsoRpLetters.OnAddOnLoaded(event, addonName)
    if addonName == EsoRpLetters.name then
        EsoRpLetters.Initialize()
        EVENT_MANAGER:UnregisterForEvent(EsoRpLetters.name, EVENT_ADD_ON_LOADED)
    end
end

EVENT_MANAGER:RegisterForEvent("ESO_RP_Letters", EVENT_ADD_ON_LOADED, EsoRpLetters.OnAddOnLoaded)
