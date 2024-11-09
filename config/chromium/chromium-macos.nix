{
  lib,
  fetchurl,
  darwin,
  stdenv,
  undmg,
  unzip,
  gzip,
  _7zz,
  makeWrapper,
  xar,
  cpio,
}:
let
  version = "130.0.6723.91-1.1";
in
stdenv.mkDerivation rec {
  name = "chromium";
  pname = name;
  inherit version;

  src = fetchurl {
    url = "https://github.com/claudiodekker/ungoogled-chromium-macos/releases/download/${version}/ungoogled-chromium_${version}_${
      if stdenv.isAarch64 then "arm64" else "x86-64"
    }-macos-signed.dmg";
    hash =
      if stdenv.isAarch64 then
        "sha256-lKIWAWvJhk18+nM4nUqwbXY/iDvvb47KfvmzN4HaRQY="
      else
        "sha256-ok8FzdiynM/rq8M9ustfs+uta0g+AWFR92GPuXvrDh8=";
  };

  nativeBuildInputs = [
    undmg
    unzip
    gzip
    _7zz
    makeWrapper
    xar
    cpio
    darwin.xattr
  ];

  unpackPhase = ''
    undmg $src || 7zz x -snld $src
  '';

  sourceRoot = "Chromium.app";

  dontPatchShebangs = true;

  installPhase = ''
    mkdir -p "$out/Applications/${sourceRoot}"
    cp -R . "$out/Applications/${sourceRoot}"

    makeWrapper "$out/Applications/${sourceRoot}/Contents/MacOS/${lib.removeSuffix ".app" sourceRoot}" $out/bin/chromium
  '';

  meta = {
    homepage = "https://github.com/claudiodekker/ungoogled-chromium-macos";
    description = "Codesigned builds of Chromium";
    platforms = lib.platforms.darwin;
    mainProgram = "Chromium";
  };
}
