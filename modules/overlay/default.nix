{...}: {
  imports = [
    #./bubblewrap.nix
    #./codex.nix
    ./claude.nix
    ./codex-acp.nix
    ./go.nix
    ./nixos-rebuild.nix
    ./zed.nix
  ];
}
