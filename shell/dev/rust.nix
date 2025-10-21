{
  pkgs,
  ...
}:
pkgs.mkShell {
  name = "rust";

  buildInputs = with pkgs; [
    clang
    llvmPackages.bintools
    rustup
    systemd
    stdenv.cc
  ];
  nativeBuildInputs = [ pkgs.pkg-config ];
}
