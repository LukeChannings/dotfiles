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
  version = "135.0.7049.52-1.1";
in
assert lib.asserts.assertMsg (
  stdenv.isAarch64 != "arm64"
) "ungoogled-chromium only supports aarch64";
stdenv.mkDerivation rec {
  name = "chromium";
  pname = name;
  inherit version;

  src = fetchurl {
    url = "https://github.com/ungoogled-software/ungoogled-chromium-macos/releases/download/${version}/ungoogled-chromium_${version}_arm64-macos.dmg";
    hash = "sha256-ePEeKAD2yNkY37ns4vdKJM78qsI6ik4kyL/4LL5WUpY=";
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
