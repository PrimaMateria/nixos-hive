#
# █▄ █ █ ▀▄▀ ▄▀▄ ▄▀▀
# █ ▀█ █ █ █ ▀▄▀ ▄██ workborg
#
# Work laptop, native NixOS with niri + Noctalia.
{
  inputs,
  cell,
}: let
  inherit (cell) bees machines installations system;
in {
  bee = bees.boot;
  imports = [
    machines.workborg
    installations.common
    installations.laptop
    system.docker
    {
      networking.hostName = "workborg";

      # installations.common pins 21.11 for the old hosts; a fresh install
      # starts at the release it is installed with.
      system.stateVersion = inputs.nixpkgs.lib.mkForce "26.11";

      # `nixos-rebuild build-vm --flake .#primamateria-workborg` only.
      virtualisation.vmVariant = {
        users.users.primamateria.initialPassword = "workborg";
        virtualisation = {
          memorySize = 4096;
          cores = 4;
          # Under WSL there is no host OpenGL for QEMU, so the guest renders niri
          # in software (llvmpipe) on a plain virtio GPU. Slow but usable.
          qemu.options = ["-vga none" "-device virtio-vga" "-display gtk"];
          # ssh -p 2222 primamateria@localhost, for reading logs from the host.
          forwardPorts = [
            {
              from = "host";
              host.port = 2222;
              guest.port = 22;
            }
          ];
        };
        services.openssh = {
          enable = true;
          settings.PasswordAuthentication = true;
        };
      };
    }
  ];
}
