{ lib, config, ... }:
let
  cfg = config.programs.plasma;
in
{
  imports = [
    ./rc2nix.nix

    ./input.nix
    ./night-light.nix
    ./panels.nix
    ./shortcuts.nix
    ./window-rules.nix
  ];

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    configFile = {
      # disable the hot corner (aka. Screen Edge)
      "kwinrc"."Effect-overview"."BorderActivate" = 9;
      "kxkbrc"."Layout"."ResetOldOptions" = true;
      "kxkbrc"."Layout"."Options" = "grp:win_space_toggle,caps:escape_shifted_capslock";
      # https://discuss.kde.org/t/6-1-plasma-mouse-sticking-a-bit-more-to-screen-edges/17437/
      "kwinrc"."EdgeBarrier"."EdgeBarrier" = 10;
      # disable the reminder for Plasma Integration
      "plasmanotifyrc"."Applications/firefox"."Seen" = true;
      "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
      # _always_ sleep on closed lid
      "powerdevilrc"."AC/SuspendAndShutdown"."InhibitLidActionWhenExternalMonitorPresent" = false;
      "powerdevilrc"."Battery/SuspendAndShutdown"."InhibitLidActionWhenExternalMonitorPresent" = false;
      "powerdevilrc"."LowBattery/SuspendAndShutdown"."InhibitLidActionWhenExternalMonitorPresent" = false;
    };

    workspace = {
      clickItemTo = "select";
      wallpaper = ../wallpaper.jpg;
    };
  };

  xdg.configFile = lib.mkIf cfg.enable {
    "PlasmaUserFeedback".text = lib.generators.toINI { } { Global.FeedbackLevel = 64; };
  };
}
