{
  pkgs,
  lib,
  config,
  ...
}: let
  highlightLua = import ./theme-helper.nix {inherit pkgs lib config;};
in {
  programs.nvf = {
    enable = true;
    settings.vim = {
      options = {
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
      };
      theme.transparent = true;
      ui.borders.enable = true;
      luaConfigPost =
        ''
          vim.keymap.set({'n', 'x', 'o'}, '<leader>s', function()
            require('leap').leap { windows = { vim.fn.win_getid() } }
          end, { desc = 'Leap bidirectional' })
        ''
        + "\n"
        + builtins.readFile ./lua/telescope.lua
        + "\n"
        + highlightLua;
      spellcheck = {
        enable = true;
      };
      lsp = {
        enable = true;
        formatOnSave = true;
        lspSignature.enable = true;
      };
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        nix.enable = true;
        svelte.enable = true;
        markdown.enable = true;
        ts.enable = true;
        astro.enable = true;
        clang.enable = true;
        tailwind.enable = true;
        rust.enable = true;
      };
      statusline = {
        lualine = {
          enable = true;
        };
      };
      autopairs.nvim-autopairs.enable = true;
      autocomplete = {
        nvim-cmp.enable = true;
      };
      snippets.luasnip.enable = true;
      treesitter.context.enable = true;
      telescope.enable = true;
      utility = {
        diffview-nvim.enable = true;
        motion = {
          leap.enable = true;
          leap.mappings = {
            leapForwardTo = null;
            leapBackwardTo = null;
            leapForwardTill = null;
            leapBackwardTill = null;
            leapFromWindow = null;
          };
        };
      };
      comments = {
        comment-nvim.enable = true;
      };
    };
  };
}
