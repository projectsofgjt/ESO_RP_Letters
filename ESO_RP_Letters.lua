EsoRpLetters = {}
EsoRpLetters.name = "ESO_RP_Letters"

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

        local categoryLayoutInfo =
        {
            binding = "TOGGLE_ESO_RP_LETTERS",
            categoryName = SI_ESO_RP_LETTERS,
            callback = function(buttonData)
                if not SCENE_MANAGER:IsShowing(sceneName) then
                    SCENE_MANAGER:Show(sceneName)
                end
            end,
            visible = function(buttonData) return true end,
        
            normal = "/esoui/art/tradinghouse/tradinghouse_racial_style_motif_book_up.dds",
			pressed = "/esoui/art/tradinghouse/tradinghouse_racial_style_motif_book_down.dds",
			highlight = "/esoui/art/tradinghouse/tradinghouse_racial_style_motif_book_over.dds",
			disabled = "/esoui/art/tradinghouse/tradinghouse_racial_style_motif_book_disabled.dds"
        }
        
        LMM2:AddMenuItem("SI_ESO_RP_LETTERS", sceneName, categoryLayoutInfo, nil)

    
        -- Check if the button was added successfully
        if result then
            logger:Info("Game menu button created successfully")
        else
            logger:Error("Failed to create game menu button")
        end
    end

function EsoRpLetters.Initialize()
    logger:Info("Initializing ESO RP Letters...")
    -- this as part of the EVENT_ADD_ON_LOADED
    local LMM2 = LibMainMenu2
    LMM2:Init()
    local logger = LibDebugLogger(EsoRpLetters.name)
    local sceneName = "EsoRpLetters"
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
