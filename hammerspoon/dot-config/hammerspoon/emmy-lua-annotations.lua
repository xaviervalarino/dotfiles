local path = "./Spoons/EmmyLua.spoon/"
local version_file = path .. "doc-gen-version.json"

local function writeDocGenInfo()
    local data = { version = hs.processInfo.version }
    hs.json.write(data, version_file, true, true)
end

if not pcall(hs.fs.dir, path) or not io.open(version_file) then
    print("Emmy Lua Annotations do not exist, installing spoon and generating")
    return spoon.SpoonInstall:andUse("EmmyLua", {
        fn = function()
            -- log version number after EmmyLua writes annotations
            writeDocGenInfo()
        end,
    })
end

-- Check if annotations are for the current running version of Hammerspoon
local gen_version = hs.json.read(version_file).version
if gen_version and gen_version ~= hs.processInfo.version then
    writeDocGenInfo()
    spoon.use("EmmyLua")
end
