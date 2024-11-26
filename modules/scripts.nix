{ pkgs, ... }:

let
  scriptsDir = ./scripts;

  regularFiles = builtins.attrNames (builtins.readDir scriptsDir);
  scripts = builtins.map (
    file: pkgs.writeScriptBin file (builtins.readFile "${scriptsDir}/${file}")
  ) regularFiles;
in
{
  environment.systemPackages = scripts;
}
