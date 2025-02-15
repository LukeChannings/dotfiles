{ user, config, lib, ... }:
let
  hmConfig = config.home-manager.users.${user.name};
in
{
  config.programs.fish.enable = hmConfig.programs.fish.enable;
  config.home-manager.users.${user.name}.programs.fish = {
    loginShellInit =
      let
        # This naive quoting is good enough in this case. There shouldn't be any
        # double quotes in the input string, and it needs to be double quoted in case
        # it contains a space (which is unlikely!)
        dquote = str: "\"" + str + "\"";

        makeBinPathList = map (path: path + "/bin");
      in
      ''
        fish_add_path --move --prepend --path ${
          lib.concatMapStringsSep " " dquote (makeBinPathList config.environment.profiles)
        }
        set fish_user_paths $fish_user_paths
      '';
  };
}
