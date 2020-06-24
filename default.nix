{ pkgs ? import <nixpkgs> { } }:

rec {
  modules = import ./modules;
}
