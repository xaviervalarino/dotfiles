// Zen Browser - Custom User Preferences
// Overrides default prefs on startup without tracking PII or session tokens

// Enable custom userChrome.css styling
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Kill Sponsored Junk & Pocket
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Telemetry & Privacy
user_pref("datareporting.telemetry.enabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("browser.ping-centre.telemetry", false);
user_pref("privacy.trackingprotection.enabled", true);

// macOS Trackpad & Performance
user_pref("apz.overscroll.enabled", true);
user_pref("browser.tabs.unloadOnLowMemory", true);
user_pref("accessibility.tabfocus", 7);
