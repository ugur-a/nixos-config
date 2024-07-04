{flake_path, ...}: {
  nixos.autoUpgrade = {
    enable = true;
    dates = "3 days";
    flake = flake_path;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };
}
