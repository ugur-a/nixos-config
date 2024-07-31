{
  programs.nixvim = {
    # Fuzzy Finder (files, lsp, etc)
    # https://nix-community.github.io/nixvim/plugins/telescope/index.html
    plugins.telescope = {
      # Configure Telescope
      # See `:help telescope` and `:help telescope.setup()`
      enable = true;

      # Enable Telescope extensions
      extensions = {
        fzf-native.enable = true;
        ui-select.enable = true;
      };

      # Map Telescope builtin actions
      #  See `:help telescope.builtin`
      keymaps =
        let
          # inspired by LazyVim.pick()
          map_telescope_action = action: desc: {
            inherit action;
            options.desc = desc;
          };
        in
        {
          "<leader>sh" = (map_telescope_action "help_tags" "[S]earch [H]elp");
          "<leader>sk" = (map_telescope_action "keymaps" "[S]earch [K]eymaps");
          "<leader>sf" = (map_telescope_action "find_files" "[S]earch [F]iles");
          "<leader>ss" = (map_telescope_action "builtin" "[S]earch [S]elect Telescope");
          "<leader>sw" = (map_telescope_action "grep_string" "[S]earch current [W]ord");
          "<leader>sg" = (map_telescope_action "live_grep" "[S]earch by [G]rep");
          "<leader>sd" = (map_telescope_action "diagnostics" "[S]earch [D]iagnostics");
          "<leader>sr" = (map_telescope_action "resume" "[S]earch [R]esume");
          "<leader>s" = (map_telescope_action "oldfiles" "[S]earch Recent Files ('.' for repeat)");
          "<leader><leader>" = (map_telescope_action "buffers" "[ ] Find existing buffers");
        };
      settings = {
        extensions.__raw = "{ ['ui-select'] = { require('telescope.themes').get_dropdown() } }";
      };
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      # Slightly advanced example of overriding default behavior and theme
      {
        mode = "n";
        key = "<leader>/";
        # You can pass additional configuration to Telescope to change the theme, layout, etc.
        action.__raw = ''
          function()
            require('telescope.builtin').current_buffer_fuzzy_find(
              require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false
              }
            )
          end
        '';
        options.desc = "[/] Fuzzily search in current buffer";
      }
      {
        mode = "n";
        key = "<leader>s/";
        # It's also possible to pass additional configuration options.
        #  See `:help telescope.builtin.live_grep()` for information about particular keys
        action.__raw = ''
          function()
            require('telescope.builtin').live_grep {
              grep_open_files = true,
              prompt_title = 'Live Grep in Open Files'
            }
          end
        '';
        options.desc = "[S]earch [/] in Open Files";
      }
      # Shortcut for searching your Neovim configuration files
      {
        mode = "n";
        key = "<leader>sc";
        action.__raw = ''
          function()
            require('telescope.builtin').find_files {
              cwd = vim.fn.stdpath 'config'
            }
          end
        '';
        options.desc = "[S]earch [C]onfig";
      }
      # 
      {
        mode = "n";
        key = "<leader>fd";
        action.raw = ''
          function()
            require("telescope.builtin").find_files {
              cwd = "~/.dotfiles"
            }
          end
        '';
        options.desc = "[F]ind [D]otfiles";
      }
      {
        mode = "n";
        key = "<leader>sd";
        action.__raw = ''
          function()
            require("telescope.builtin").live_grep {
              cwd = "~/.dotfiles"
            }
          end
        '';
        options.desc = "Grep Dotfiles";
      }
      # Prevent builtin colors from being displayed in the picker
      {
        mode = "n";
        key = "<leader>uc";
        action.__raw = ''
          function()
            -- stylua: ignore
            local builtins = { "zellner", "torte", "slate", "shine", "ron", "quiet", "peachpuff",
              "pablo", "murphy", "lunaperche", "koehler", "industry", "evening", "elflord",
              "desert", "delek", "default", "darkblue", "blue", "morning"}

            local target = vim.fn.getcompletion

            ---@diagnostic disable-next-line: duplicate-set-field
            vim.fn.getcompletion = function()
              return vim.tbl_filter(function(color)
                return not vim.tbl_contains(builtins, color)
              end, target("", "color"))
            end

            LazyVim.pick("colorscheme", { enable_preview = true })()
            vim.fn.getcompletion = target
          end,
        '';
        options.desc = "Colorscheme with Preview";
      }
    ];
  };
}
