{ inputs, ... }: {
  imports = [
    {
      nixpkgs.overlays = [
        inputs.vscode-extensions.overlays.default
      ];
    }
  ];
}
