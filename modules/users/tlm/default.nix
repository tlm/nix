{
  pkgs,
  lib,
  isDarwin,
  withGui ? false,
  ...
}: {
  imports =
    [
      ./packages/claude.nix
      ./packages/codex.nix
      ./packages/htop.nix
      ./packages/git.nix
      ./packages/zed.nix
      ./scripts
    ]
    ++ lib.optionals isDarwin [
      ./homebrew.nix
      ./packages/nixos-rebuild.nix
    ]
    ++ lib.optionals withGui [
      ./packages/alacritty.nix
      ./packages/firefox.nix
    ];

  home-manager = {
    backupFileExtension = "hm-backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit isDarwin withGui;};
    users.tlm = {config, ...}: {
      imports =
        [
          ./home-manager/gpg.nix
          ./home-manager/ssh.nix
          ./home-manager/starship.nix
          ./home-manager/zsh.nix
        ]
        ++ lib.optionals withGui [
          ./home-manager/1password.nix
        ];
      programs.home-manager.enable = true;
      targets.darwin.copyApps.enable = lib.mkIf isDarwin true;
      home = {
        stateVersion = "25.11";

        packages = with pkgs;
          [
            config.programs.home-manager.package
            go
          ]
          ++ lib.optionals withGui [
            transmission_4-qt6
          ];

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
    };
  };

  users.users.tlm = {
    description = "Thomas Miller";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxsBSstfw6+55P/YPS8PyH6m58hxt3q2RK2OP1P6J/2"
    ];
  };
}
