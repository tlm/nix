{ ... }:
{
  programs.git = {
    enable = true;

    userEmail = "thomas@tlm.id.au";
    userName = "tlm";

    extraConfig = {
      init.defaultBranch = "main";
      user.useConfigOnly = true;
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
}
