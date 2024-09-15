{ lib, config, ... }:
let
  ActivityMonitor = {
    ShowCategory = 101;
  };
  menuExtraClock = {
    ShowDayOfMonth = true;
    ShowDayOfWeek = true;
    ShowDate = 0;
  };
  dock = {
    autohide = false;
    show-process-indicators = false;
    static-only = true;
    tilesize = 32;
  };
  finder = {
    AppleShowAllFiles = false;
    ShowStatusBar = false;
    ShowPathbar = true;
    FXDefaultSearchScope = "SCcf";
    FXPreferredViewStyle = "clmv";
    AppleShowAllExtensions = true;
    CreateDesktop = false;
    QuitMenuItem = false;
    _FXShowPosixPathInTitle = false;
    FXEnableExtensionChangeWarning = false;
  };
  loginwindow = {
    SHOWFULLNAME = false;
    GuestEnabled = false;
    DisableConsoleAccess = true;
  };
  spaces = {
    spans-displays = false;
  };
  trackpad = {
    Clicking = true;
    Dragging = false;
    TrackpadRightClick = true;
    TrackpadThreeFingerDrag = true;
    ActuationStrength = 1;
  };
in
{
  options = {
    darwin-defaults.enable = lib.mkEnableOption "Darwin user defaults";
  };

  config = lib.mkIf config.darwin-defaults.enable {
    security.pam.enableSudoTouchIdAuth = true;

    system.defaults = {
      inherit
        ActivityMonitor
        menuExtraClock
        dock
        finder
        loginwindow
        spaces
        trackpad
        ;

      LaunchServices.LSQuarantine = false;

      CustomUserPreferences = {
        "com.apple.dock" = {
          "mru-spaces" = false;
          "show-recents" = false;
        };
        "com.apple.WindowManager" = {
          GloballyEnabled = false;
          GloballyEnabledEver = true;
        };
      };
    };
  };
}
