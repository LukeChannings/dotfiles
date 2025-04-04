{
  # https://docs.atuin.sh/configuration/config/
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_address = "https://atuin.svc.channings.me";
      workspaces = true;
      ctrl_n_shortcuts = true;
      dialect = "uk";
      filter_mode = "host";
      filter_mode_shell_up_key_binding = "session";
      style = "compact";
      inline_height = 5;
      show_help = false;
      enter_accept = true;

      sync.records = true;
    };
  };
}
