{ inputs, ... }:
{
  imports = [
    inputs.toolbox.modules.darwin.link-apps
  ];
}
