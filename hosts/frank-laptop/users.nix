{ inputs, ... }:

{
  users.users.frank = {
    isNormalUser = true;
    description = "Frank Wright";
  };
}
