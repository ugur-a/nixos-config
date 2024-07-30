{
  programs.nixvim = {
    # Neo-tree is a Neovim plugin to browse the file system
    # https://nix-community.github.io/nixvim/plugins/neo-tree/index.html?highlight=neo-tree#pluginsneo-treepackage
    plugins.neo-tree = {
      enable = true;

      window.position = "right";

      # Sources
      #
      filesystem = {
        bindToCwd = true;
        followCurrentFile.enable = true;

        filtered_items = {
          visible = true;
          show_hidden_count = true;
          hide_dotfiles = false;
          hide_gitignored = false;
        };
      };
    };

    keymaps = [
      {
        key = "\\";
        action = "<cmd>Neotree reveal<cr>";
        options.desc = "NeoTree reveal";
      }
    ];
  };
}
