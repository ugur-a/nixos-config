{
  config,
  userSettings,
  ...
}: let
  # Unfortunately, there isn't a preferred://terminal, so emulate that
  # by mapping userSettings.terminal to the corresponding .desktop file
  terminal = let
    inherit (userSettings) terminal;
    match_terminal = {
      "konsole" = "applications:org.kde.konsole.desktop";
      "wezterm" = "applications:org.wezfurlong.wezterm.desktop";
    };
  in
    builtins.getAttr terminal match_terminal;

  # similarly with preferred://terminal, but map $EDITOR instead
  editor = let
    editor = config.home.sessionVariables.EDITOR;
    match_editor = {
      "nvim" = "applications:nvim.desktop";
    };
  in
    builtins.getAttr editor match_editor;
in {
  programs.plasma = {
    enable = true;
    overrideConfig = true;

    configFile = {
      # TODO switch to the high-level input module once it lands
      # https://github.com/nix-community/plasma-manager/pull/123
      "kcminputrc"."Libinput/1267/12553/ELAN2204:00 04F3:3109 Touchpad" = {
        "ClickMethod" = 2; # tap-to-click
        "NaturalScroll" = true;
        "PointerAcceleration" = 0.200;
      };
      # disable the hot corner (aka. Screen Edge)
      "kwinrc"."Effect-overview"."BorderActivate" = 9;
      "kxkbrc"."Layout"."ResetOldOptions" = true;
      "kxkbrc"."Layout"."Options" = "grp:win_space_toggle,caps:escape_shifted_capslock";
      # https://discuss.kde.org/t/6-1-plasma-mouse-sticking-a-bit-more-to-screen-edges/17437/
      "kwinrc"."EdgeBarrier"."EdgeBarrier" = 10;
      "kwinrc"."NightColor" = {
        "Active" = true;
        "Mode" = "Location";
        "LatitudeFixed" = 51;
        "LongitudeFixed" = 7;
        "DayTemperature" = 6300;
        "NightTemperature" = 3700;
      };
    };

    fonts.fixedWidth = {
      family = userSettings.fonts.mono;
      pointSize = 10;
    };

    shortcuts = {
      "kwin"."Window Maximize" = ["Meta+Up"];
      # normally it's <Right> and <Left>, respectively
      # but in my set-up the monitors is one-above-the-other, so remap accordingly
      "kwin"."Window to Next Screen" = ["Meta+Alt+Up"];
      "kwin"."Window to Previous Screen" = ["Meta+Alt+Down"];
      "services/systemsettings.desktop"."_launch" = ["Meta+,"];
    };

    panels = [
      {
        location = "bottom";
        floating = true;
        height = 42;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.showActivityManager"
          {
            iconTasks = {
              launchers = [
                "preferred://browser"
                "applications:obsidian.desktop"
                terminal # see definition above (in "let in"-block)
                "preferred://filemanager"
                editor # ditto
              ];
              behavior.wheel.switchBetweenTasks = false;
            };
          }
          "org.kde.plasma.marginsseparator"
          "de.davidhi.ddcci-brightness"
          {
            systemTray = {
              items.configs.battery.showPercentage = true;
            };
          }
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];

    window-rules = [
      {
        description = "When opening a console, go to Activity \"Default\"";
        match = {
          window-class = "konsole";
          window-types = ["normal"];
        };
        # apply = {
        #   activity = <activity UUID>; # move to the activity with this UUID?
        #   activityrule = 3; # apply on all Activities?
        # };
      }
      {
        description = "Share Firefox across Activities";
        match = {
          window-class = "firefox";
          window-types = ["normal"];
        };
        # apply = {
        #   activity = "00000000-0000-0000-0000-000000000000" (move to all activities? i.e. share across activities);
        #   activityrule = 3;
        # };
      }
      {
        description = "Share Obsidian across Activities";
        match = {
          window-class = "obsidian";
          window-types = ["normal"];
        };
        # apply = {
        #   activity = "00000000-0000-0000-0000-000000000000" (move to all activities? i.e. share across activities);
        #   activityrule = 3;
        # };
      }
    ];

    workspace = {
      clickItemTo = "select";
    };
  };
}
