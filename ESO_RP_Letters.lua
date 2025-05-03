EsoRpLetters = {}
EsoRpLetters.name = "ESO_RP_Letters"

local logger = LibDebugLogger(EsoRpLetters.name)  -- Initialize logger here
local menuSceneName = "EsoRpLetters"  -- Define the scene name
local menuScene -- We'll initialize this after the addon is loaded
local LMM2  -- We'll initialize this after the addon is loaded


-- Function to display the RP letters panel (currently just a blank screen)
function EsoRpLetters.ShowLetterPanel()
    logger:Info("show letter panel")
    -- Create a blank screen to be replaced later with the letter list
    local panel = WINDOW_MANAGER:CreateTopLevelWindow("EsoRpLetters_Panel")
    panel:SetDimensions(800, 600)  -- Set size for the panel
    panel:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
    panel:SetHidden(false)  -- Show the panel

    -- You can customize this panel later to display the letter list
end

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
        categoryName = SI_ESO_RP_LETTERS,
        callback = function(buttonData)
            if not SCENE_MANAGER:IsShowing(menuSceneName) then
                SCENE_MANAGER:Show(menuSceneName)
            end
        end,
        visible = function(buttonData) return true end,
    
        normal = "/esoui/art/tradinghouse/tradinghouse_racial_style_motif_book_up.dds",
        pressed = "/esoui/art/tradinghouse/tradinghouse_racial_style_motif_book_down.dds",
        highlight = "/esoui/art/tradinghouse/tradinghouse_racial_style_motif_book_over.dds",
        disabled = "/esoui/art/tradinghouse/tradinghouse_racial_style_motif_book_disabled.dds"
    }
    
    -- Add the button to the menu
    LMM2:AddMenuItem("SI_ESO_RP_LETTERS", menuSceneName, categoryLayoutInfo, nil)

    logger:Info("Game menu button created successfully")
end

function EsoRpLetters.CreateScene()
    logger.Info("initialize scene" )
    -- Main Scene
    menuScene = ZO_Scene:New(menuSceneName, SCENE_MANAGER) 
    
    -- -- Mouse standard position and background
    -- MYADDON_MAIN_SCENE:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    -- MYADDON_MAIN_SCENE:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    
    -- --  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
    -- MYADDON_MAIN_SCENE:AddFragment(RIGHT_BG_FRAGMENT)
    
    -- -- The title fragment
    -- MYADDON_MAIN_SCENE:AddFragment(TITLE_FRAGMENT)
    
    -- -- Set Title
    -- ZO_CreateStringId("SI_MYADDON_MAIN_MENU_TITLE", "My Addon Name")
    -- MYADDON_MAIN_TITLE_FRAGMENT = ZO_SetTitleFragment:New(SI_MYADDON_MAIN_MENU_TITLE)
    -- MYADDON_MAIN_SCENE:AddFragment(MYADDON_MAIN_TITLE_FRAGMENT)
    
    -- -- Add the XML to our scene
    -- MYADDON_MAIN_WINDOW = ZO_FadeSceneFragment:New(MyUINameInXML)
    -- MYADDON_MAIN_SCENE:AddFragment(MYADDON_MAIN_WINDOW)
    
    
end

function EsoRpLetters.Initialize()
    logger:Info("Initializing ESO RP Letters...")

    -- Initialize LibMainMenu2 here to make sure it's ready before use
    LMM2 = LibMainMenu2
    LMM2:Init()

    -- Set scene
    EsoRpLetters.CreateScene()
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
