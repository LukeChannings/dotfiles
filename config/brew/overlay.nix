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
    super.brewCasks // {
      maccy = (super.brewCasks.maccy.overrideAttrs (o: {
        nativeBuildInputs = o.nativeBuildInputs ++ [ super.unzip ];
        unpackPhase = "unzip $src";
      }));
      the-unarchiver = (super.brewCasks.the-unarchiver.overrideAttrs (o: {
        nativeBuildInputs = o.nativeBuildInputs ++ [ super.unzip ];
        unpackPhase = "unzip $src";
      }));
      postman = (super.brewCasks.postman.overrideAttrs (o: {
        nativeBuildInputs = o.nativeBuildInputs ++ [ super.unzip ];
        unpackPhase = "unzip $src";
      }));
      tableplus = (super.brewCasks.tableplus.overrideAttrs (
        final: prev: {
          version = "6.2.1-578";
          src = super.fetchurl {
            url = "https://files.tableplus.com/macos/578/TablePlus.dmg";
            sha256 = "sha256-OFDwc4aQJPZqmgpEOxk9IE4NXd6R86LtDbMFDqtKuZQ=";
          };
        }
      ));
    }
    // (builtins.mapAttrs overrideHash {
      apparency = "sha256-nktNbyJOXDydQPwb43Uq3nQv65XcwrqZTKu5OCcLyfU=";
      suspicious-package = "sha256-//iL7BRdox+KA1CJnGttUQiUfskuBeMGrf1YUNt/m90=";
      bonjour-browser = "sha256-+crlyoU0zPu+oilrTyLIOO61H7U9bkyDWe8EpWJfnOQ=";
      audio-hijack = "sha256-hzZbGfM0h7nrEqatRFMtTh3NQ0yFgGEyUVawvk3LpaQ=";
      logitech-options = "sha256-mqrGGSphCylYzkFl5iV/LTxofhy+4KoCxqG/WhkG0wM=";
    });
})
