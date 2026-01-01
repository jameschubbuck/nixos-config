{pkgs, ...}: {
  home.packages = with pkgs; [
    lsd
    tree
    grc
    ripgrep
    wl-clipboard-rs
    waybar
  ];
  programs = {
    fish = {
      enable = true;
      generateCompletions = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
      plugins = [
        {
          name = "transient-fish"; # Transient Prompt
          src = pkgs.fishPlugins.transient-fish.src;
        }
        {
          name = "puffer"; # Turn ... -> ../..
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
        "ls" = "lsd --ignore-glob='__pycache__' --ignore-glob='*.lock'";
        "tree" = "tree -I '__pycache__|*.lock'";
        "nix-shell" = "nix-shell --command 'fish'";
        "librepods" = "/etc/nixos/modules/packages/librepods.sh";
      };
      functions = {
        c = {
          body = ''
            cat $argv | wl-copy
          '';
        };
      };
    };
  };
}
