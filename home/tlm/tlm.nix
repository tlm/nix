{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  pkgs-23-11,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      zed-editor = prev.zed-editor.overrideAttrs (old: rec {
        version = "208.5";
      });
    })
  ];

  imports = [
    ./git.nix
    ./gpg.nix
    ./op.nix
    ./ssh.nix
    ./zed.nix
  ];

  home = {
    homeDirectory = "/home/tlm";

    packages = [
      pkgs.go
      pkgs.gopls
      pkgs.docker
      pkgs.delve
      pkgs.htop
      pkgs.kubectl
      pkgs.minikube
      pkgs.sqlite
      pkgs.vim

      pkgs.pyright
      (pkgs.python3.withPackages (
        ps: with ps; [
          pip
          virtualenv
          flake8
          pylint
          python-lsp-server
        ]
      ))
    ];

    username = "tlm";
    stateVersion = "24.11";
  };

  programs = {
    home-manager.enable = true;
  };

  programs.tmux = {
    enable = true;
    customPaneNavigationAndResize = true;
    prefix = "C-a";
    keyMode = "vi";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "[](color_orange)"
        "$username$hostname"
        "[](bg:color_yellow fg:color_orange)"
        "$directory"
        "[](fg:color_yellow bg:color_aqua)"
        "[](fg:color_aqua bg:color_purple)"
        "$nix_shell"
        "[](fg:color_purple bg:color_bg1)"
        "$character"
        "[ ](fg:color_bg1)"
      ];
      palette = "solarized_dark";
      palettes.gruvbox_dark = {
        color_fg0 = "#fbf1c7";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#d79921";
      };
      palettes.solarized_dark = {
        color_fg0 = "#eee8d5";
        color_bg1 = "#073642";
        color_bg3 = "#586e75";
        color_blue = "#268bd2";
        color_aqua = "#2aa198";
        color_green = "#859900";
        color_orange = "#cb4b16";
        color_purple = "#6c71c4";
        color_red = "#dc322f";
        color_yellow = "#b58900";
      };
      username = {
        show_always = true;
        style_user = "bg:color_orange fg:color_fg0";
        style_root = "bg:color_orange fg:color_fg0";
        format = "[$user]($style)";
      };
      hostname = {
        ssh_only = true;
        ssh_symbol = "🐕";
        style = "bg:color_orange fg:color_fg0";
        format = "[$ssh_symbol$hostname in ]($style)";
      };
      directory = {
        style = "fg:color_fg0 bg:color_yellow";
        format = "[ $path ]($style)";
        truncation_length = 2;
        truncation_symbol = "…/";
      };
      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
        truncation_length = 10;
      };
      git_status = {
        style = "bg:color_aqua";
        format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
      };
      nix_shell = {
        format = "[ $symbol ($name)]($style)";
        symbol = "󱄅";
        style = "fg:color_fg0 bg:color_purple";
      };
      line_break = {
        disabled = true;
      };
      character = {
        disabled = false;
        format = "[ ](bg:color_bg1)$symbol";
        success_symbol = "[#](fg:color_aqua bg:color_bg1)";
        error_symbol = "[#](fg:color_red bg:color_bg1)";
        vimcmd_symbol = "[#](fg:color_green bg:color_bg1)";
        vimcmd_replace_one_symbol = "[#](fg:color_purple bg:color_bg1)";
        vimcmd_replace_symbol = "[#](fg:color_purple bg:color_bg1)";
        vimcmd_visual_symbol = "[#](fg:color_yellow bg:color_bg1)";
      };
    };
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    defaultKeymap = "viins";
    syntaxHighlighting.enable = true;

    initContent = ''
      eval "$(starship init zsh)"
      bindkey 'jj' vi-cmd-mode
    '';

    sessionVariables = {
      EDITOR = "vim";
      GOWORK = "off";
      SYSTEMD_LESS = "FRXMK";
    };

    shellAliases = {
      ".." = "cd ..";
      l = "ls -lah";
    };
  };
}
