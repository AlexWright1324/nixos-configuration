{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  home-assistant,
}:
buildHomeAssistantComponent rec {
  # https://github.com/BSkando/GoogleFindMy-HA
  owner = "BSkando";
  domain = "googlefindmy";
  version = "1.6-beta3";

  src = fetchFromGitHub {
    owner = "BSkando";
    repo = "GoogleFindMy-HA";
    rev = "V${version}";
    sha256 = "sha256-sntZpIRuAt4746G5u2mc8Wn1V7VEyUWR1gASY9/HCPA=";
  };

  propagatedBuildInputs = with home-assistant.python.pkgs; [
    gpsoauth
    beautifulsoup4
    pyscrypt
    cryptography
    pycryptodomex
    ecdsa
    pytz
    protobuf
    httpx
    h2
    setuptools
    aiohttp
    http-ece
    requests
    undetected-chromedriver
    selenium
  ];
}
