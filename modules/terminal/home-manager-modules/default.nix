{pkgs, ...}: {
  home.packages = with pkgs; [
    lsd
    tree
    grc
    ripgrep
  ];
  programs = {
    ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        window-padding-x = 0;
        window-padding-y = 0;
        command = "/run/current-system/sw/bin/fish --login --interactive";
      };
    };
    fish = {
      enable = true;
      generateCompletions = true;
      interactiveShellInit = ''
        set fish_greeting
        function fish_user_key_bindings
          bind \t forward-char
          bind \e\[C complete
        end
      '';
      plugins = [
        {
          # Transient Prompt
          name = "transient-fish";
          src = pkgs.fishPlugins.transient-fish.src;
        }
        {
          # Turn ... -> ../..
          name = "puffer";
          src = pkgs.fishPlugins.puffer.src;
        }
        {
          # Minimal prompt
          name = "pure";
          src = pkgs.fishPlugins.pure.src;
        }
        {
          # Press `Esc` twice to prefix current command with sudo
          name = "sudope";
          src = pkgs.fishPlugins.plugin-sudope.src;
        }

        {
          # Pair matched symbols like "" or ()
          name = "pisces";
          src = pkgs.fishPlugins.pisces.src;
        }
        {
          # Notify when long running processes finish
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
      ];
      shellAliases = {
        "v" = "vi";
        "c" = "cat";
        "ls" = "lsd";
      };
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
