local function SendTip(message)
    if Config.Notify == 'ox' then
        if lib then
            lib.notify({
                title = Config.Title,
                description = message,
                type = 'inform',
                duration = Config.Duration
            })
        else
            print('[server_tips] ox_lib is not loaded. Check fxmanifest.lua and ensure ox_lib starts first.')
        end

    elseif Config.Notify == 'vms' then
        if GetResourceState('vms_notifyv2') == 'started' then
            exports['vms_notifyv2']:Notification(
                Config.Title,
                message,
                Config.Duration,
                '#10cc0a',
                'fa-solid fa-lightbulb'
            )
        else
            print('[server_tips] vms_notifyv2 is not started.')
        end

    else
        print('[server_tips] Invalid Config.Notify value: ' .. tostring(Config.Notify))
    end
end

local function SendRandomTip()
    if not Config.Tips or #Config.Tips == 0 then
        print('[server_tips] No tips configured.')
        return
    end

    local tip = Config.Tips[math.random(1, #Config.Tips)]
    SendTip(tip)
end

RegisterCommand('testtip', function()
    SendRandomTip()
end, false)

CreateThread(function()
    Wait(5000)

    while true do
        SendRandomTip()
        Wait(Config.IntervalMinutes * 60 * 1000)
    end
end)