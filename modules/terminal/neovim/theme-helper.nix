{
  config,
  lib,
  ...
}: let
  colors = config.lib.stylix.colors.withHashtag;
  transparentGroups = [
    "Normal"
    "NormalNC"
    "NormalFloat"
    "FloatBorder"
    "SignColumn"
    "LineNr"
    "CursorLineNr"
    "EndOfBuffer"
    "GitSignsAdd"
    "GitSignsChange"
    "GitSignsDelete"
    "DiagnosticSignError"
    "DiagnosticSignWarn"
    "DiagnosticSignInfo"
    "DiagnosticSignHint"
    "TelescopeNormal"
    "TelescopePromptNormal"
    "TelescopeResultsNormal"
    "TelescopePreviewNormal"
    "TelescopePromptPrefix"
    "FoldColumn"
    "Folded"
    "GitSignsCurrentLineBlame"
    "GitSignsAddLn"
    "GitSignsChangeLn"
    "GitSignsDeleteLn"
  ];
  borderGroups = [
    "TelescopeBorder"
    "TelescopePromptBorder"
    "TelescopeResultsBorder"
    "TelescopePreviewBorder"
  ];
  mkTransparentHighlight = group: ''vim.cmd("highlight ${group} guibg=NONE ctermbg=NONE")'';
  mkBorderHighlight = group: ''vim.cmd("highlight ${group} guibg=NONE ctermbg=NONE guifg=${colors.base0D}")'';
in
  lib.concatStringsSep "\n" (
    (map mkTransparentHighlight transparentGroups)
    ++ (map mkBorderHighlight borderGroups)
    ++ [''vim.cmd("highlight TelescopeSelection guibg=NONE ctermbg=NONE guifg=${colors.base0E}")'']
  )
