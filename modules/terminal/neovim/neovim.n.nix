{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        languages = {
          enableFormat = true;
          enableDAP = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          nix.enable = true;
          markdown = {
            enable = true;
            extensions = {
              markview-nvim.enable = true;
              render-markdown-nvim.enable = true;
            };
          };
          html.enable = true;
          css.enable = true;
          bash.enable = true;
          ts.enable = true;
          clang.enable = true;
          python.enable = true;
          java.enable = true;
          kotlin.enable = true;
          rust.enable = true;
          sql.enable = true;
          tailwind.enable = true;
          yaml.enable = true;
        };
        git.enable = true;
        spellcheck.enable = false;
        lsp = {
          enable = true;
          formatOnSave = true;
          otter-nvim.enable = true;
        };
        visuals = {
          nvim-cursorline.enable = false;
          nvim-cursorline.setupOpts.cursorline.enable = false;
          cinnamon-nvim.enable = false;
          highlight-undo.enable = true;
          cellular-automaton.enable = true;
        };
        statusline = {
          lualine = {
            enable = false;
          };
        };
        autocomplete.blink-cmp.enable = true;
        telescope.enable = true;
        assistant.avante-nvim = {
          enable = true;
        };
      };
    };
  };
}
