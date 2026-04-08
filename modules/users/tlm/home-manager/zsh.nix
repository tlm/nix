{...}: let
  tlmNixFlake = "$HOME/projects/tlm/nix";
in {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    defaultKeymap = "viins";
    syntaxHighlighting.enable = true;

    initContent = ''
      #eval "$(starship init zsh)"
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
      go-dev = "nix develop ${tlmNixFlake}#go";
      juju-dev = "nix develop ${tlmNixFlake}#juju";
    };
  };
}
