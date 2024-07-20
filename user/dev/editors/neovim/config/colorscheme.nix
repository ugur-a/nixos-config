{
  # You can easily change to a different colorscheme.
  # Add your colorscheme here and enable it.
  #
  # If you want to see what colorschemes are already installed, you can use `:Telescope colorschme`.
  programs.nixvim = {
    colorscheme = "rose-pine";
    colorschemes = {
      rose-pine = {
        enable = true;
        settings = {
          style = "auto";
          dark_variant = "moon";
        };
      };
    };
  };
}
