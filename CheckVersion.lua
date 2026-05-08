local RESOURCE_NAME   = 'mt_cardealership'
local CURRENT_VERSION = '2.0.0'
local VERSION_URL     = 'https://raw.githubusercontent.com/1SKROB/qbx_cardealership/main/CheckVersion.text'
local RESOURCE_CHECK  = 'https://raw.githubusercontent.com/1SKROB/qbx_cardealership/main/mt_cardealership.text'

if GetCurrentResourceName() ~= RESOURCE_NAME then
    print('^1[' .. RESOURCE_NAME .. '] Resource name has been changed! Expected: ' .. RESOURCE_NAME .. '^7')
    return
end

CreateThread(function()
    Wait(2000)

    PerformHttpRequest(RESOURCE_CHECK, function(statusCode, response, headers)
        if statusCode ~= 200 or not response or response:find('true') == nil then
            print('^1[' .. RESOURCE_NAME .. '] ⚠️  Resource verification failed! Make sure the resource name is correct.^7')
            return
        end

        PerformHttpRequest(VERSION_URL, function(statusCode2, response2, headers2)
        PerformHttpRequest(VERSION_URL, function(statusCode2, response2, headers2)
            if statusCode2 ~= 200 or not response2 then
                print('^3[' .. RESOURCE_NAME .. '] Could not check for updates. (HTTP ' .. tostring(statusCode2) .. ')^7')
                return
            end

            local lines = {}
            for line in response2:gmatch('[^\r\n]+') do
                table.insert(lines, line)
            end

            local latestVersion = lines[1] and lines[1]:match('^v?(%d+%.%d+%.%d+)') or nil
            local updateNote    = lines[2] or ''

            if not latestVersion then
                print('^3[' .. RESOURCE_NAME .. '] Could not parse version from remote.^7')
                return
            end

            local function parseVersion(v)
                local a, b, c = v:match('(%d+)%.(%d+)%.(%d+)')
                return tonumber(a) or 0, tonumber(b) or 0, tonumber(c) or 0
            end

            local cMaj, cMin, cPat = parseVersion(CURRENT_VERSION)
            local lMaj, lMin, lPat = parseVersion(latestVersion)

            local isOutdated = (lMaj > cMaj)
                or (lMaj == cMaj and lMin > cMin)
                or (lMaj == cMaj and lMin == cMin and lPat > cPat)

            if isOutdated then
                print('')
                print('^1╔══════════════════════════════════════════════╗^7')
                print('^1║      mt_cardealership — UPDATE AVAILABLE     ║^7')
                print('^1╠══════════════════════════════════════════════╣^7')
                print('^1║  Current : ^7v' .. CURRENT_VERSION)
                print('^2║  Latest  : ^7v' .. latestVersion)
                print('^3║  Note    : ^7' .. updateNote)
                print('^1╚══════════════════════════════════════════════╝^7')
                print('')
            else
                print('^2[' .. RESOURCE_NAME .. '] ✅ Running latest version: v' .. CURRENT_VERSION .. '^7')
            end
        end, 'GET', '', {})
    end, 'GET', '', {})
end)
