{config, lib, pkgs, ...}: {
  imports = [
    ./config
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraplugins
    extraPlugins = with pkgs.vimPlugins; [
      # Useful for getting pretty icons, but requires a Nerd Font.
      nvim-web-devicons # TODO: Figure out how to configure using this with telescope
    ];
  };

  programs.zsh.shellAliases = lib.mkIf config.programs.nixvim.enable {
    "n" = "nvim";
  };
}
