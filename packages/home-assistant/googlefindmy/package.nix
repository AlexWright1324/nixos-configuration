{
  fetchFromGitHub,
  buildHomeAssistantComponent,
  home-assistant,
}:
buildHomeAssistantComponent rec {
  # https://github.com/BSkando/GoogleFindMy-HA
  owner = "BSkando";
  domain = "googlefindmy";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "BSkando";
    repo = "GoogleFindMy-HA";
    rev = "V${version}";
    sha256 = "sha256-BDzYu/LLKThzvGJJowa+ZF8f/XHg8+++EpmOrJEymtg=";
  };

  propagatedBuildInputs = with home-assistant.python.pkgs; [
    gpsoauth
    beautifulsoup4
    pyscrypt
    cryptography
    pycryptodomex
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

  permittedInsecurePackages = [
    "python3.13-ecdsa-0.19.1"
  ];
}
