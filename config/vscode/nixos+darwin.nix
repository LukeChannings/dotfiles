{ inputs, ... }:
{
  imports = [
    {
      nixpkgs.overlays = [
        inputs.vscode-extensions.overlays.default

        # (self: super: {
        #   vscodium = super.vscodium.overrideAttrs (
        #     prev:
        #     let
        #       sha256 =
        #         {
        #           x86_64-linux = "095ilb9b8703lik5ssgs94b7z640pnmwwphnrilwzdj639ldjzf8";
        #           x86_64-darwin = "1a733b8c254fa63663101c52568b0528085baabe184aae3d34c64ee8ef0142d5";
        #           aarch64-linux = "0m9yf7ks4y6mw1qz5h1clw0s7vwn8yca830f98v69a3f2axb2x8i";
        #           aarch64-darwin = "c47c8e1df67fdbcbb8318cdccaf8fa4f7716cb2ed5e8359c09319d9a99a1a4b6";
        #         }
        #         .${self.system} or (throw "Unsupported system: ${self.system}");
        #       plat =
        #         {
        #           x86_64-linux = "linux-x64";
        #           x86_64-darwin = "darwin-x64";
        #           aarch64-linux = "linux-arm64";
        #           aarch64-darwin = "darwin-arm64";
        #           armv7l-linux = "linux-armhf";
        #         }
        #         .${self.system} or (throw "Unsupported system: ${self.system}");

        #       archive_fmt = if self.stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";
        #       version = "1.97.2.25045";
        #       src = self.fetchurl {
        #         url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-${plat}-${version}.${archive_fmt}";
        #         inherit sha256;
        #       };
        #     in
        #     {
        #       inherit version src;
        #     }
        #   );
        # })
      ];
    }
  ];
}
