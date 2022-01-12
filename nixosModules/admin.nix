{ config, pkgs, ... }:

{
  users.users.admin = {
    name = "admin";
    initialPassword = "1234";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "your SSH public key here goes here" ];
  };
  security.sudo.wheelNeedsPassword = false;
  nix.trustedUsers = [ "@wheel" ]; # https://github.com/serokell/deploy-rs/issues/25
}
