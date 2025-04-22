{ inputs, ... }:

{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "alexw" = import ./alexw;
    };
  };
}
