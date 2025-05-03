EsoRpLetters = {}
EsoRpLetters.name = "EsoRpLetters"

function EsoRpLetters.Initialize()
    d("ESO RP Letters loaded.")
end

function EsoRpLetters.OnAddOnLoaded(event, addonName)
    if addonName == EsoRpLetters.name then
        EsoRpLetters.Initialize()
        EVENT_MANAGER:UnregisterForEvent(EsoRpLetters.name, EVENT_ADD_ON_LOADED)
    end
end

EVENT_MANAGER:RegisterForEvent(EsoRpLetters.name, EVENT_ADD_ON_LOADED, EsoRpLetters.OnAddOnLoaded)
