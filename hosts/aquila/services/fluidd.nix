{
  services = {
    fluidd = {
      enable = true;
    };
    nginx = {
      clientMaxBodySize = "1000m";
    };
  };
}
