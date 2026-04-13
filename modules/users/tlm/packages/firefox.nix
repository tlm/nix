{pkgs, ...}: {
  home-manager.users.tlm.programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    policies.ExtensionSettings = {
      "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
      };
    };
    profiles.default = {
      settings = {
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      };
    };
  };
}
