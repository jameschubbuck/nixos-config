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
        # set fish_greeting

        # Force load Pure if not already there
        if not functions -q fish_prompt
            set -l prompt_file (functions --details fish_prompt)
            if test -n "$prompt_file"
                source $prompt_file
            end
        end

        if not functions -q _pure_prompt_orig
            functions --copy fish_prompt _pure_prompt_orig
        end

        function fish_prompt
            # Only trigger on directory change
            if test "$PWD" != "$_last_pwd_viewed"
                set -g _last_pwd_viewed "$PWD"
                script -q -c "lsd --color=always --icon=always --group-directories-first --ignore-glob='__pycache__' --ignore-glob='*.lock'" /dev/null
                echo
            end

            _pure_prompt_orig
        end
      '';
      plugins = [
        {
          name = "transient-fish";
          src = pkgs.fishPlugins.transient-fish.src;
        }
        {
          name = "puffer";
          src = pkgs.fishPlugins.puffer.src;
        }
        {
          name = "pure";
          src = pkgs.fishPlugins.pure.src;
        }
        {
          name = "sudope";
          src = pkgs.fishPlugins.plugin-sudope.src;
        }
        {
          name = "pisces";
          src = pkgs.fishPlugins.pisces.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
      ];

      shellAliases = {
        "v" = "vi";
        # Added --group-directories-first for better "ephemeral" scanning
        "ls" = "lsd --group-directories-first --ignore-glob='__pycache__' --ignore-glob='*.lock'";
        "tree" = "tree -I '__pycache__|*.lock'";
        "nix-shell" = "nix-shell --command 'fish'";
        "librepods" = "/etc/nixos/modules/packages/librepods.sh";
        "oc" = "opencode";
        "logout" = "loginctl terminate-user $USER";
      };

      functions = {
        # 2. Removed 'on_pwd_change' from here to fix the lazy-load bug.

        c = {
          body = ''
            cat $argv | wl-copy
          '';
        };
      };
    };
  };
}
