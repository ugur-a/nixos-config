{...}: {
  imports = [
    ./bluetooth.nix
    ./certificates
    ./ddcci-plasmoid.nix
    #./flatpak.nix
    ./hardware-configuration.nix
    ./nix.nix
    ./plasma.nix
    ./power.nix
    ./syncthing.nix
  ];
}
