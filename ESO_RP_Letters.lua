EsoRpLetters = {}
EsoRpLetters.name = "EsoRpLetters"

function EsoRpLetters.Initialize()
    debug("Addon loaded.")
end

function EsoRpLetters.OnAddOnLoaded(event, addonName)
    if addonName == EsoRpLetters.name then
        EsoRpLetters.Initialize()
        EVENt_MANAGER:UnregisterForEvent(EsoRpLetters.name, EVENT_ADD_ON_LOADED)
    end
end

EVENT_MANAGER:RegisterForEvent(EsoRpLetters.name, EVENT_ADD_ON_LOADED, EsoRpLetters.OnAddOnLoaded)