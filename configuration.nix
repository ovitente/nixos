# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; #or "nodev" for efi only
  

# Networking ----------------------------------------
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.extraHosts =
  ''
    127.0.0.1 lostfilm.today
    127.0.0.1 lostfilm.tv
    127.0.0.1 pikabu.ru
    127.0.0.1 fishki.net
  '';



# X ----------------------------------------
services.xserver = {
  enable = true;

  displayManager = {
      sddm.enable = true;
      defaultSession = "none+awesome";
  };

  windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      luarocks # is the package manager for Lua modules
      luadbi-mysql # Database abstraction layer
    ];

  };
};

# Sound ----------------------------------------

  # Enable sound with pipewire.
  services.pipewire.wireplumber.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.vmware.guest.enable = true;

# Users ----------------------------------------

  programs.zsh.enable = true;
  users.users.det = {
    isNormalUser = true;
    description = "det";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
  };

# Packages ----------------------------------------

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware  = true;

  environment.systemPackages = with pkgs; [
    _1password-gui
    alacritty
    alsa-tools
    alsa-utils
    anydesk
    appimage-run
    arandr
    capitaine-cursors
    catppuccin-cursors.mochaGreen
    curl
    dmidecode
    dunst
    ffmpeg
    firefox
    freerdp
    fzf
    gcolor3
    git
    glxinfo
    google-chrome
    grim
    htop
    i3lock-fancy
    inetutils
    inxi
    jq
    killall
    kitty
    krita
    ksnip
    kubernetes-helm
    libsForQt5.qtstyleplugin-kvantum
    libvdpau-va-gl
    lxappearance
    neovim
    nitrogen
    nix-index
    nmap
    open-vm-tools
    pavucontrol
    pciutils
    picom
    pulseaudioFull
    pwgen
    python3
    qbittorrent
    ranger
    rofi-power-menu
    rsync
    simplescreenrecorder
    slack
    socat
    tdesktop
    teamspeak_client
    thunderbird
    tig
    tmux
    tree
    unzip
    virtualenv
    vlc
    watch
    wget
    xorg.xdpyinfo
    xsel
    yt-dlp
    zoom-us
    zsh
  ];

# System ----------------------------------------

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [
     "CodeNewRoman"
     "DroidSansMono"
     "FiraCode"
     "JetBrainsMono"
     "IBMPlexMono"
     "Iosevka"
     "Mononoki"
     "SourceCodePro"
     ]; })
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

# Touchpad support (enabled default in most desktopManager).
services.xserver.libinput.enable = true;


  environment.etc."current-system-packages".text =
    let
      packages = builtins.map
        (p: "${p.name}")
        config.environment.systemPackages;
      sortedUnique = builtins.sort
        builtins.lessThan
        (lib.unique packages);
      formatted = builtins.concatStringsSep
        "\n"
        sortedUnique;
    in
    formatted;

  hardware.bluetooth.enable = true;

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  system.stateVersion = "23.11"; # Did you read the comment?
}
