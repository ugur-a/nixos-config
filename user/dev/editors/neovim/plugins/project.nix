{
  programs.nixvim = {
    plugins.project-nvim = {
      enable = true;
      enableTelescope = true;
      silentChdir = false;
    };

    keymaps = [
      # need to use this as soon as I open the app
      # because otherwise the plugin loading order gets messed up or something
      # https://github.com/LazyVim/LazyVim/issues/283#issuecomment-1433390326
      {
        key = "<C-p>";
        action.__raw = "<cmd>lua require('telescope').extensions.project.project{}<cr>";
        options.desc = "Find Projects";
      }
    ];
  };
}
