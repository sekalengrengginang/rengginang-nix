# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # boot kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amdgpu" ];

  # Zram
  zramSwap.enable = true;	
  networking.hostName = "Morfonica"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "id_ID.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable KDE Plasma.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mashiro = {
    isNormalUser = true;
    description = "mashiro";
    extraGroups = [ "networkmanager""libvirtd" "wheel" ];
    packages = with pkgs; [
      
    ];
  };


  # Gnome keyring
  services.gnome.gnome-keyring.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #system wide package
  environment.systemPackages = with pkgs; [
  noto-fonts-cjk-sans
  google-chrome
  firefox
  vscode
  vim
  vlc
  virt-manager
  yt-dlp
  sddm-kcm
  wget
  ];
	
  #Podman
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
    };
  };	


  # Plymouth
  boot.plymouth={
  enable=true;
  theme = "bgrt";
};

  # List services that you want to enable:
  # use flatpak
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome  ];
  
  # Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; 

  system.stateVersion = "Unstable"; # Did you read the comment?

}
