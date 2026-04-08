{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles.default = {
      extensions = {
        packages = with pkgs; [
          #nur.repos.rycee.firefox-addons.onepassword-password-manager
        ];
      };
    };
  };
}
