{
  pkgs,
  lib,
  ...
}: {
  home-manager.users.tlm = {
    home.packages = with pkgs; [
      alejandra
      nixd
      nerd-fonts.zed-mono
      gopls
    ];

    programs.zed-editor = {
      enable = true;

      extraPackages = with pkgs; [
        nodejs
      ];

      extensions = ["nix" "sql"];
      mutableUserKeymaps = false;
      mutableUserTasks = false;
      mutableUserSettings = true;
      userKeymaps = [
        {
          bindings = {
            "ctrl-=" = ["workspace::SendKeystrokes" "ctrl-0"];
            "ctrl--" = "workspace::ToggleBottomDock";
            "ctrl-0" = "workspace::ToggleLeftDock";
            "ctrl-9" = "workspace::ToggleRightDock";
            "ctrl-h" = "workspace::ActivatePaneLeft";
            "ctrl-l" = "workspace::ActivatePaneRight";
            "ctrl-j" = "workspace::ActivatePaneDown";
            "ctrl-k" = "workspace::ActivatePaneUp";
            "ctrl-o" = "workspace::ToggleZoom";
            "ctrl-i" = "outline::Toggle";
            "ctrl-shift-i" = "outline_panel::ToggleFocus";
          };
        }
        {
          context = "Editor && vim_mode==normal";
          bindings = {
            "_" = ["workspace::SendKeystrokes" "\" _"];
          };
        }
        {
          context = "Editor && vim_mode==insert";
          bindings = {
            "shift-i" = null;
            "shift-t" = null;
            "j j" = "vim::SwitchToNormalMode";
          };
        }
        {
          context = "Editor";
          bindings = {
            "cmd-b" = "editor::GoToDefinition";
            "cmd-r" = "editor::FindAllReferences";
            "cmd-t" = ["task::Spawn" {task_name = "current-test";}];
          };
        }
        {
          context = "Terminal";
          bindings = {
            "ctrl-k up" = null;
            "ctrl-k down" = null;
            "ctrl-k left" = null;
            "ctrl-k right" = null;
            "ctrl-k" = "workspace::ActivatePaneUp";
            "ctrl-h" = "workspace::ActivatePaneLeft";
            "ctrl-l" = "workspace::ActivatePaneRight";
            "ctrl-j" = "workspace::ActivatePaneDown";
          };
        }
      ];
      userSettings = {
        agent_servers = {
          claude-acp = {
            type = "registry";
            env = {
              CLAUDE_CODE_EXECUTABLE = "claude";
            };
          };
          nix_codex = {
            type = "custom";
            command = "${pkgs.codex-acp}/bin/codex-acp";
            args = [];
          };
        };
        auto_update = false;
        base_keymap = "VSCode";
        "experimental.theme_overrides" = {
          "editor.active_wrap_guide" = "#FFFFFF";
          "editor.wrap_guide" = "#FFFFFF";
        };
        buffer_font_family = "ZedMono Nerd Font";
        buffer_font_size = 17;
        edit_predictions = {
          provider = "zed";
          mode = "eager";
        };
        languages = {
          go = {
            remove_trailing_whitespace_on_save = false;
            tab_size = 4;
            use_autoclose = false;
          };
          Nix = {
            formatter = {
              external = {
                arguments = ["--quiet" "--"];
                command = "alejandra";
              };
            };
            language_servers = ["nixd" "!nil"];
          };
          SQL = {
            format_on_save = "off";
          };
        };
        lsp = {
          go = {
            binary = {
              path = lib.getExe pkgs.gopls;
            };
          };
        };
        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };
        remove_trailing_whitespace_on_save = false;
        show_edit_predictions = true;
        show_whitespaces = "all";
        show_wrap_guides = true;
        theme = {
          dark = "One Dark";
          light = "Gruvbox Light Hard";
          mode = "system";
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        terminal = {
          line_height = "standard";
        };
        vim_mode = true;
        whitespace_map = {
          space = ".";
          tab = "→";
        };
        wrap_guides = [80 120];
      };
    };
  };
}
