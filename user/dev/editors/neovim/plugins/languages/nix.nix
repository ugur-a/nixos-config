{
  inputs,
  userSettings,
  systemSettings,
  ...
}:
let
  flake = "(builtins.getFlake ${inputs.self.outPath})";
  inherit (systemSettings) hostname;
  inherit (userSettings) username;
in
{
  programs.nixvim = {
    plugins.lsp.servers.nixd = {
      # fetch completions from:
      #
      # Nixpkgs
      nixpkgs.expr = "import ${flake}.inputs.nixpkgs {}";
      # my NixOS config
      options.nixos.expr = "${flake}.nixosConfigurations.${hostname}.options";
      # my Home-Manager config
      options.home_manager.expr = "{flake}.homeConfigurations.${username}.options";

      settings.formatting = [ "nixfmt" ];
    };
  };
}
