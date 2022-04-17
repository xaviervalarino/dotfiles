local M = {}

---Select app by name
---launch or focus app by its name
---@param name string the name of the app
---@return boolean did the application launch or focus
function M.app_select(name)
  return function()
    hs.application.launchOrFocus(name)
  end
end

---Go to Chrome tab by uri
---Goes to open chrome tab matching `uri`, or opens it if it doesn't already exist
---@param uri string URI of the open tab
---@return function AppleScript the Applescript to be run
function M.goto_chrome_tab(uri)
  -- https://evantravers.com/articles/2019/10/31/focusing-browser-tab-using-jxa-and-hammerspoon/
  -- https://github.com/JXA-Cookbook/JXA-Cookbook/
  local fn = string.format(
    [[
    const chrome = Application("Google Chrome");
    chrome.activate();

    function goToTab(uri) {
      const windows = chrome.windows();
      const found = windows.filter((win) => {
        const tabIndex = win
          .tabs()
          .findIndex(({ url }) => url().match(new RegExp(uri)));
        if (tabIndex != -1) {
          win.activeTabIndex = tabIndex + 1;
          win.index = 1;
          return win;
        }
      });
      if (!found.length) {
        console.log("nothing found");
        windows[0].tabs.push(chrome.Tab({ url: `https://${uri}` }));
      }
    }
    goToTab("%s");
    ]],
    uri
  )
  return function()
    hs.osascript.javascript(fn)
  end
end

return M
