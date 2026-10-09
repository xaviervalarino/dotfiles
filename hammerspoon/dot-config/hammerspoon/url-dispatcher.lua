-- Routes web links opened from other apps to their desktop apps, and every
-- other link to the browser. Hammerspoon receives links only while it is the
-- default browser: run `hs -c 'hs.urlevent.setDefaultHandler("http")'` once
-- and confirm the macOS prompt. Links clicked inside a browser never reach it.
-- To change browsers, make the new one the default, reload Hammerspoon, then
-- set Hammerspoon as the default again.

-- Once Hammerspoon is the default browser, the system lookup returns
-- Hammerspoon, so the last other default is kept in hs.settings.
local function browserBundle()
    local current = hs.urlevent.getDefaultHandler("http")
    if current and current:lower() ~= hs.processInfo.bundleID:lower() then
        hs.settings.set("urlDispatcher.browser", current)
    end
    return hs.settings.get("urlDispatcher.browser") or "com.apple.Safari"
end

local BROWSER = browserBundle()

local NOTION_PAGE_ID = string.rep("%x", 32)
local FIGMA_FILE_KINDS = { file = true, design = true, board = true, proto = true, slides = true }

-- Each route matches only links to content the app can show. An app handed a
-- link it cannot show sends it back to the default browser, which is
-- Hammerspoon; the sender check in the callback stops that loop.
local routes = {
    {
        bundle = "notion.id",
        match = function(host, path)
            return (host == "app.notion.com" or host:match("notion%.so$")) and path:match(NOTION_PAGE_ID)
        end,
        -- An https link opens a browser tab that hands off to the app; notion:// skips the tab.
        rewrite = function(url)
            return (url:gsub("^https?://", "notion://"))
        end,
    },
    {
        bundle = "com.tinyspeck.slackmacgap",
        match = function(host, path)
            return host:match("%.slack%.com$") and (path:match("^/archives/") or path:match("^/client/"))
        end,
    },
    {
        bundle = "com.figma.Desktop",
        match = function(host, path)
            return (host == "figma.com" or host == "www.figma.com") and FIGMA_FILE_KINDS[path:match("^/(%a+)/")]
        end,
    },
}

local function bundleForPID(pid)
    local app = pid and pid > 0 and hs.application.applicationForPID(pid)
    return app and app:bundleID()
end

hs.urlevent.httpCallback = function(_, host, _, url, senderPID)
    local path = url:match("^%a+://[^/]+(/[^?#]*)") or "/"
    local sender = bundleForPID(senderPID)
    for _, route in ipairs(routes) do
        if route.bundle ~= sender and route.match(host or "", path) then
            hs.urlevent.openURLWithBundle(route.rewrite and route.rewrite(url) or url, route.bundle)
            return
        end
    end
    hs.urlevent.openURLWithBundle(url, BROWSER)
end
