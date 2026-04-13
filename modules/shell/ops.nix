{pkgs, ...}: {
  devshells.ops = {
    name = "ops";
    packages = with pkgs; [
      awscli2
      terraform
      zsh.out
    ];

    bash.interactive = ''
      if [ -z "$IN_ZSH" ]; then
        export IN_ZSH=1
        export SHELL=${pkgs.zsh}/bin/zsh
        exec ${pkgs.zsh}/bin/zsh -i
      fi

      echo "Welcome to the Ops shell!"
    '';
  };
}
