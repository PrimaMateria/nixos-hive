{pkgs, ...}: {
  home.packages = with pkgs; [
    git-crypt
    gnupg
  ];

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
  };
}
