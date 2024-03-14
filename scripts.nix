{ pkgs, lib, ... }:

let
  # Define the directory where your scripts are located
  scriptsDir = ./scripts;

  # Generate a list of all regular files in the scripts directory
  regularFiles = lib.debug.traceValSeq (builtins.attrNames (builtins.readDir scriptsDir));

  # Generate a list of all scripts in the scripts directory
  scripts = lib.debug.traceVal (builtins.map (file: 
    pkgs.writeScriptBin file (
      builtins.readFile "${scriptsDir}/${file}"
    )
  ) regularFiles);
in
{
  # Your existing NixOS configuration goes here

  # Include all scripts in the systemPackages environment
  environment.systemPackages = scripts;
}
