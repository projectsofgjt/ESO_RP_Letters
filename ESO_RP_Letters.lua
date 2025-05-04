ESO_RP_LETTERS = {}
ESO_RP_LETTERS.name = "ESO_RP_Letters"

local logger = LibDebugLogger(ESO_RP_LETTERS.name)  -- Initialize logger here
local ESO_RP_LETTERS_MAIN_SCENE -- We'll initialize this after the addon is loaded
local LMM2  -- We'll initialize this after the addon is loaded
local ESO_RP_LETTERS_MAIN_TITLE_FRAGMENT 
local ESO_RP_LETTERS_MAIN_WINDOW


-- This function creates a button in the Game Menu Bar
function ESO_RP_LETTERS.init()
    logger:Info("Creating game menu button")

    -- Build the Menu
    -- Its name for the menu (the meta scene)
    ZO_CreateStringId("SI_ESO_RP_LETTERS_MAIN_MENU_TITLE", "Letter Notebook")
    
    -- Its infos,
    ZO_CreateStringId("SI_BINDING_NAME_ESO_RP_LETTERS_SHOW_PANEL", "Toggle letter notebook") -- you also need to use a bindings.xml in order to display your keybind in options.
    ESO_RP_LETTERS_MAIN_MENU_CATEGORY_DATA =
    {
        binding = "ESO_RP_LETTERS_SHOW_PANEL",
        categoryName = SI_ESO_RP_LETTERS_MAIN_MENU_TITLE,
        normal = "/esoui/art/icons/housing_bre_inc_book_closed002.dds",
        pressed = "/esoui/art/icons/housing_bre_inc_book_closed002.dds",
        highlight = "/esoui/art/icons/housing_bre_inc_book_closed002.dds",
        disabled = "/esoui/art/icons/quest_murkmire_captain_hostias_journal"
    }
    
    -- Then the scenes
    
    -- Main Scene is created trought our function described in 1st section
    ESO_RP_LETTERS.CreateScene()
    
    -- Another Scene , because using main menu without having 2 scenes should be avoided.
    ESO_RP_LETTERS_ANOTHER_SCENE = ZO_Scene:New("ESO_RP_LETTERSAnother", SCENE_MANAGER)   
    
    -- Mouse standard position and background
    ESO_RP_LETTERS_ANOTHER_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    ESO_RP_LETTERS_ANOTHER_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
    --  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    ESO_RP_LETTERS_ANOTHER_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    
    -- The title fragment
    ESO_RP_LETTERS_ANOTHER_SCENE:AddFragment(TITLE_FRAGMENT)
    
    -- Set Title
    ZO_CreateStringId("SI_ESO_RP_LETTERS_IMPORT_MENU_TITLE", "Another title")
    ESO_RP_LETTERS_ANOTHER_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_ESO_RP_LETTERS_MAIN_MENU_TITLE) -- The title at the left of the scene is the "global one" but we can change it
    ESO_RP_LETTERS_ANOTHER_SCENE:AddFragment(ESO_RP_LETTERS_ANOTHER_TITLE_FRAGMENT)
    
    -- Add the XML to our scene
    ESO_RP_LETTERS_ANOTHER_WINDOW = ZO_FadeSceneFragment:New(AnotherPieceofXML)
    ESO_RP_LETTERS_ANOTHER_SCENE:AddFragment(ESO_RP_LETTERS_ANOTHER_WINDOW)
 
    -- Set tabs and visibility, etc
    
    do
        local iconData = {
            {
                categoryName = SI_ESO_RP_LETTERS_MAIN_MENU_TITLE, -- the title at the right (near the buttons)
                descriptor = "ESO_RP_LETTERSMain",
                normal = "EsoUI/Art/MainMenu/menuBar_champion_up.dds",
                pressed = "EsoUI/Art/MainMenu/menuBar_champion_down.dds",
                highlight = "EsoUI/Art/MainMenu/menuBar_champion_over.dds",
            },
            {
                categoryName = SI_ESO_RP_LETTERS_ANOTHER_MENU_TITLE, -- the title at the right (near the buttons)
                visible = function() return IsChampionSystemUnlocked() end, -- is tab visible ?
                descriptor = "ESO_RP_LETTERSAnother",
                normal = "EsoUI/Art/Guild/tabicon_history_up.dds",
                pressed = "EsoUI/Art/Guild/tabicon_history_down.dds",
                highlight = "EsoUI/Art/Guild/tabicon_history_over.dds",
            },
        }
        
        -- Register Scenes and the group name
        SCENE_MANAGER:AddSceneGroup("ESO_RP_LETTERSSceneGroup", ZO_SceneGroup:New("ESO_RP_LETTERSMain", "ESO_RP_LETTERSAnother"))
        
        -- ZOS have hardcoded its categories, so here is LibMainMenu utility.
        MENU_CATEGORY_ESO_RP_LETTERS = LMM:MainMenuAddCategory(ESO_RP_LETTERS_MAIN_MENU_CATEGORY_DATA)
        
        -- Register the group and add the buttons
        LMM:MainMenuAddSceneGroup(MENU_CATEGORY_ESO_RP_LETTERS, "ESO_RP_LETTERSSceneGroup", iconData)
        
    end

    logger:Info("Game menu button created successfully")
end

function ESO_RP_LETTERS.CreateScene()
    logger.Info("init scene start");
    -- Main Scene
    ESO_RP_LETTERS_MAIN_SCENE = ZO_Scene:New("ESO_RP_LETTERSMain", SCENE_MANAGER) 
    
    -- Mouse standard position and background
    ESO_RP_LETTERS_MAIN_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    ESO_RP_LETTERS_MAIN_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
    --  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    ESO_RP_LETTERS_MAIN_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    
    -- The title fragment
    ESO_RP_LETTERS_MAIN_SCENE:AddFragment(TITLE_FRAGMENT)
    
    -- Set Title
    ZO_CreateStringId("SI_ESO_RP_LETTERS_MAIN_MENU_TITLE", "My Addon Name")
    ESO_RP_LETTERS_MAIN_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_ESO_RP_LETTERS_MAIN_MENU_TITLE)
    ESO_RP_LETTERS_MAIN_SCENE:AddFragment(ESO_RP_LETTERS_MAIN_TITLE_FRAGMENT)
    
    -- Add the XML to our scene
    ESO_RP_LETTERS_MAIN_WINDOW = ZO_FadeSceneFragment:New(MyUINameInXML)
    ESO_RP_LETTERS_MAIN_SCENE:AddFragment(ESO_RP_LETTERS_MAIN_WINDOW)
end

function ESO_RP_LETTERS.initStateChanges()
    menuScene:RegisterCallback("StateChange", function(oldState, newState)
        LMM:ToggleCategory(MENU_CATEGORY_MYADDON)
    end)
end


function ESO_RP_LETTERS.Initialize()
    logger:Info("Initializing ESO RP Letters...")
end

function ESO_RP_LETTERS.OnAddOnLoaded(event, addonName)
    if addonName == ESO_RP_LETTERS.name then
        ESO_RP_LETTERS.Initialize()
        EVENT_MANAGER:UnregisterForEvent(ESO_RP_LETTERS.name, EVENT_ADD_ON_LOADED)
    end
end

EVENT_MANAGER:RegisterForEvent("ESO_RP_Letters", EVENT_ADD_ON_LOADED, ESO_RP_LETTERS.OnAddOnLoaded)
