# based on help from:
#   http://sandervanderburg.blogspot.com/2014/07/managing-private-nix-packages-outside.html
#
{ system ? builtins.currentSystem }:
let
  nixpkgs = import <nixpkgs> { inherit system; };
  nixpkgsCross32 = import <nixpkgs> {
    inherit system;
    crossSystem = nixpkgs.lib.systems.examples.mingw32;
  };
  nixpkgsCross64 = import <nixpkgs> {
    #inherit system;
    #crossSystem = nixpkgs.lib.systems.examples.mingwW64;
    crossSystem = {
      config = "x86_64-pc-mingw32";
      libc = "msvcrt";
      platform = {};
    };
  };
  callPackageCross32 = nixpkgsCross32.lib.callPackageWith (nixpkgsCross32 // nixpkgs.xlibs // self);
  callPackageCross64 = nixpkgsCross64.lib.callPackageWith (nixpkgsCross64 // nixpkgs.xlibs // self);
  self = {
     nixwin32 = callPackageCross32 ./pkgs/nixwin { };
     nixwin64 = callPackageCross64 ./pkgs/nixwin { boost = nixpkgs.boost; };
  };
in self
