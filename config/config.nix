{ pkgs, lib, ... }:
let
  # Fed to nix-ld only. nix-ld intercepts unpatched foreign ELFs and never
  # overrides a nix-built binary's own RPATH, so this list can be generous.
  nixLdLibs = with pkgs; [
    # C++ / compiler runtime
    stdenv.cc.cc.lib
    libgcc

    # compression
    zlib
    bzip2
    xz
    zstd

    # crypto / TLS
    openssl
    libgpg-error
    libgcrypt

    # networking
    curl

    # common system libs
    glib
    libffi
    readline
    ncurses
    sqlite
    libxml2
    libxslt
    util-linux  # libuuid, libmount, libblkid
    udev        # libudev
    pcre2

    # image formats
    libpng
    libjpeg
    libtiff

    # audio
    alsa-lib
    libpulseaudio

    # graphics / display
    nss
    nspr
    dbus
    atk
    cups
    libdrm
    expat
    libxkbcommon
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
    mesa
    wayland
    pango
    cairo
    icu
    freetype
    fontconfig
  ];

  # Fed to LD_LIBRARY_PATH, which outranks every binary's own RPATH — including
  # nix-built ones. Anything listed here is forced on Firefox, Chromium, git,
  # etc., so a lib built against a different nixpkgs rev than theirs breaks
  # them outright (e.g. nss here shadows comma's newer firefox and it won't
  # start). Keep this to what pip C-extensions actually link against; put
  # graphics, crypto, and text-processing libs in nixLdLibs only.
  pipLibs = with pkgs; [
    stdenv.cc.cc.lib
    libgcc

    zlib
    bzip2
    xz
    zstd

    openssl
    libffi
    readline
    ncurses
    sqlite
  ];
in
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.zsh.enable = true;
  programs.nix-index-database.comma.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = nixLdLibs;
  };

  # nix-ld only intercepts unpatched ELF loaders; nixpkgs Python uses the nix
  # store's ld directly, so pip C-extensions need LD_LIBRARY_PATH instead.
  environment.sessionVariables.LD_LIBRARY_PATH = lib.makeLibraryPath pipLibs;
  programs.zsh.shellInit = ''
    export LD_LIBRARY_PATH="${lib.makeLibraryPath pipLibs}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  '';

  users.users.wolf = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDqexLCM6mY78L0mtyvS8HUecfuFBfcI4BaMFPk7moYIDISDxVQbvLvXkgJqWfrOgBxBRIjAzdLi5oa0es1LukTPEb1R+MP/FgJeo+CYAgPFGohY+feYU6Am8Md7euSXnzIv4rNkJI/UokkuOfjw7oxFVSbAtJJUFsDEspY1153RkrUidyeQPE5zp9LfLKR4YHgS6z9RQi7yGVX0+VWTBaDi1tUtSxxYn1J4iOd4a2SFzAnRAnw5AMvX66XZFmDFoHU2/iqq4aGE3f08J/WwUIfO6S1uosDB/K1jiJ1lTDEQYuV1g+nQzxzmwwNzl67hq93h82XbMd/wIh6i8yGriEh6uwNvddfhpev4mY0b+WppEHhAqq3wHqdv7WpINQYpcZY6+i70TiW2xyRAM/75HP4JQkj4TESwmB34Nqs8uXXtEbH95w1BLpwdGXTVaPUCZY6gAYGcuicZBDh+QFe2e0D0BronVaEVcWE03UmnPdAjb3tdiwpJ1mgPSVx1FG7h3TXCc50AMR4BCPFt5qxJ1U14ebu5EWlKDCeVJ+zDyYJxXUSKPYdqvSii6gbeddqA/WKt54teQ2eV6kKLfInbevdfjyEIzPAbnvidahntwmNoDRU1IxodXMXbBps9jBWHbxpLLzk0yK+9C8XpyNGU901LGQxMexr5z3W+aBgxIXy7Q== wolf@404wolf.com"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    waypipe
    zed-editor
    waypipe
    gnupg
    neovim
    git
    btop
    htop
    awscli2
  ];

  environment.sessionVariables.EDITOR = "zeditor --wait";

  system.stateVersion = "25.05";
}
