{
  pkgs,
  lib,
  ...
}:
pkgs.buildNpmPackage {
  name = "nova-sdr_frontend";

  src = pkgs.fetchFromGitHub {
    owner = "Steven9101";
    repo = "frontend";
    rev = "9c1daed5760b1da1deb6ba29c48b9e1bdad354ec";
    sha256 = "sha256-ybblFVqs10LJw7Ml4+2ylOLCbiV8JpuBLZQbNr7zps8=";
  };

  npmDepsHash = "sha256-TkR4cXO4uW4sR0piLSVa6PRAlYzrk1yUcxpGKTQUN4g=";

  installPhase = ''
    mkdir -p $out
    cp -r dist/* $out
  '';

  meta = with lib; {
    description = "A modern, web-enabled SDR server with a fast Svelte frontend";
    homepage = "https://github.com/Steven9101/NovaSDR";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
