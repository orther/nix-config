{ config, pkgs, lib, username, homeDir, nix-direnv, ... }:
let
  cfg = config.home-manager.users.${username};
  xdgConfigHomeRelativePath = ".config";
  xdgDataHomeRelativePath = ".local/share";
  xdgCacheHomeRelativePath = ".cache";

  xdgConfigHome = "${homeDir}/${xdgConfigHomeRelativePath}";
  xdgDataHome = "${homeDir}/${xdgDataHomeRelativePath}";
  xdgCacheHome = "${homeDir}/${xdgCacheHomeRelativePath}";

in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bat.enable = true;
  home.file.".iterm2_shell_integration.zsh".source = ./home/.iterm2_shell_integration.zsh;
  home.file."${xdgCacheHome}/oh-my-zsh/.keep".text = "";
  home.file."${xdgConfigHome}/git/.keep".text = "";
  ##home.file.".ghci".source = ./home/.ghci;

  xdg = {
    enable = true;
    configHome = xdgConfigHome;
    dataHome = xdgDataHome;
    cacheHome = xdgCacheHome;
  };

  programs.gpg.enable = true;
  home.file.".gnupg/gpg-agent.conf".text =
    ''
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
      enable-ssh-support
      default-cache-ttl 86400
      max-cache-ttl 86400
    '';

  programs.ssh = {
    enable = true;
    matchBlocks.nix-docker = {
      hostname = "127.0.0.1";
      user = "root";
      port = 3022;
      identityFile = "/etc/nix/docker_rsa";
      extraOptions={
        StrictHostKeyChecking="no";
      };
    };
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa-arson
    matchBlocks."github.com" = {
      identitiesOnly = true;
      ##identityFile = "${homeDir}/.ssh/id_rsa_yubikey.pub";
      identityFile = "${homeDir}/.ssh/id_rsa-arson";
    };
  };

  programs.direnv.enable = true;
  programs.direnv.stdlib = ''
    source ${nix-direnv}/share/nix-direnv/direnvrc
  '';

  programs.bash.enable = true;

  programs.zsh = {
    enable = true;
    history = {
      size = 50000;
      save = 50000;
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.6.3";
          sha256 = "1h8h2mz9wpjpymgl2p7pc146c1jgb3dggpvzwm9ln3in336wl95c";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "be3882aeb054d01f6667facc31522e82f00b5e94";
          sha256 = "0w8x5ilpwx90s2s2y56vbzq92ircmrf0l5x8hz4g1nx3qzawv6af";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "aws"
        "docker"
        ##"kubectl"
      ];
      theme = "robbyrussell";
    };
    shellAliases = {
      git = "hub";
      gs = "git status";
      gc = "git commit";
      gl = "git log";
      ga = "git add";
      gb = "git checkout";
      p = "git pull";
      push = "git push";
      pr = "hub pull-request";
      ##okp = "okta-aws-login -p production -u $USER";
      ##okd = "okta-aws-login -p development -u $USER";
    };
    enableAutosuggestions = true;
    sessionVariables = {
      AWS_PROFILE = "development";
      EDITOR = "vim";
      VISUAL = "vim";
      GIT_EDITOR = "vim";
      HOME_MANAGER_CONFIG = "${homeDir}/home.nix";
    };
    initExtraBeforeCompInit = builtins.readFile ./home/pre-compinit.zsh;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = false;
  };
  programs.fzf.enable = true;
  programs.git = {
    enable = true;
    userName = "Brandon Orther";
    userEmail = "brandon@orther.dev";
    #signing.key = "0xC717DCA60748D52A";
    #signing.signByDefault = true;
    extraConfig = {
      ##user.signingKey = builtins.readFile ./local/signingKey.txt;
      user.signingKey = "0xC717DCA60748D52A";
      commit.gpgsign = true;
      branch.autosetupmerge = "always";
      push.default = "current";
      hub.protocol = "ssh";
      github.user = "amarrella";
      color.ui = true;
      pull.rebase = true;
      core.commitGraph = true;
      core.excludesfile = "/Users/${username}/.gitignore_global";
      core.editor = "vim";
      credential.helper = "osxkeychain";
      url = { "git@github.com:" = { insteadOf = "https://github.com/"; }; };
    };
  };
  home.file.".gitignore_global".source = ./home/.gitignore_global;

}
