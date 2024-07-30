{
  imports = [
    ./conform.nix
    ./debug.nix
    ./gitsigns.nix
    ./neo-tree.nix
    ./nvim-cmp.nix
    ./telescope.nix

    ./languages/lint.nix
    ./languages/lsp.nix
    ./languages/treesitter.nix

    ./languages/nix.nix
    ./languages/rust.nix

    ./utils/autopairs.nix
    ./utils/indent-blankline.nix
    ./utils/mini.nix
    ./utils/todo-comments.nix
    ./utils/which-key.nix
  ];
}
