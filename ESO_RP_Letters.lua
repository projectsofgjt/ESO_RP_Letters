EsoRpLetters = {}
EsoRpLetters.name = "ESO_RP_Letters"

local logger = LibDebugLogger(EsoRpLetters.name)  -- Initialize logger here
local menuSceneName = "EsoRpLetters"  -- Define the scene name
local menuScene -- We'll initialize this after the addon is loaded
local LMM2  -- We'll initialize this after the addon is loaded
local bookPanel
local bg
local label
-- Add a blurred background layer (simulates depth of field blur)
local blur = WINDOW_MANAGER:CreateTopLevelWindow("EsoRpLetters_BlurBackdrop")
blur:SetAnchorFill()
blur:SetDrawLayer(DL_BACKGROUND)
blur:SetDrawTier(DT_LOW)
blur:SetHidden(true)

local blurTex = WINDOW_MANAGER:CreateControl("$(parent)_Tex", blur, CT_TEXTURE)
blurTex:SetAnchorFill()
blurTex:SetTexture("/esoui/art/miscellaneous/blurred_background.dds")
blurTex:SetAlpha(0.6) -- Tune this for strength
blurTex:SetBlendMode(TEX_BLEND_MODE_ALPHA)

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

    logger:Info("Game menu button created successfully")
end

function EsoRpLetters.InitScene()
    logger.Info("init scene start");
    menuScene = ZO_Scene:New(menuSceneName, SCENE_MANAGER) 

    logger.Info("init pannels start");
    -- Create the main panel for the letter book
    bookPanel = WINDOW_MANAGER:CreateTopLevelWindow("EsoRpLetters_BookPanel")
    bookPanel:SetDimensions(800, 600)
    bookPanel:SetAnchor(CENTER, GuiRoot, CENTER)
    bookPanel:SetHidden(true)
    bookPanel:SetMouseEnabled(true)
    bookPanel:SetMovable(false)
    bookPanel:SetClampedToScreen(true)

    -- Set a background (you can update this later to something nicer)
    bg = WINDOW_MANAGER:CreateControl("$(parent)_BG", bookPanel, CT_BACKDROP)
    bg:SetAnchorFill()
    bg:SetCenterColor(0.1, 0.1, 0.1, 0.9) -- Dark semi-transparent
    bg:SetEdgeColor(1, 1, 1, 0.4)
    bg:SetEdgeTexture(nil, 1, 1, 1.0)
    bg:SetCenterTexture("/esoui/art/book/book_background.dds", 8, 8)

    -- Add a simple label (for demo/testing)
    label = WINDOW_MANAGER:CreateControl("$(parent)_Label", bookPanel, CT_LABEL)
    label:SetFont("ZoFontWinH1")
    label:SetAnchor(CENTER, bookPanel, CENTER, 0, 0)
    label:SetText("Letters will go here...")

    menuScene:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    menuScene:AddFragment(ZO_FadeSceneFragment:New(bookPanel)) -- Add the panel to your custom scene
    menuScene:AddFragment(UI_SHORTCUTS_ACTION_LAYER_FRAGMENT) -- input lock helper
  
    
    logger.Info("init pannels end");
end

function EsoRpLetters.initStateChanges()
    menuScene:RegisterCallback("StateChange", function(oldState, newState)
        if newState == SCENE_SHOWING then
            blur:SetHidden(false)
            PushActionLayerByName("SceneActionLayer")  -- Disables movement and combat
        elseif newState == SCENE_HIDDEN then
            blur:SetHidden(true)
            RemoveActionLayerByName("SceneActionLayer")
        end
    end)
end

function EsoRpLetters.Initialize()
    logger:Info("Initializing ESO RP Letters...")
    -- Set scene
    EsoRpLetters.InitScene();
    ZO_CreateStringId("STRID_ESO_RP_LETTERS_DISPLAY", "Letter Note Book");
    -- Register the button in the Game Menu Bar
    EsoRpLetters.CreateGameMenuButton()
    EsoRpLetters.initStateChanges();
end

function EsoRpLetters.OnAddOnLoaded(event, addonName)
    if addonName == EsoRpLetters.name then
        EsoRpLetters.Initialize()
        EVENT_MANAGER:UnregisterForEvent(EsoRpLetters.name, EVENT_ADD_ON_LOADED)
    end
end

EVENT_MANAGER:RegisterForEvent("ESO_RP_Letters", EVENT_ADD_ON_LOADED, EsoRpLetters.OnAddOnLoaded)
