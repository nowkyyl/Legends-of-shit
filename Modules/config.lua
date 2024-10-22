local HttpService = game:GetService("HttpService")

local Config = {}

function Config.SaveSettings()
    writefile("LegendsOfShit.json", HttpService:JSONEncode(settings))
end

function Config:LoadSettings()
    if isfile and isfile("LegendsOfShit.json") then
        local settings = {}
        local new = HttpService:JSONDecode(readfile("LegendsOfShit.json"))
        for i, v in new do
            settings[i] = v
        end

        self:SaveSettings()
    end

    return settings
end

function Config.GetSettings()
    return HttpService:JSONDecode(readfile("LegendsOfShit.json"))
end

return Config
