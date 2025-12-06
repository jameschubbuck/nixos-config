{pkgs, ...}: {
  programs.firefox = {
    profiles.default.extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      darkreader
      sponsorblock
    ];
    policies = {
      DisplayMenuBar = "never";
      OverrideFirstRunPage = "";
      PromptForDownloadLocation = false;
      HardwareAcceleration = true;
      Homepage.StartPage = "previous-session";
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };
      Preferences = {
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.placeholderName" = "Search with DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "Search with DuckDuckGo";
        # Disable about:config warning
        "browser.aboutConfig.showWarning" = false;
        # Disable quit warning
        "browser.warnOnQuitShortcut" = false;
        # Don't load non active tabs
        "browser.tabs.loadInBackground" = true;
        # Enable hardware accel
        "media.ffmpeg.vaapi.enabled" = true;
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        # Dark mode
        "browser.in-content.dark-mode" = true;
        "ui.systemUsesDarkTheme" = true;
        # Auto enable extensions
        "extensions.autoDisableScopes" = 0;
        "extensions.update.enabled" = false;
        # Newtab page
        "browser.newtabpage.enabled" = false;
        "browser.startup.homepage" = "about:blank";
        # Vertical tabs
        "sidebar.verticalTabs" = true;
        # UI customization
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.tabs.hoverPreview.enabled" = false;
        "browser.tabs.allow_transparent_browser" = true;
        "browser.tabs.groups.enabled" = false;
        "browser.tabs.inTitlebar" = 2;
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            widget-overflow-fixed-list = [];
            toolbar-menubar = ["menubar-items"];
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "urlbar-container"
              "unified-extensions-button"
            ];
            TabsToolbar = [];
            unified-extensions-area = [
              "ublock0_raymondhill_net-browser-action"
            ];
          };
          currentVersion = 20;
          newElementCount = 3;
        };
      };
    };
  };
  stylix.targets.firefox.enable = false;
}
