EsoRpLetters = {}
EsoRpLetters.name = "ESO_RP_Letters"

function EsoRpLetters.Initialize()
    d("ESO RP Letters initialize.")
end

function EsoRpLetters.OnAddOnLoaded(event, addonName)
    d("ESO RP Letters loaded." .. addonName)
    if addonName == EsoRpLetters.name then
        EsoRpLetters.Initialize()
        EVENT_MANAGER:UnregisterForEvent(EsoRpLetters.name, EVENT_ADD_ON_LOADED)
    end
end

EVENT_MANAGER:RegisterForEvent("ESO_RP_Letters", EVENT_ADD_ON_LOADED, EsoRpLetters.OnAddOnLoaded)
