{
  config,
  lib,
  pkgs,
  ...
}: {
  home-manager.users.tlm = {
    home.file.".local/bin/darwin-askpass" = {
      executable = true;
      text = ''
        #!/bin/sh
        osascript -e 'Tell application "System Events" to display dialog "SUDO Password:" default answer "" with hidden answer' -e 'text returned of result' 2>/dev/null
      '';
    };

    home.sessionVariables = {
      SUDO_ASKPASS = "${config.users.users.tlm.home}/.local/bin/darwin-askpass";
    };
  };
}
