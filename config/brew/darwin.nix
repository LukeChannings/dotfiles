{ ... }:
{
  brew-nix.enable = true;

  nixpkgs.overlays = [
    (_self: super: {
      brewCasks =
        let
          overrideHash = (
            name: hash:
            super.brewCasks.${name}.overrideAttrs (oldAttrs: {
              src = super.fetchurl {
                url = builtins.head oldAttrs.src.urls;
                inherit hash;
              };
            })
          );
        in
        super.brewCasks
        // (builtins.mapAttrs overrideHash {
          apparency = "sha256-nktNbyJOXDydQPwb43Uq3nQv65XcwrqZTKu5OCcLyfU=";
          suspicious-package = "sha256-//iL7BRdox+KA1CJnGttUQiUfskuBeMGrf1YUNt/m90=";
          bonjour-browser = "sha256-+crlyoU0zPu+oilrTyLIOO61H7U9bkyDWe8EpWJfnOQ=";
          audio-hijack = "sha256-hzZbGfM0h7nrEqatRFMtTh3NQ0yFgGEyUVawvk3LpaQ=";
          logitech-options = "sha256-mqrGGSphCylYzkFl5iV/LTxofhy+4KoCxqG/WhkG0wM=";
        });
    })
  ];
}
