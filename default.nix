{ pkgs ? import <nixpkgs> { } }:

rec {
  modules = import ./modules;
  akd = pkgs.libsForQt5.callPackage ./pkgs/akd { };
  insync3 = pkgs.libsForQt5.callPackage ./pkgs/insysnc3 { };
  ytmdesktop = pkgs.callPackage ./pkgs/ytmdesktop { };
}
