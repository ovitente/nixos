{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#     ./ssh-agent.nix
    ];

    nixpkgs.overlays = [
    (self: super: {
      awesome = super.awesome.overrideAttrs (old: rec {
        pname = "awesome";
        version = "git-20220614-3a54221";
        src = super.fetchFromGitHub {
          owner = "awesomeWM";
          repo = "awesome";
          rev = "3a542219f3bf129546ae79eb20e384ea28fa9798";
          sha256 = "4z3w6iuv+Gw2xRvhv2AX4suO6dl82woJn0p1nkEx3uM=";

        };
        patches = [];
        buildInputs = (old.buildInputs or []) ++ [ pkgs.gobject-introspection pkgs.gtk3 pkgs.playerctl ];
      });
    })
  ];

  # X ----------------------------------------

  virtualisation.vmware.guest.enable = true;

  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+awesome";
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      luarocks # is the package manager for Lua modules
      luadbi-mysql # Database abstraction layer
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "det";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Bootloader ----------------------------------------

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

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

  # Sound ----------------------------------------

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Users ----------------------------------------

  users.defaultUserShell=pkgs.zsh; 

  users.users.root = {
    shell = pkgs.zsh;
  };

  users.users.det = {
    isNormalUser = true;
    description = "det";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" ];
  };
  
  # enable zsh and oh my zsh
  programs = {
     zsh = {
        enable = true;
        autosuggestions.enable = true;
        zsh-autoenv.enable = true;
        syntaxHighlighting.enable = true;
        ohMyZsh = {
           enable = true;
           theme = "robbyrussell";
           plugins = [

             "git"
             "history"
             "deno"
	     "gcloud"
	     "vi-mode"
	     "kubectl"
	     "helm" 
	   ];
        };
     };
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
    xfce.xfwm4
    capitaine-cursors
    catppuccin-cursors.mochaGreen
    curl
    dmidecode
    dunst
    ffmpeg
    firefox
    freerdp
    devbox
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
    sddm
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

  services.openssh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  time.timeZone = "Europe/Bucharest";

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

  system.stateVersion = "23.11";

}

