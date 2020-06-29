{ config, pkgs, lib, ... }:

let
  sources = import ./nix/sources.nix;
  niv = import sources.niv { inherit pkgs; };
  comma = import sources.comma {};
  # all-hies = import sources.all-hies {};
  # hie = all-hies.selection { selector = p: { inherit (p) ghc865; }; };
  username = builtins.getEnv "USER";
  homeDir = "/Users/${username}";
  nix-direnv = import sources.nix-direnv {};
in
{

  # With an existing `nix.nixPath` entry:
  nix.nixPath = [
    # Add the following to existing entries.
    "nixpkgs-overlays=${homeDir}/.nixpgks/overlays/"
  ];

  imports = [
    <home-manager/nix-darwin>
    ## TODO: have this imported by the machine config and move below config into setup/machine/etc.
    ./setup/darwin
  ];

  home-manager.useUserPackages = true;

  users.users.${username} = {
    home = homeDir;
    description = "${username}'s account";
    shell = pkgs.zsh;
  };

  home-manager.users.${username} = import ./home.nix {
    inherit config;
    inherit pkgs;
    inherit lib;
    inherit username;
    inherit homeDir;
    inherit nix-direnv;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # adoptopenjdk-hotspot-bin-11
    # awscli
    # aws-iam-authenticator
    # aws-sam-cli
    bat
    # cabal-install
    # cabal2nix
    cachix
    # cloudflared
    # curl
    # dep
    direnv

    ## NOTE: I'm using hombrew emacs-plus@27 until I have time to get
    ##       that working with nix-darwin.
    # emacs

    git
    git-crypt
    # ghc
    fd
    fzf
    # eksctl
    # gettext
    # go
    gitAndTools.hub
    gitAndTools.gh
    # haskellPackages.policeman
    jq
    # kubectl
    # kubectx
    # kustomize
    # lastpass-cli
    lorri
    nix-prefetch-git
    oh-my-zsh
    python
    pre-commit
    # sbt
    # skopeo
    starship
    # stylish-haskell
    # telnet
    tree
    vim
    zsh-autosuggestions
    zsh-syntax-highlighting
    # hie
    comma
    wget
    niv.niv
    nixpkgs-fmt
    source-code-pro
    coreutils

    # added after initial setup
    curlFull
    exa
    # glance
    htop
    mosh
    ranger
    readline
    ripgrep
    tig
    tmux
  ];

  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [ source-code-pro ];

  environment.variables = { EDITOR = "vim"; };

  programs.nix-index.enable = true;
  nix.package = pkgs.nix;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 12;
  nix.buildCores = 1;
  nix.trustedUsers = [ "@root" username ];

  nix.binaryCaches = [
    "https://cache.nixos.org"
    "https://cache.dhall-lang.org"
    "https://static-haskell-nix.cachix.org"
    "https://nix-tools.cachix.org"
    "https://amarrella.cachix.org"
    "https://orther.cachix.org"
  ];

  nix.binaryCachePublicKeys = [
    "cache.dhall-lang.org:I9/H18WHd60olG5GsIjolp7CtepSgJmM2CsO813VTmM="
    "static-haskell-nix.cachix.org-1:Q17HawmAwaM1/BfIxaEDKAxwTOyRVhPG5Ji9K3+FvUU="
    "nix-tools.cachix.org-1:ebBEBZLogLxcCvipq2MTvuHlP7ZRdkazFSQsbs0Px1A="
    "amarrella.cachix.org-1:zmoz1peEmIyOEUCAcvODHB3PzbTtDT9qDZFFa0YBIck="
    "orther.cachix.org-1:jmpzDJPbcCSY+jGLbOP8EnwrVZVUqIdUgVpq/62f6vE="
  ];

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "nix-docker";
      sshUser = "root";
      sshKey = "/etc/nix/docker_rsa";
      systems = [ "x86_64-linux" ];
      maxJobs = 6;
      buildCores = 6;
    }
  ];

  nixpkgs.config.allowUnfree = true;

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

}
