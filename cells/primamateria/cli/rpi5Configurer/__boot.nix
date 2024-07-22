{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;

  extra = ''
    # Disable all LEDs
    dtparam=pwr_led_trigger=default-on
    dtparam=pwr_led_activelow=off
    dtparam=act_led_trigger=none
    dtparam=act_led_activelow=off
    dtparam=eth_led0=4
    dtparam=eth_led1=4
  '';

  # merge default config that came with raspbian installation with my extra
  bootConfig = nixpkgs.writeText "boot-firmware-config.txt" ''
    # For more options and information see
    # http://rptl.io/configtxt
    # Some settings may impact device functionality. See link above for details

    # Uncomment some or all of these to enable the optional hardware interfaces
    #dtparam=i2c_arm=on
    #dtparam=i2s=on
    #dtparam=spi=on

    # Enable audio (loads snd_bcm2835)
    dtparam=audio=on

    # Additional overlays and parameters are documented
    # /boot/firmware/overlays/README

    # Automatically load overlays for detected cameras
    camera_auto_detect=1

    # Automatically load overlays for detected DSI displays
    display_auto_detect=1

    # Automatically load initramfs files, if found
    auto_initramfs=1

    # Enable DRM VC4 V3D driver
    dtoverlay=vc4-kms-v3d
    max_framebuffers=2

    # Don't have the firmware create an initial video= setting in cmdline.txt.
    # Use the kernel's default instead.
    disable_fw_kms_setup=1

    # Run in 64-bit mode
    arm_64bit=1

    # Disable compensation for displays with overscan
    disable_overscan=1

    # Run as fast as firmware / board allows
    arm_boost=1

    ${extra}

    [cm4]
    # Enable host mode on the 2711 built-in XHCI USB controller.
    # This line should be removed if the legacy DWC2 controller is required
    # (e.g. for USB device mode) or if USB support is not required.
    otg_mode=1

    [all]
  '';
in ''
  echo
  echo "Configuring /boot/firmaware/config.txt"
  echo "--------------------------------------"

  if [ ! -f "/boot/firmware/config.backup.txt" ]; then
    # Backup original /boot/firmware/config.txt
    sudo cp /boot/firmware/config.txt /boot/firmware/config.backup.txt
  fi

  # Copy custom config from the nix store
  sudo cp ${bootConfig} /boot/firmware/config.txt
  echo "Updated config.txt"
''
