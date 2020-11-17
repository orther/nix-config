# Nix Configuration

This is my personal nix configuration and might not work for anyone else but feel free to fork it :) 

**Note:** copied from [amarrella/nix-config](https://github.com/amarrella/nix-config)

## How to install
1. Install Nix (assume using Catalina:
   `bash <(curl https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon`
2. [Install cachix and use orther cache](https://app.cachix.org/cache/orther).
3. Install [nix-darwin](https://github.com/LnL7/nix-darwin/) 
4. Install [home-manager](https://rycee.gitlab.io/home-manager/index.html#sec-install-nix-darwin-module) as nix-darwin module
5. `git clone https://github.com/orther/nix-config ~/.nixpkgs`
6. (skipped) `echo -n "your_email@your_provider.tld" > ~/.nixpkgs/local/userEmail.txt`
7. (skipped) `echo -n "YOUR_SIGNING_KEY" > ~/.nixpkgs/local/signingKey.txt`
8. `darwin-rebuild switch`


## Emacs

Following [this gist](https://gist.github.com/mjlbach/179cf58e1b6f5afcb9a99d4aaf54f549) and using this [custom overlay](https://gist.github.com/mjlbach/179cf58e1b6f5afcb9a99d4aaf54f549) that fixes gccEmacs for macOS.

### Install Emacs

``` sh
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use mjlbach
# nix-env -iA nixpkgs.emacsGcc
```

### Update Emacs

``` sh
nix-env -iA nixpkgs.emacsGcc
```
