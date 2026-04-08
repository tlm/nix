{pkgs, ...}: {
  home-manager.users.tlm = {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;

      settings = {
        init.defaultBranch = "main";

        user = {
          email = "thomas@tlm.id.au";
          name = "tlm";
          userConfigOnly = true;
        };
      };

      ignores = [
        ".DS_store"
        ".idea"
        "*.swp"
        ".envrc"
        ".direnv"
        ".zed"
      ];
      includes = [
        {
          condition = "gitdir:~/projects/canonical/";
          path = "~/.config/git/canonical-config";
        }
      ];

      signing = {
        key = "172A0C8C!";
        signByDefault = true;
      };
    };

    home.file.".config/git/canonical-config".text = ''
      [user]
      name = Thomas Miller
      email = thomas.miller@canonical.com
    '';
  };
}
