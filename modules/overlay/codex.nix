{lib, ...}: {
  perSystem = {pkgs, ...}: {
    overlayAttrs = {
      codex = pkgs.mkBwrapper {
        app = {
          package = pkgs.codex;
          runScript = "codex";
        };
        mounts = {
          read = lib.mkForce [];
          readWrite = ["$PWD"];
        };
        sockets.x11 = false;
      };
    };
  };
}
