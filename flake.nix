{
  description = "Flake of ugura";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # only add this so that all the other inputs follow it
    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Third party programs, packaged with nix
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    firefox-addons.inputs.flake-utils.follows = "flake-utils";

    # Secure Boot
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.flake-utils.follows = "flake-utils";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.home-manager.follows = "home-manager";
    nixvim.inputs.flake-utils.follows = "flake-utils";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      firefox-addons,
      flake-utils,
      lanzaboote,
      nixvim,
      plasma-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      systemSettings = {
        system = "x86_64-linux";
        bootMountPath = "/boot";
        hostname = "magicbook";
        timezone = "Europe/Berlin";
        locale = "en_IE.UTF-8";
        stateVersion = "23.11";
      };

      pkgs = nixpkgs.legacyPackages.${systemSettings.system};

      userSettings = {
        gmail = "ugur.alekperov@gmail.com";
        rmail = "ughur.alakbarov@rwth-aachen.de";
        pmail = "ugur.alekperov@protonmail.com";
        name = "Ughur Alakbarov";
        username = "ugura";
        layout = "eu";
        shell = pkgs.zsh;
        # I'd use WezTerm, but the patch invalidates the NixOS cache and triggers a manual build.
        # The latter takes AGES on this machine (and also fails right at the end it seems?)
        # So stay on Konsole for now
        terminal = "konsole";
        fonts.mono = "Cascadia Code";
      };
    in
    # All of the custom stuff I export (and use myself)
    ## System-specific outputs
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # My custom packages, available through 'nix build', 'nix shell', etc
        legacyPackages = import ./pkgs/legacy { inherit pkgs; };

        # My custom modules
        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home;
      }
    )
    ## System-independent ouputs
    // {
      overlays = import ./overlays { inherit inputs; };

      templates = import ./templates;
    }
    # My actual config
    // {
      # Formatter for my nix files, available through 'nix fmt'
      formatter.${systemSettings.system} = pkgs.nixfmt-rfc-style;

      # devShell for bootstrapping a configuration
      devShells.${systemSettings.system} = import ./shell.nix { inherit pkgs; };

      nixosConfigurations.${systemSettings.hostname} = nixpkgs.lib.nixosSystem {
        inherit (systemSettings) system;

        modules = [
          ./profiles/personal/configuration.nix
          lanzaboote.nixosModules.lanzaboote
        ];

        specialArgs = {
          inherit outputs;
          inherit systemSettings;
          inherit userSettings;
          flakePath = inputs.self.outPath;
        };
      };

      homeConfigurations.${userSettings.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./profiles/personal/home.nix
          nixvim.homeManagerModules.nixvim
          plasma-manager.homeManagerModules.plasma-manager
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit firefox-addons;
          inherit outputs;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
}
