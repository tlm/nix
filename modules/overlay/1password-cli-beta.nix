{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    version = "2.34.1-beta.01";
    srcInfo =
      {
        aarch64-darwin = {
          url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_apple_universal_v${version}.pkg";
          hash = "sha256-08FRYf+s2HljsG3lT2S26IMh6yyFwpVMVN+3j1GlqO4=";
        };
        x86_64-darwin = {
          url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_apple_universal_v${version}.pkg";
          hash = pkgs.lib.fakeHash;
        };
        aarch64-linux = {
          url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_linux_arm64_v${version}.zip";
          hash = "sha256-eoEjnXHLlsU04P/9El+9oD0nCD/g7d/HF/mOjhEUA+Y=";
        };
        x86_64-linux = {
          url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_linux_amd64_v${version}.zip";
          hash = "sha256-aCntXecAbKSXJgTewMElUUoogNQPC8PXknKjP4B8+Js=";
        };
      }
      .${
        system
      };
  in {
    overlayAttrs = {
      _1password-cli-beta = pkgs._1password-cli.overrideAttrs (_: {
        inherit version;
        src = pkgs.fetchurl {
          inherit (srcInfo) url hash;
        };
      });
    };
  };
}
