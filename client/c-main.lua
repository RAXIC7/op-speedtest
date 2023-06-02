local lastPos = nil
local lastTime = nil
local speed = 0
local maxSpeed = 0
local startAccelTime = nil
local accelRecorded = false
local startAccelTime2 = nil
local accelRecorded2 = false
local showHUD = Config.Default

RegisterCommand("sptest", function(source, args)
    showHUD = not showHUD
    if showHUD then
        TriggerEvent("chat:addMessage", {args = {"Speed test on!"}})
    else
        TriggerEvent("chat:addMessage", {args = {"Speed test off!"}})
    end
end, false)

CreateThread(function()
    while true do
        if showHUD and IsPedInAnyVehicle(PlayerPedId(), false) then
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local pos = GetEntityCoords(PlayerPedId())
            if lastPos ~= nil and lastTime ~= nil then
                local timeDiff = GetGameTimer() - lastTime
                local dist = #(pos - lastPos)
                speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
                if speed > maxSpeed then
                    maxSpeed = speed
                end
                
                if math.floor(speed) == 0 then
                    startAccelTime = GetGameTimer()
                    accelRecorded = false
                end

                if speed >= 100 and startAccelTime ~= nil and accelRecorded == false then
                    startAccelTime2 = GetGameTimer()
                    accelRecorded2 = false
                    time0to100 = (startAccelTime2 - startAccelTime) / 1000
                    CreateThread(function()
                        alpha = 0
                        show0to100 = true
                        while alpha < 255 do
                            alpha = alpha + 5
                            Wait(1)
                        end
                        Wait(1000)
                        while alpha > 0 do
                            alpha = alpha - 5
                            Wait(1)
                        end
                        show0to100 = false
                    end)
                    startAccelTime = nil
                    accelRecorded = true
                end

                if speed >= 200 and startAccelTime2 ~= nil and accelRecorded2 == false then
                    time100to200 = (GetGameTimer() - startAccelTime2) / 1000
                    CreateThread(function()
                        alpha2 = 0
                        show100to200 = true
                        while alpha2 < 255 do
                            alpha2 = alpha2 + 5
                            Wait(1)
                        end
                        Wait(1000)
                        while alpha2 > 0 do
                            alpha2 = alpha2 - 5
                            Wait(1)
                        end
                        show100to200 = false
                    end)
                    startAccelTime2 = nil
                    accelRecorded2 = true
                end
            else
                startAccelTime = nil
                startAccelTime2 = nil
            end
            lastPos = pos
            lastTime = GetGameTimer()
        else
            speed = 0
            maxSpeed = 0
        end
        if showHUD and IsPedInAnyVehicle(PlayerPedId(), false) then
            if speed then
                SetTextColour(255, 255, 255, 255)
                SetTextScale(1.0, 1.0)
                SetTextFont(7)
                SetTextCentre(true)
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString(math.floor(speed + 0.5) .. " km/h")
                DrawText(0.5, 0.9)
            end
            if maxSpeed then
                SetTextColour(255, 255, 255, 255)
                SetTextScale(0.5, 0.5)
                SetTextFont(7)
                SetTextCentre(true)
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("max " .. math.floor(maxSpeed + 0.5) .. " km/h")
                DrawText(0.5, 0.95)
            end
            if show0to100 and not show100to200 then
                SetTextColour(255, 255, 255, alpha)
                SetTextScale(0.5, 0.5)
                SetTextFont(7)
                SetTextCentre(true)
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("0-100 km/h = " .. time0to100)
                DrawText(0.5, 0.875)
            elseif show100to200 then
                SetTextColour(255, 255, 255, alpha2)
                SetTextScale(0.5, 0.5)
                SetTextFont(7)
                SetTextCentre(true)
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("100-200 km/h = " .. time100to200)
                DrawText(0.5, 0.875)
            end
        end
        Wait(1)
    end
end)