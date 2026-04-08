{...}: {
  imports = [
    ../../users/tlm
  ];

  users.users.tlm = {
    home = "/home/tlm";
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "lxd"
    ];
  };
}
