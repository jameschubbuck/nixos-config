{
  programs.nvf = {
    enable = true;
    settings.vim = {
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
        markdown.enable = true;
      };
      visuals = {
        highlight-undo.enable = true;
        indent-blankline.enable = true;
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

      git = {
        enable = true;
        gitsigns.enable = true;
      };

      utility = {
        diffview-nvim.enable = true;
        motion = {
          hop.enable = true;
          leap.enable = true;
        };
      };

      comments = {
        comment-nvim.enable = true;
      };
    };
  };
}
