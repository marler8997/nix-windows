{ stdenv, fetchFromGitHub,
  #coreutils,
  #
  #
  # meson not working because:
  # error: Package ‘python3-3.6.8’ in /nix/store/4qzln7zg70xfz5ws3xhl2bh9kyia1nan-nixos-18.09.2505.46d3867a08a/nixos/pkgs/development/interpreters/python/cpython/3.6/default.nix:215 is not supported on ‘x86_64-pc-mingw32’, refusing to evaluate.
  #meson,
  #ninja,
  boost
  #gcc ? null, cc ? gcc,
  #tinycc ? null, cc ? tinycc,
}:

stdenv.mkDerivation rec {
  pname = "nixwin";
  version = "0.0";
  name = "${pname}-${version}";
  srcs = [
    (fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "bb6e6923f25841874b6a915d234d884ddd4c92dd";
      sha256 = "13a15vy0vnkf1v5j85pmnnw0vmik68dr6xmg2czj87qppwflv74k";
      name = "nix";
    })
    ../../src
  ];
  sourceRoot = ".";
  buildDeps = [ boost ];
  #buildInputs = [ meson ninja ];
  #buildInputs = [ cc ];
  doCheck = true;
  buildPhase = ''
    echo boost.dev is at ${boost.dev}
    libutil_src=(
      affinity.cc
      archive.cc
      args.cc
      compression.cc
      config.cc
      hash.cc
      json.cc
      logging.cc
      serialise.cc
      thread-pool.cc
      util.cc
      xml-writer.cc
    )
    libutil_src2=(nix/src/libutil/*.cc)
    libutil_src2=''${libutil_src2[@]/affinity.cc}
    $CXX -I${boost.dev}/include ''${libutil_src2[@]}
    ls -l
    exit 1
    $CXX nix/src/libstore/*.cc
    ls -l
    exit 1
    declare -xp
    ls -l nix/src
    make -C nix
    $CXX -o nix-store.exe src/nixwin-store.cc
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp nix-store.exe $out/bin
  '';
  #buildPhase = ''
  #  set -x
  #  pwd
  #  ls -l
  #  set +x
  #  ${meson}/bin/meson out
  #  ${ninja}/bin/ninja -C out
  #'';
  #checkPhase = ''
  #  echo nothing to check yet
  #'';
  #installPhase = ''
  #  mkdir -p $out/bin
  #  cp out/nix-store.exe $out/bin
  #'';
  meta = {
    description = "Fill in later";
  };
}
