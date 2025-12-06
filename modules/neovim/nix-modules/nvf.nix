{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          nix.enable = true;
          markdown.enable = true;
          html.enable = true;
          css.enable = true;
          bash.enable = true;
          ts.enable = true;
          python.enable = true;
        };
        git.enable = true;
        spellcheck.enable = true;
        lsp = {
          enable = true;
          formatOnSave = true;
          otter-nvim.enable = true;
        };
        visuals = {
          nvim-cursorline.enable = true;
          nvim-cursorline.setupOpts.cursorline.enable = true;
          cinnamon-nvim.enable = true;
          highlight-undo.enable = true;
          cellular-automaton.enable = true;
        };
        statusline = {
          lualine = {
            enable = true;
          };
        };
        autocomplete.blink-cmp.enable = true;
        filetree = {
          neo-tree = {
            enable = true;
          };
        };
        treesitter.context.enable = true;
        telescope.enable = true;
        dashboard.alpha.enable = true;
        projects = {
          project-nvim.enable = true;
        };
        keymaps = [
          {
            key = "<leader>wq";
            mode = ["n"];
            action = ":wq<CR>";
            silent = true;
            desc = "Save file and quit";
          }
          {
            key = "<leader>fml";
            mode = ["n"];
            action = ":CellularAutomaton make_it_rain<CR>";
            silent = true;
            desc = "Embrace sadness";
          }
        ];
      };
    };
  };
}
