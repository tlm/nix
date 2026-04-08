{...}: {
  home-manager.users.tlm = {
    programs.alacritty = {
      enable = true;

      settings = {
        font.size = 15;
        window.dimensions = {
          columns = 120;
          lines = 100;
        };
      };
    };
  };
}
