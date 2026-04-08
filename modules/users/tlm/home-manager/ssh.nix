{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks."tlm-rig" = {
      forwardAgent = true;
    };
  };
}
