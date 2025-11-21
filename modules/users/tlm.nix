{ pkgs, ... }:
{
  users.users.tlm = {
    description = "Thomas Miller";
    shell = pkgs.zsh;
    isHidden = false;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxsBSstfw6+55P/YPS8PyH6m58hxt3q2RK2OP1P6J/2"
    ];
  };
}
