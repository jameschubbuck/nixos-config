{lib, ...}: let
  mkKeymap = {
    key,
    action,
    mode ? ["n"],
    silent ? true,
    desc ? null,
  }:
    {
      inherit key action mode silent;
    }
    // lib.optionalAttrs (desc != null) {
      inherit desc;
    };

  keymaps = [
    (mkKeymap {
      key = "<leader>w";
      action = ":w<CR>";
      silent = false;
    })
    (mkKeymap {
      key = "<leader>q";
      action = ":q<CR>";
    })
    (mkKeymap {
      key = "<leader>e";
      action = ":Telescope find_files<CR>";
    })
  ];
in {
  programs.nvf.settings.vim.keymaps = keymaps;
}
