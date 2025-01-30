# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  
  hardware.pulseaudio.enable = false;
  security.polkit.enable = true;
  security.rtkit.enable = true;
  users.users.brice = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ]; # Enable ‘sudo’ for the user.
  };

  nix.settings = {
    # auto-optimize-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  programs.light.enable = true;
  programs.firefox.enable = true; 
  programs.ssh.startAgent = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    package = "${pkgs.greetd.wlgreet}";
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "brice";
      };
    };
  };


  security.pam.services.swaylock = {};
  security.pam.services.greetd = {};
  services.gnome.gnome-keyring.enable = true;
  home-manager.useUserPackages = true;
  home-manager.users.brice = { config, pkgs, ... }: let
    pkgs-unstable = import <nixpkgs-unstable> { system = "${pkgs.system}"; };
  in {
    nixpkgs.config = {
      allowUnfree = true;
    };
    
    wayland.windowManager.sway = {
      enable = true;
      config = rec {
        terminal = "ghostty";
      };
      extraConfig = ''
        
        # uninvert scrolling
        input "type:touchpad" {
          natural_scroll enabled
        }
        # lock
        bindsym Mod1+ctrl+l exec swaylock -i ~/Pictures/water-lily.jpg -s fill
        # brightness
        bindsym XF86MonBrightnessDown exec light -U 10
        bindsym XF86MonBrightnessUp exec light -A 10

        # volume
        bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
        bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
        bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
      '';
    };

    # programs.ghostty = {
    #   enable = true;
    # };

    # programs.helix = {
    #   enable = true;
    # };
    
    home.packages = [
      pkgs.pulseaudio
      pkgs.greetd.wlgreet
      pkgs.swaylock
      pkgs.swaybg
      pkgs.mako
      pkgs.slurp
      pkgs.grim
      pkgs.wl-clipboard

      pkgs.git
      pkgs.jujutsu
      pkgs.acpi
      pkgs.fastfetch
      pkgs.python3
      pkgs.zig
      pkgs.zls
      pkgs.clang-tools
      pkgs.ghostty
      pkgs.yazi
      pkgs.fish
      pkgs.helix

      pkgs.mpv
      pkgs.kitty
    ];

    home.stateVersion = "24.11";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

