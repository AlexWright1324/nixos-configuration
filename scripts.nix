{ pkgs, ... }:

let
  # Define the directory where your scripts are located
  scriptsDir = ./scripts;

  # Generate a list of all scripts in the scripts directory
  scripts = builtins.map (name: script: pkgs.writeScriptBin name script) (builtins.ls scriptsDir);

in
{
  # Your existing NixOS configuration goes here

  # Include all scripts in the systemPackages environment
  environment.systemPackages = scripts;
}
