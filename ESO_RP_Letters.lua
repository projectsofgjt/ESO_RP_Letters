EsoRpLetters = {}
EsoRpLetters.name = "ESO_RP_Letters"

local logger = LibDebugLogger(EsoRpLetters.name)  -- Initialize logger here
local menuSceneName = "EsoRpLetters"  -- Define the scene name
local menuScene -- We'll initialize this after the addon is loaded
local LMM2  -- We'll initialize this after the addon is loaded
local bookPanel
local bg
local label

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
    menuScene:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    menuScene:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
    menuScene:AddFragment(TITLE_FRAGMENT)
    menuScene:AddFragment(RIGHT_BG_FRAGMENT)
    menuScene:AddFragment(PLAYER_PROGRESS_BAR_FRAGMENT)

    -- Optional: set window title
    menuScene:AddFragment(ZO_WindowTitleFragment:New("Letter Archive"))
end

function EsoRpLetters.InitPanel()
    logger.Info("init panel start");
    local control = WINDOW_MANAGER:CreateTopLevelWindow("EsoRpLetters_Panel")
    control:SetAnchorFill(GuiRoot)
    control:SetHidden(true)

    EsoRpLetters.scrollList = WINDOW_MANAGER:CreateControlFromVirtual("EsoRpLetters_ScrollList", control, "ZO_ScrollList")
    EsoRpLetters.scrollList:SetAnchorFill()

    ZO_ScrollList_AddDataType(EsoRpLetters.scrollList, 1, "ZO_ScrollList_Item", 30,
        function(control, data)
            control:GetNamedChild("Text"):SetText(data.text)
        end
    )

    ZO_ScrollList_EnableHighlight(EsoRpLetters.scrollList, "ZO_ThinListHighlight")
    ZO_ScrollList_Commit(EsoRpLetters.scrollList)

    menuScene:AddFragment(ZO_FadeSceneFragment:New(control))
end

function EsoRpLetters.initStateChanges()
    menuScene:RegisterCallback("StateChange", function(oldState, newState)
        if newState == SCENE_SHOWING then
            PushActionLayerByName("SceneActionLayer")  -- Disables movement and combat
        elseif newState == SCENE_HIDDEN then
            RemoveActionLayerByName("SceneActionLayer")
        end
    end)
end

function EsoRpLetters.PopulateLetters(letterList)
    local scrollData = ZO_ScrollList_GetDataList(EsoRpLetters.scrollList)
    ZO_ClearNumericallyIndexedTable(scrollData)

    for _, letter in ipairs(letterList) do
        table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, {
            text = letter.title,
            body = letter.body
        }))
    end

    ZO_ScrollList_Commit(EsoRpLetters.scrollList)
end

function EsoRpLetters.OnLetterClicked(letter)
    LORE_READER:SetupBook(letter.title, letter.body)
    SCENE_MANAGER:Show("loreReader")
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
