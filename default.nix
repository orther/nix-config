let
  sources = import ./nix/sources.nix;
  nix-pre-commit-hooks = import sources.pre-commit-hooks;
in
{
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      nixpkgs-fmt.enable = true;
    };
  };
}
