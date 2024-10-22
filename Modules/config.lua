local HttpService = game:GetService("HttpService")

local Config = {}

function Config.SaveSettings()
    writefile("LegendsOfShit.json", HttpService:JSONEncode(settings))
end

function Config:LoadSettings()
    if readfile then
        local new = HttpService:JSONDecode(readfile("LegendsOfShit.json"))
        for i, v in new do
            shared.settings[i] = v
        end

        self:SaveSettings()
    end

    return shared.settings
end

function Config.GetSettings()
    return HttpService:JSONDecode(readfile("LegendsOfShit.json"))
end

return Config
