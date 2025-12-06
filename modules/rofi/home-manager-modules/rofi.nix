{
  config,
  pkgs,
  ...
}: {
  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi;
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "configuration" = {
          auto-select = true;
          show-icons = true;
          display-drun = "";
          drun-display-format = "{name}";
        };
        # "*" = {
        #   text-color = mkLiteral "#839496";
        #   background-color = mkLiteral "#000000FF";
        # };
        # "window" = {
        #   location = mkLiteral "north";
        #   anchor = mkLiteral "north";
        #   width = mkLiteral "100%";
        #   margin = mkLiteral "5px";
        #   padding = mkLiteral "4px";
        #   border-radius = mkLiteral "4px";
        #   border = mkLiteral "0px";
        #   border-color = mkLiteral "var(text-color)";
        #   font = "Geist Mono 12";
        #   children = map mkLiteral ["horibox"];
        #   background-color = mkLiteral "#07364299";
        # };
        # "horibox" = {
        #   orientation = mkLiteral "horizontal";
        #   children = map mkLiteral ["prompt" "entry" "listview"];
        #   background-color = mkLiteral "#00000000";
        # };
        # "entry" = {
        #   enable = false;
        #   expand = false;
        #   width = mkLiteral "0px";
        #   placeholder = "";
        #   background-color = mkLiteral "#00000000";
        # };
        # "listview" = {
        #   layout = mkLiteral "horizontal";
        #   background-color = mkLiteral "#00000000";
        # };
        # "element" = {
        #   background-color = mkLiteral "#586e75";
        #   margin = mkLiteral "0px 4px 0px 4px";
        #   padding = mkLiteral "0px 4px 0px 4px";
        #   border-radius = mkLiteral "4px";
        #   border-color = mkLiteral "var(text-color)";
        #   border = mkLiteral "1px";
        # };
        # "element-text" = {
        #   background-color = mkLiteral "inherit";
        # };
        # "element-icon" = {
        #   background-color = mkLiteral "inherit";
        # };
      };
    };
  };
}
