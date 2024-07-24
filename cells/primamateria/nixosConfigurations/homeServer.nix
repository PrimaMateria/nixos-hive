#
# █▄ █ █ ▀▄▀ ▄▀▄ ▄▀▀
# █ ▀█ █ █ █ ▀▄▀ ▄██ homeServer
#
{
  inputs,
  cell,
}: let
  inherit (cell) bees machines installations system devices;
in {
  bee = bees.boot;

  imports = [
    machines.beelink
    installations.common
    installations.headless
    system.networkingHome
    system.docker
    {
      networking.hostName = "homeServer";
      services.openssh.enable = true;
      networking.firewall.enable = false;
      users.users.primamateria.openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDw0LKRd+NOf/ZwwmkrzjJkKXnNoXQ1cHuNTtbo+clIsXs29Km4TSCMtE1Dtc/u9NVhC2BfJT2n2H4KAt00KbwTcglW+BmKqUOHPxU/3++2m/4I9yfkBAxJf5rM+AJfXu2B/b5M5Jj1H1IaWPlLMeO9JoNy4FWL3joIyzxptMCAKKjiEU3kJ9hr/g0DMMzKCQ3QRC4bzdPEPqFr4/DXopIlygzFy+rXQw59EamkyNxq3QP6yBYYPZYO4kEySS8Gb4kSoEoCzfYEJ7WtQDGmPm9c90MT8YXeeaIogAboOyBO/alJU6yRgC1mK51cyM9JOY5+dFv+uMYU2rdrDlNHuix1b+3TCTwwd2+Ft8/mV075prvJY99pSjGbN2OYzP9I5urDfDJURLwC+T5hodaVe6P3NlN0M2LF8HSqsdUXE2tfu46s13AEej7wErrXa3NOxb9wUgjuwBQ65ElULFDNloq/XJGv1lYN+EsgGSU10mWm++ARdExKiese6rJGS9Vc2U6LXryKHYM7+FrvTKcUm4AYRhiaAPPNPiMf2EQ+ONxIxhkZXLOl0KVaRZgifqsgtMKeWD7LJmRJSbH9ugChd2qfQ+RYPDMJQBlMOA6w2NfSaU03wPn9xSMRPxoiThGv9g9rfDLWJEUJwumb0hdUPc+HJxxbOm4I6Wj0mNWKCH8VZw== primamateria@gg"
      ];
    }
  ];
}
