{pkgs, ...}: {
  home-manager.users.tlm = {
    home.packages = with pkgs; [
      codex-acp
    ];

    programs.codex = {
      enable = true;
      package = pkgs.codex;
    };
  };
}
