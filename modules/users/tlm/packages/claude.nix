{pkgs, ...}: {
  home-manager.users.tlm = {
    home.packages = with pkgs; [
      claude-code-acp
    ];

    programs.claude-code = {
      enable = true;
      package = pkgs.claude-code;
      
      settings = {
        
      };
    };
  };
}
