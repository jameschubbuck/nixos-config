{
  programs.nvf.settings.vim.keymaps = [
    {
      key = "<leader>w";
      mode = ["n"];
      action = ":w<CR>";
      silent = false;
    }
    {
      key = "<leader>q";
      mode = ["n"];
      action = ":q<CR>";
      silent = true;
    }
    {
      key = "<leader>e";
      mode = ["n"];
      action = ":Telescope find_files<CR>";
      silent = true;
    }
    {
      key = "<leader>fml";
      mode = ["n"];
      action = ":CellularAutomaton make_it_rain<CR>";
      silent = true;
    }
  ];
}
