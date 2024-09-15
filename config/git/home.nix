{
  programs.git = {
    enable = true;

    extraConfig = {
      pull.rebase = true;
      rebase.autostash = true;
      push.autosetupremote = true;
      init.defaultBranch = "main";
    };

    lfs.enable = true;
    difftastic.enable = true;
  };
}
