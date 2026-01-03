{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    programs.opencode = {
      enable = true;
      settings = {
        theme = "catppuccin-macchiato";
      };
    };
    home.packages = [pkgs.libnotify];
    xdg.configFile."opencode/plugin/notify.ts".text = ''
      import type { Plugin } from "@opencode-ai/plugin"

      export const NotifyPlugin: Plugin = async ({ $ }) => {
        const notifyPath = "${pkgs.libnotify}/bin/notify-send";

        return {
          event: async ({ event }) => {
            switch (event.type) {
              case "session.idle":
                await $`''${notifyPath} "OpenCode" "Task finished!"`;
                break;
              case "session.error":
                await $`''${notifyPath} -u critical "OpenCode Error" "Something went wrong."`;
                break;
              case "permission.updated":
                await $`''${notifyPath} -u normal "OpenCode" "Waiting for input..."`;
                break;
            }
          },
        };
      };
    '';
  };
}
