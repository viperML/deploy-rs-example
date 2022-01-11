{
  description = "My server flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    flake-utils-plus.url = github:gytis-ivaskevicius/flake-utils-plus;
    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };
    deploy-rs = {
      url = github:serokell/deploy-rs;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, flake-utils-plus, ... }:
    let
      lib = nixpkgs.lib;
      nixosModules = flake-utils-plus.lib.exportModules (
        lib.mapAttrsToList (name: value: ./nixosModules/${name}) (builtins.readDir ./nixosModules)
      );
    in
    flake-utils-plus.lib.mkFlake {
      inherit self inputs nixosModules;

      hosts = {
        hetzner.modules = with nixosModules; [
          common
          admin
          hardware-hetzner
        ];
      };

      outputsBuilder = (channels: {

        devShell = channels.nixpkgs.mkShell {
          name = "my-deploy-shell";
          buildInputs = with channels.nixpkgs; [
            nixUnstable
            inputs.deploy-rs.defaultPackage.${system}
            gptfdisk
            util-linux
            btrfs-progs
          ];
          shellHook =
            let
              run-format = channels.nixpkgs.writeShellScriptBin
                "run-format"
                "${builtins.readFile ./format.sh}"
                ;
            in ''
              export PATH="${run-format}/bin:$PATH"
            '';
        };

      });

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
    };
}
