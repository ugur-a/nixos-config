{
  programs.nixvim = {
    plugins.rustaceanvim = {
      enable = true;
      server.default_settings.rust-analyzer = {
        imports.preferNoStd = true;
        inlayHints = {
          closureCaptureHints.enable = true;
          closureReturnTypeHints.enable = "with_block";
          lifetimeElisionHints = {
            enable = "skip_trivial";
            useParameterNames = true;
          };
        };
      };
    };
  };
}
