{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05-small";
  inputs.elixir-overlay.url = "github:zoedsoupe/elixir-overlay";

  outputs = {
    nixpkgs,
    elixir-overlay,
    ...
  }: let
    inherit (nixpkgs.lib) genAttrs;
    inherit (nixpkgs.lib.systems) flakeExposed;

    forSystem = system:
      import nixpkgs {
        inherit system;
        overlays = [elixir-overlay.overlays.default];
      };
    forAllSystems = f: genAttrs flakeExposed (system: f (forSystem system));
  in {
    devShells = forAllSystems (pkgs: let
      inherit (pkgs) mkShell erlang_28 elixir-with-otp;
      elixir_1_18 = (elixir-with-otp erlang_28).latest;
    in {
      default = mkShell {
        name = "check-service-dev";
      };
      packages = with pkgs; [elixir_1_18 erlang_28 make];
    });
  };
}
