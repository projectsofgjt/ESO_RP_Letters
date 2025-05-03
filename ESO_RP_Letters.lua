EsoRpLetters = {}
EsoRpLetters.name = "ESO_RP_Letters"
local logger = LibDebugLogger(EsoRpLetters.name)

function EsoRpLetters.Initialize()
    logger:Info("Initializing ESO RP Letters...")
    -- Register the button in the Game Menu Bar
    EsoRpLetters.CreateGameMenuButton()
end

-- This function creates a button in the Game Menu Bar
function EsoRpLetters.CreateGameMenuButton()
    logger:Info("Creating game menu button")

    local function OpenLetterPanel()
        EsoRpLetters.ShowLetterPanel()
    end

    -- Add your entry to ZO_MainMenu
    ZO_MainMenu_AddButton({
        categoryName = "ESO_RP_Letters_Menu",
        name = "RP Letters",
        categoryTooltipText = "Read your RP letters",
        normal = "EsoUI/Art/Journal/journal_tabIcon_notes_up.dds",
        pressed = "EsoUI/Art/Journal/journal_tabIcon_notes_down.dds",
        highlight = "EsoUI/Art/Journal/journal_tabIcon_notes_over.dds",
        callback = OpenLetterPanel,
    })

    logger:Info("Game menu button created")
end

-- Function to display the RP letters panel (currently just a blank screen)
function EsoRpLetters.ShowLetterPanel()
    logger:Info("show letter pannel")
    -- Create a blank screen to be replaced later with the letter list
    local panel = WINDOW_MANAGER:CreateTopLevelWindow("EsoRpLetters_Panel")
    panel:SetDimensions(800, 600)  -- Set size for the panel
    panel:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
    panel:SetHidden(false)  -- Show the panel

    -- You can customize this panel later to display the letter list
end


function EsoRpLetters.OnAddOnLoaded(event, addonName)
    if addonName == EsoRpLetters.name then
        EsoRpLetters.Initialize()
        EVENT_MANAGER:UnregisterForEvent(EsoRpLetters.name, EVENT_ADD_ON_LOADED)
    end
end

EVENT_MANAGER:RegisterForEvent("ESO_RP_Letters", EVENT_ADD_ON_LOADED, EsoRpLetters.OnAddOnLoaded)
