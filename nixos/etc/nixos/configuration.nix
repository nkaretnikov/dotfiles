# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  boot.initrd.luks.devices = [ 
    { name = "main"; device = "/dev/sda2"; preLVM = true; }
  ];

  fileSystems = [ {
    mountPoint ="/";
    device = "/dev/main/main";
  } {
    mountPoint = "/boot";
    device = "/dev/sda1";
  }
  ];

  networking = {
    hostName = "mu";
    nameservers = [ "192.168.0.1" ];
    # Requires 'ssid' and 'psk' in '/etc/wpa_supplicant.conf'.
    wireless.enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus"; # XXX: doesn't work
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Europe/Moscow";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.opensmtpd.enable = true;
  services.opensmtpd.serverConfiguration =
    ''
    listen on lo
    # If you want any other user to receive mail, list them here too.
    table catchall { "@localhost" = nikita }
    # Deliver to ~/Maildir.
    accept for any virtual <catchall> deliver to maildir
    '';

  # Tor and privoxy.
  # Tor ports: 9050, 9063; privoxy: 8118
  # Example: https_proxy=localhost:8118 http_proxy=$https_proxy wget -O - https://check.torproject.org
  services.tor = {
    enable = true;
    client.enable = true;
    client.privoxy.enable = true;
  };
  services.privoxy.enable = true;

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.thinkfan.enable = true;

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    layout = "us,ru";
    xkbOptions = "grp:ctrl_shift_toggle,ctrl:nocaps";
    wacom.enable = true;	# digitalizer

    # Enable the xmonad window manager.
    windowManager.xmonad.enable = true;
    windowManager.xmonad.extraPackages = self: [ self.xmonadContrib ];
    windowManager.default = "xmonad";

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.guest = {
    name = "nikita";
    isNormalUser = true;
    uid = 1000;
    home = "/home/nikita";
    extraGroups = [ "wheel" ];
  };

  nixpkgs.config = {
    firefox = {
      enableGnash = true;
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    acpi
    ant
    aspell
    aspellDicts.en
    autoconf
    automake
    coq
    darcs
    dejavu_fonts
    dmenu           # xmonad
    emacs
    emacs24Packages.bbdb3
    emacs24Packages.colorThemeSolarized
    emacs24Packages.colorTheme
    emacs24Packages.emacsw3m
    emacs24Packages.haskellModeGit
    emacs24Packages.magit
    emacs24Packages.ocamlMode
    emacs24Packages.org
    emacs24Packages.proofgeneral_4_3_pre
    emacs24Packages.scalaMode2
    emacs24Packages.structuredHaskellMode
    evince
    file
    firefoxWrapper
    gcc
    ghostscript
    gimp
    git
    gmrun           # xmonad
    gnumake
    gnupg
    gnutls
    haskellPackages.alex
    haskellPackages.cabal2nix
    haskellPackages.cabalInstall
    haskellPackages.ghc
    haskellPackages.happy
    haskellPackages.hasktags
    libreoffice
    lm_sensors
    maven
    mpc_cli
    mpd
    mplayer
    ncurses
    nix-repl
    openjdk
    pkgconfig
    pmutils
    python
    pythonPackages.pip
    sbt
    scala
    stow            # manage dotfiles
    unzip
    utillinuxCurses
    vlc
    wget
    wgetpaste
    wireshark
    xfontsel
    xlibs.xmessage  # xmonad help
    xsane
    youtube-dl
    zip
  ];

}
