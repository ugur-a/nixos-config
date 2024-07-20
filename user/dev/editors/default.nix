{
  pkgs,
  systemSettings,
  outputs,
  ...
}:
{
  imports = [
    ./helix.nix
    ./neovim
    ./vscode.nix
  ];

  home.packages =
    (with pkgs; [
      # LSPs
      nixd
      lua-language-server
      rust-analyzer

      # Debug Adapters (DAPs)
      lldb # vscode-lldb

      # Formatters
      # vimPlugins.vim-clang-format # conflicts with gruvbox-nvim & lazygit-nvim for some reason?
      clang-tools # c(++), js(on)
      rustfmt
      stylua
      taplo # toml
      # xmlformat
    ])
    ++ [ outputs.formatter.${systemSettings.system} ];
}
