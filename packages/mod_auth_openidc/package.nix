{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  pkg-config,
  apacheHttpd,
  cjose,
  openssl,
  curl,
  jansson,
  pcre,
  apr,
  aprutil,
}:
stdenv.mkDerivation rec {
  pname = "mod_auth_openidc";
  version = "2.4.17";

  src = fetchurl {
    url = "https://github.com/OpenIDC/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-JKWzOavNRdhSGJtfzu+fe+dbqbV56ihkRer0YtUsdD8=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    apacheHttpd
    cjose
    openssl
    curl
    jansson
    pcre
    apr
    aprutil
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/modules
    cp .libs/mod_auth_openidc.so $out/modules

    runHook postInstall
  '';

  meta = {
    description = "OpenID Certified™ OpenID Connect and FAPI 2 Relying Party module for Apache HTTPd";
    homepage = "https://github.com/OpenIDC/mod_auth_openidc";
    changelog = "https://github.com/OpenIDC/mod_auth_openidc/releases";
    license = lib.licenses.asl20;
  };
}
