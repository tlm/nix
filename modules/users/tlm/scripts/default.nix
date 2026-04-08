{
  lib,
  isDarwin,
  ...
}: {
  imports = lib.optionals isDarwin [
    ./darwin-askpass.nix
  ];
}
