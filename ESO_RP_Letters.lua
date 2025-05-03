EsoRpLetters = {}
EsoRpLetters.name = "ESO_RP_Letters"

function EsoRpLetters.Initialize()
    -- Register the button in the Game Menu Bar
    EsoRpLetters.CreateGameMenuButton()
end

-- This function creates a button in the Game Menu Bar
function EsoRpLetters.CreateGameMenuButton()
    local panelData = {
        type = "submenu",
        name = "RP Letters",
        tooltip = "View your RP letters",
        -- Here we link a function to be called when this submenu is selected
        func = EsoRpLetters.ShowLetterPanel,
        -- Add this to the Game Menu Bar
        category = "system",
    }

    -- Create the button using LibAddonMenu
    LibAddonMenu2:RegisterAddonPanel("ESO_RP_Letters_Panel", panelData)

    -- Optionally, you can create a simple menu entry using `LibAddonMenu` as well.
    -- This is just a placeholder for later when we need to load the letters
    logger:Debug("menu button created")
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
