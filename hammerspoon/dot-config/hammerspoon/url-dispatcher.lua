function appId(app)
    return hs.application.infoForBundlePath(app)["CFBundleIdentifier"]
end

Chrome = appId("/Applications/Google Chrome.app")
Firefox = appId("/Applications/Firefox Developer Edition.app/")

spoon.SpoonInstall:andUse("URLDispatcher", {
    config = {
        url_patterns = {
            { "https?://meet%.google%.com", Chrome },
            { "https?://google%.meet", Chrome },
        },
        default_handler = Firefox,
    },
    start = true,
    loglevel = "debug",
})
