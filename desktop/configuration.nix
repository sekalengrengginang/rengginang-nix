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
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.timeout =0;
  # boot kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams = [ "quiet" ];
  # Zram
  zramSwap.enable = true;	
  networking.hostName = "foo"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";
  time.hardwareClockInLocalTime=true;

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
  users.users.foo = {
    isNormalUser = true;
    description = "foo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      
    ];
  };
  
  # Gnome keyring
  services.gnome.gnome-keyring.enable = true;  
  security.pam.services.sddm.enableGnomeKeyring = true;
  # Nvidia
  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.opengl.driSupport32Bit = true; 
  # Steam
   programs.steam = {
    enable = true;
  };


  # Internal HDD
  fileSystems."/mnt/foo"={
  device ="/dev/disk/by-label/foo";
  fsType = "auto"; 
  };
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Plasma browser
  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  # Power-profiles
  services.power-profiles-daemon.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #fonts
  noto-fonts-cjk-sans
  # browser
  google-chrome
  google-chrome-beta
  firefox

  # dev
  vscode

  # multimedia
  vlc   
  # misc
  htop
  kate
  neofetch
  kde-gtk-config
  wget
  plasma-browser-integration
  power-profiles-daemon
  ];
	
  # Storage optimization
  nix.settings.auto-optimise-store = true;
  nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 30d";
  };

  # Btrfs compression
  fileSystems = {
  "/".options = [ "compress=zstd" ];
  "/home".options = [ "compress=zstd" ];
  "/var".options = [ "compress=zstd"  ];
  "/nix".options =["compress=zstd" "noatime"];
  };

  # List services that you want to enable:

  # use flatpak
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome  ];

  
  system.stateVersion = "22.05";

}
