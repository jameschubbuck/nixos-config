{...}: {
  programs.git = {
    enable = true;
    settings.user = {
      email = "contact@jameschubbuck.com";
      name = "jameschubbuck";
    };
  };
  programs.gh.enable = true;
}
