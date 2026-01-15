if not Config.Enabled then return end
if Config.Inventory ~= 'qb-inventory' then return end
if GetResourceState(Config.Inventory) == 'missing' or GetResourceState(Config.Inventory) == 'unknown' then print(('^3[ImageDetector]^7 ^1[ERROR]^7 %s can not be found in your resources'):format(Config.Inventory)) return end
if GetResourceState('qb-core') == 'missing' or GetResourceState('qb-core') == 'unknown' then print(('^3[ImageDetector]^7 ^1[ERROR]^7 %s can not be found in your resources'):format('qb-core')) return end

-- Get all items from items.lua
local function getAllItems()
    local allItems = {}

    local core = exports['qb-core']

    -- items.lua
    local items = core:GetSharedItems()
    if items then
        for k, v in pairs(items) do
            allItems[k] = v
        end
    else
        print('^3[ImageDetector]^7 ^1[ERROR]^7 GetSharedItems() returned nil')
    end

    return allItems
end

-- Get all image files
local function getAllItemImages()
    local imagePath = GetResourcePath(Config.Inventory) .. '/html/images/'
    local images = {}
    local count = 0

    local handle = io.popen(('dir "%s" /b 2>nul'):format(imagePath))
    if not handle then return images, 0 end

    for file in handle:lines() do
        local name = file:match('(.+)%.png')
        if name then
            local key = Config.CaseSensitive and name or name:lower()
            images[key] = name
            count = count + 1
        end
    end

    handle:close()
    return images, count
end

-- Scan function
local function checkInventoryImages()
    Wait(100)
    print('^3[ImageDetector]^7 Starting ox_inventory image scan...')

    local rawItems = getAllItems()
    local images, imageCount = getAllItemImages()

    local itemsWithoutImage = {}
    local imagesWithoutItem = {}
    local usedImages = {}
    local itemCount = 0

    for itemName, itemData in pairs(rawItems) do
        itemCount = itemCount + 1

        local imageName
        if Config.ItemImages and Config.ItemImages[itemName] then
            imageName = Config.ItemImages[itemName]
        elseif itemData.image then
            imageName = itemData.image:gsub('%.png$', '')
        else
            imageName = itemName
        end

        local key = Config.CaseSensitive and imageName or imageName:lower()
        if images[key] then
            usedImages[key] = true
        else
            itemsWithoutImage[#itemsWithoutImage + 1] = itemName
        end
    end

    for key, originalName in pairs(images) do
        if not usedImages[key] then
            imagesWithoutItem[#imagesWithoutItem + 1] = originalName
        end
    end

    print('^3[ImageDetector]^7 Scan completed.\n')

    if #itemsWithoutImage == 0 then
        print('^2[OK]^7 All items have a corresponding image.')
    else
        print('^1[MISSING]^7 Items without image (' .. #itemsWithoutImage .. '):')
        for i = 1, #itemsWithoutImage do
            print('  [^5' .. i .. '^7] ' .. itemsWithoutImage[i])
        end
    end

    print('')

    if #imagesWithoutItem == 0 then
        print('^2[OK]^7 No unused images found.')
    else
        print('^1[UNUSED]^7 Images without a linked item (' .. #imagesWithoutItem .. '):')
        for i = 1, #imagesWithoutItem do
            print('  [^5' .. i .. '^7] ' .. imagesWithoutItem[i] .. '.png')
        end
    end

    print('')
    print('^3[ImageDetector]^7 Summary:')
    print('  ^7Items checked:   ^3' .. itemCount .. '^7')
    print('  ^7Images found:    ^3' .. imageCount .. '^7')
    print('  ^7Missing images:  ^1' .. #itemsWithoutImage .. '^7')
    print('  ^7Unused images:   ^1' .. #imagesWithoutItem .. '^7')
end

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    checkInventoryImages()
end)