{
  programs.nixvim = {
    # set the commentstring based on the cursor location in a file
    plugins.ts-context-commentstring.enable = true;

    # Highlight, edit, and navigate code
    # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;

        # Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        incremental_selection = {
          enable = true;
          keymaps = {
            # LazyGit
            init_selection = "<C-space>";
            node_incremental = "<C-space>";
            scope_incremental.__raw = "false";
            node_decremental = "<bs>";
          };

          # There are additional nvim-treesitter modules that you can use to interact
          # with nvim-treesitter. You should go explore a few and see what interests you:
          #
          #    - Show your current context: https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
        };
      };
    };

    # Treesitter + textobjects: https://nix-community.github.io/nixvim/plugins/treesitter-textobjects/index.html
    plugins.treesitter-textobjects = {
      enable = true;
      move = {
        enable = true;
        gotoNextStart.__raw = ''{ ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" }'';
        gotoNextEnd.__raw = ''{ ["]F"] = "@function.outer"; ["]C"] = "@class.outer"; ["]A"] = "@parameter.inner" }'';
        gotoPreviousStart.__raw = ''{ ["[f"] = "@function.outer"; ["[c"] = "@class.outer"; ["[a"] = "@parameter.inner" }'';
        gotoPreviousEnd.__raw = ''{ ["[F"] = "@function.outer"; ["[C"] = "@class.outer"; ["[A"] = "@parameter.inner" }'';
      };
    };
  };
}
